# Eclipse_C2 Framework
![1000003491](https://github.com/user-attachments/assets/acda833e-d678-422a-87d0-6a290eefd5c1)

An advance cli based C2 framework that allows you to create multiple reverse shell which are capable to handle 15 clients using a normal teamserver with custom reverse shell scripts and a scripted web_deivery_method. It is also have an inbuilt single netcat-multihandler to handle a single client (if needed).

### This is on early stage. I will develop this tool in future.
## Features
- User-defined IP and port for the C2 server.
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
![4](https://github.com/user-attachments/assets/e8c24f30-3587-4b1c-b859-3ed41efb7339)

![5](https://github.com/user-attachments/assets/8f8b4c55-6534-4ce4-b94e-816ee0ccf06b)


- Wait 1 second and launch Netcat listeners on ports 2000 to 2014 using `gnome-terminal`.
- Gives you a CMD command to execute on a target's commmand prompt.
- Accept incoming client connections and forward them to the Netcat listeners.
- Maintain interactive communication between the clients and listeners.
### Note: After using this web_delivery_service method you need to run the `pkiller.sh` file manually with `sudo bash pkiller.sh` command to stop any background process of the web_delivery service at the end. 

### After starting a teamserver, it will:
![9](https://github.com/user-attachments/assets/ae037b2e-2fbf-4394-b509-106130ec4437)

- Wait 1 second and launch Netcat listeners on ports 2000 to 2014 using `gnome-terminal`.
- Accept incoming client connections and forward them to the Netcat listeners.
- Maintain interactive communication between the clients and listeners.

### After starting a Netcat Multi-Handler, it will:

![18](https://github.com/user-attachments/assets/8bb831ba-36b4-45bc-8549-49ac52976c93)

- Shows the payload options to choose a payload.
#### After it

![19](https://github.com/user-attachments/assets/0750fdb4-1222-41e1-858f-36cadc31a167)

#### Choosing 1st option

![Screenshot at 2025-03-18 21-08-37](https://github.com/user-attachments/assets/5dae91a4-f772-4edf-9de5-c7a8e5c2da39)

#### Choosing 2nd option
- After choosing a payload it willl start the netcat listener in a single port.

## Notes
- Ensure ports 2000, 2001, 2002, 2003 and 2004 are not in use before running the server.
- For Windows clients, use a compatible reverse shell payload.

## Created by
INDIAN CYBER ARMY >>(WebDragon63)
YT CHANNEL: https://www.youtube.com/@indiancyberarmy5

## If you want to donate, you can :)
##### Bitcoin(BTC) address: bc1qrgakys3xn64g74422m3v6avhd7as3hgejsqs7d
##### Ethereum(ETH) address: 0x8CC47B3d6B820D7c72b2778d3D684b430ec6BF38
##### Polygon(POL) address: 0x8CC47B3d6B820D7c72b2778d3D684b430ec6BF38
