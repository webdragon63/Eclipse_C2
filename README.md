# Eclipse_C2 Framework
![1000003491](https://github.com/user-attachments/assets/acda833e-d678-422a-87d0-6a290eefd5c1)


This is a simple c2 framework that allows to use teamserver for managing multiple clients and forwarding their connections to netcat listeners, and the other hand it allows to use netcat multi-handler for managing a single client. 

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
git clone https://github.com/webdragon63/Eclipse_C2.git
cd Eclipse_C2
```

## Usage
```sh
bash eclipse_c2.sh
```
The program will prompt you for:
1. **C2 Host**: The host address where the server will run.
2. **C2 Port**: The port number to listen for incoming client connections.
3. **Netcat Multi-Handler Host**: The host address where the netcat multi-handler will run.
4. **Netcat Multi-Handler Port**: The port number to listen for incoming client connections.

### After starting a teamserver, it will:
- Wait 1 second and launch Netcat listeners on ports 2001, 2002, 2003, 2004 and 2005 using `xterm`.
- Accept incoming client connections and forward them to the Netcat listeners.
- Maintain interactive communication between the clients and listeners.

### After starting a Netcat Multi-Handler, it will:
- Shows the payload options to choose a payload.
- After choosing a payload it willl start the netcat listener in a single port.

## Notes
- Ensure ports 2001, 2002, 2003, 2004 and 2005 are not in use before running the server.
- For Windows clients, use a compatible reverse shell payload.

## Created by
INDIAN CYBER ARMY >>(WebDragon63)
YT CHANNEL: https://www.youtube.com/@indiancyberarmy5
