# Eclipse_C2 Framework
![1000003491](https://github.com/user-attachments/assets/acda833e-d678-422a-87d0-6a290eefd5c1)

An advance cli based C2 framework that allows you to create multiple reverse shell which are capable to handle 15 clients using a normal teamserver with custom reverse shell scripts and a scripted web_deivery_method. It is also have an inbuilt single netcat-multihandler to handle a single client (if needed).

> :warning: This is on early stage. I will develop this tool in future.
> :ballot_box_with_check: :ok: ***TESTED ON MATE TERMINAL***
## Features
- User-defined IP and port for the C2 server.
- Supports Scripted-Web-Dlivery method.
- Supports C-based reverse shell beacon for Linux and Windows both.
- Automatic forwarding of client connections to Netcat listeners.
- Support for interactive reverse shell execution.
- Uses normal "gnome-terminal" to launch Netcat listeners.
- Maximum 15 clients support.

- ## Requirements
- Linux system
- Netcat (`nc`)
- gnome-terminal


## Installation
```sh
sudo apt update && sudo apt install gnome-terminal -y
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
3. **Port for Web Delivery**: The port for hosting a powershell payload.
4. **Netcat Multi-Handler Host**: The host address where the netcat multi-handler will run.
5. **Netcat Multi-Handler Port**: The port number to listen for incoming client connections.


### After starting a Scripted_Web_Delivery service, it will:
![Screenshot at 2025-04-06 15-37-54](https://github.com/user-attachments/assets/85e24503-cd6b-4520-833a-fa31439438dd)
![Screenshot at 2025-04-06 15-38-48](https://github.com/user-attachments/assets/defdbcb4-3a9d-4c30-962a-d3c830fe7218)

- Hosts a powershell payload to deliver it over the target via a web server. 
- Wait 1 second and launch Netcat listeners on ports 2000 to 2014 using `gnome-terminal`.
- Gives you a CMD command to execute on a target's commmand prompt.
- Accept incoming client connections and forward them to the Netcat listeners.
- Maintain interactive communication between the clients and listeners.
### Note: After using this web_delivery_service method you need to run the `pkiller.sh` file manually with `bash pkiller.sh` command to stop any background process of the web_delivery service at the end. 

### After starting a teamserver, it will:
![Screenshot at 2025-04-06 15-40-40](https://github.com/user-attachments/assets/19b9c975-a7bd-45d6-956e-1aca26925491)

- Wait 1 second and launch Netcat listeners on ports 2000 to 2014 using `gnome-terminal`.
- Accept incoming client connections and forward them to the Netcat listeners.
- Maintain interactive communication between the clients and listeners.

### After starting a Beacon for Windows, it will:
![Screenshot at 2025-04-06 15-42-06](https://github.com/user-attachments/assets/5673b4a3-4cc0-4c3d-a84d-4b53af320328)
![Screenshot at 2025-04-06 15-42-14](https://github.com/user-attachments/assets/87c65686-d62e-4074-add1-4f4b073de4a4)

- Ask you for C2 host and C2 port. Then ask you for the path and name for the beacon
- Wait 1 second and launch Netcat listeners on ports 2000 to 2014 using `gnome-terminal`.
- Accept incoming client connections and forward them to the Netcat listeners.
- Maintain interactive communication between the clients and listeners.

### After starting a Beacon for Linux, it will:
![Screenshot at 2025-04-06 15-43-08](https://github.com/user-attachments/assets/8a394762-58c2-454e-b1b5-622ee97a725e)
![Screenshot at 2025-04-06 15-43-28](https://github.com/user-attachments/assets/3aad67a7-0b0a-40e3-b533-5cf8e6a2feaf)

- Ask you for C2 host and C2 port. Then ask you for the path and name for the beacon
- Wait 1 second and launch Netcat listeners on ports 2000 to 2014 using `gnome-terminal`.
- Accept incoming client connections and forward them to the Netcat listeners.
- Maintain interactive communication between the clients and listeners.

### After starting a Netcat Multi-Handler Normal, it will:
![Screenshot at 2025-03-20 22-29-16](https://github.com/user-attachments/assets/19e330f2-4d3d-48bf-840e-6561de0239a2)

![Screenshot at 2025-03-20 22-29-21](https://github.com/user-attachments/assets/1ec0f84f-5878-4388-860e-7a33f8e0fa42)
#### After it
- After entering an host and port it willl create scripts for payload and start the netcat listener in a single port.

### After starting a Netcat Multi-Handler with SSL, it will:
![Screenshot at 2025-03-20 22-30-00](https://github.com/user-attachments/assets/5d357f48-f4fe-42cb-914b-39f911d03844)
Ask's for Host & Port for the Multi-Handler
![Screenshot at 2025-03-29 00-58-08](https://github.com/user-attachments/assets/0f0d7fbd-b461-4c3f-a3fd-a1f75ef14c9b)
Generates new SSL certificate and ask's you to set any password
![Screenshot at 2025-03-21 21-59-57](https://github.com/user-attachments/assets/013ce1d2-09db-43f5-ad2b-32c76ab44298)
Creates scripts for payloads and after entering the same password it will start a listener with a security of SSL.


## Notes
- Ensure ports 2000 to 2014 are not in use before running the server.
- For Windows clients, use a compatible reverse shell payload.

## Created by
INDIAN CYBER ARMY >>(WebDragon63)
YT CHANNEL: [INDIAN CYBER ARMY](https://www.youtube.com/@indiancyberarmy5)

## If you want to donate, you can :)
##### Bitcoin(BTC) address: bc1qrgakys3xn64g74422m3v6avhd7as3hgejsqs7d
##### Ethereum(ETH) address: 0x8CC47B3d6B820D7c72b2778d3D684b430ec6BF38
##### Polygon(POL) address: 0x8CC47B3d6B820D7c72b2778d3D684b430ec6BF38
