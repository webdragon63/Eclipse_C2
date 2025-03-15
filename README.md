# C2 Framework

This is a simple C2 (Command and Control) framework that allows managing multiple clients and forwarding their connections to Netcat listeners.

## Features
- User-defined IP and port for the C2 server.
- Automatic forwarding of client connections to Netcat listeners.
- Support for interactive reverse shell execution.
- Uses `xterm` to launch Netcat listeners.
- Multi-threaded handling of clients.
- Non-blocking socket communication with `select()`.

## Requirements
- Linux system
- Netcat (`nc`)
- xterm

## Installation
```sh
sudo apt update && sudo apt install netcat xterm -y
```

## Usage
```sh
bash eclipse_c2.sh
```
The program will prompt you for:
1. **C2 Host**: The host address where the server will run.
2. **C2 Port**: The port number to listen for incoming client connections.

After starting, it will:
- Wait 1 second and launch Netcat listeners on ports 2001, 2002, 2003, 2004 and 2005 using `xterm`.
- Accept incoming client connections and forward them to the Netcat listeners.
- Maintain interactive communication between the clients and listeners.

## Notes
- Ensure ports 2001, 2002, 2003, 2004 and 2005 are not in use before running the server.
- For Windows clients, use a compatible reverse shell payload.


