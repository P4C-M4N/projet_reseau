# **TCPDUMP COMMANDS CHEATSHEET**

Quick commands for capturing **DNS**, **WEB**, **ping**, and **curl** traffic.

---

## **General Syntax**

`sudo tcpdump -i <interface> [filters] -nn`  
- `-i <interface>`: Network interface (e.g., eth0, enp0s9).  
- `-nn`: No name resolution.  
- `-w <file.pcap>`: Save to file.  

---

## **1. DNS Traffic**

- **All DNS (UDP & TCP)**:  
  `sudo tcpdump -i <interface> udp port 53 or tcp port 53 -nn`  # **TCPDUMP COMMANDS CHEATSHEET**

Quick commands for capturing **DNS**, **WEB**, **ping**, and **curl** traffic.

---

## **General Syntax**

`sudo tcpdump -i <interface> [filters] -nn`  
- `-i <interface>`: Network interface (e.g., eth0, enp0s9).  
- `-nn`: No name resolution.  
- `-w <file.pcap>`: Save to file.  

---

## **1. DNS Traffic**

- **All DNS (UDP & TCP)**:  
  `sudo tcpdump -i <interface> udp port 53 or tcp port 53 -nn`  

- **Requests Only**:  
  `sudo tcpdump -i <interface> udp port 53 and src <IP> -nn`  

- **Save to File**:  
  `sudo tcpdump -i <interface> udp port 53 -w dns.pcap`  

---

## **2. WEB Traffic (HTTP/HTTPS)**

- **HTTP (port 80)**:  
  `sudo tcpdump -i <interface> tcp port 80 -nn`  

- **HTTPS (port 443)**:  
  `sudo tcpdump -i <interface> tcp port 443 -nn`  

- **WEB Traffic to/from <IP>**:  
  `sudo tcpdump -i <interface> "tcp port 80 or tcp port 443" and host <IP> -nn`  

---

## **3. Ping Traffic (ICMP)**

- **All ICMP**:  
  `sudo tcpdump -i <interface> icmp -nn`  

- **ICMP to/from <IP>**:  
  `sudo tcpdump -i <interface> icmp and host <IP> -nn`  

---

## **4. curl Traffic**

- **All Traffic to/from <IP>**:  
  `sudo tcpdump -i <interface> host <IP> -nn`  

- **HTTP Traffic (port 80)**:  
  `sudo tcpdump -i <interface> tcp port 80 and host <IP> -nn`  

- **HTTPS Traffic (port 443)**:  
  `sudo tcpdump -i <interface> tcp port 443 and host <IP> -nn`  

---

## **5. Display Packet Content**

- **ASCII Content**:  
  `sudo tcpdump -i <interface> -A`  

- **Hex and ASCII**:  
  `sudo tcpdump -i <interface> -X`  

---

**Save and analyze later with Wireshark** using `-w <file.pcap>`! 🚀


- **Requests Only**:  
  `sudo tcpdump -i <interface> udp port 53 and src <IP> -nn`  

- **Save to File**:  
  `sudo tcpdump -i <interface> udp port 53 -w dns.pcap`  

---

## **2. WEB Traffic (HTTP/HTTPS)**

- **HTTP (port 80)**:  
  `sudo tcpdump -i <interface> tcp port 80 -nn`  

- **HTTPS (port 443)**:  
  `sudo tcpdump -i <interface> tcp port 443 -nn`  

- **WEB Traffic to/from <IP>**:  
  `sudo tcpdump -i <interface> "tcp port 80 or tcp port 443" and host <IP> -nn`  

---

## **3. Ping Traffic (ICMP)**

- **All ICMP**:  
  `sudo tcpdump -i <interface> icmp -nn`  

- **ICMP to/from <IP>**:  
  `sudo tcpdump -i <interface> icmp and host <IP> -nn`  

---

## **4. curl Traffic**

- **All Traffic to/from <IP>**:  
  `sudo tcpdump -i <interface> host <IP> -nn`  

- **HTTP Traffic (port 80)**:  
  `sudo tcpdump -i <interface> tcp port 80 and host <IP> -nn`  

- **HTTPS Traffic (port 443)**:  
  `sudo tcpdump -i <interface> tcp port 443 and host <IP> -nn`  

---

## **5. Display Packet Content**

- **ASCII Content**:  
  `sudo tcpdump -i <interface> -A`  

- **Hex and ASCII**:  
  `sudo tcpdump -i <interface> -X`  

---

**Save and analyze later with Wireshark** using `-w <file.pcap>`! 🚀

