# General Configuration
sudo nano /etc/default/keyboard 

# Network Configuration
sudo nano /etc/netplan/50-cloud-init.yaml

'''
network:
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            addresses:
                -   10.10.10.2/30
            routes:
                -   to: 192.168.0.0/16
                    via: 10.10.10.1
            dhcp4: false
        enp0s9:
            addresses:
                -   172.16.10.6/29
            dhcp4: false
        enp0s10:
            addresses:
                -   72.14.36.8/16
            dhcp4: false
    version: 2
'''

sudo netplan apply 

# IP Routing Activation
sudo sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

# Reverse Proxy NGINX Configuration
sudo apt install nginx -y

## Creating Reverse Proxy Site
sudo vi /etc/nginx/sites-available/reverse-proxy
server {
    listen 80;
    server_name dmz.example.com;

    location / {
        proxy_pass http://172.16.10.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

## Creating symbolic link between /sites-available/ and /sites-enabled/
sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

## NGINX Reverse Proxy Lauch 
sudo nginx -t
sudo systemctl restart nginx

##IPTables

### Reset Existing Rules
sudo iptables -F
sudo iptables -t nat -F

### LAN Rules

#### Set Default Policies
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD DROP

#### Allow traffic from the LAN to the DMZ
sudo iptables -A FORWARD -i enp0s8 -o enp0s9 -p icmp -j ACCEPT 
sudo iptables -A FORWARD -i enp0s9 -o enp0s8 -p icmp -j ACCEPT 
sudo iptables -A FORWARD -i enp0s8 -o enp0s9 -p tcp --dport 80 -j ACCEPT
sudo iptables -A FORWARD -i enp0s9 -o enp0s8 -p tcp --sport 80 -j ACCEPT
sudo iptables -A FORWARD -i enp0s8 -o enp0s9 -p udp --dport 53 -j ACCEPT
sudo iptables -A FORWARD -i enp0s9 -o enp0s8 -p udp --sport 53 -j ACCEPT

#### Allow traffic between Internet and the DMZ (Web and DNS)
sudo iptables -A FORWARD -i enp0s10 -o enp0s9 -p tcp --dport 80 -j ACCEPT 
sudo iptables -A FORWARD -i enp0s9 -o enp0s10 -p tcp --sport 80 -j ACCEPT 
sudo iptables -A FORWARD -i enp0s10 -o enp0s9 -p udp --dport 53 -j ACCEPT 
sudo iptables -A FORWARD -i enp0s9 -o enp0s10 -p udp --sport 53 -j ACCEPT

#### Allow clients to access the internet
sudo iptables -A FORWARD -i enp0s10 -o enp0s8 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -i enp0s8 -o enp0s10 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i enp0s10 -o enp0s8 -j DROP

### Enable NAT between clients and Net
sudo iptables -t nat -A POSTROUTING -o enp0s10 -j MASQUERADE

### Saving Rules
sudo iptables-save > /etc/iptables/rules.v4
sudo iptables -L -v

# GUI Configuration for Wireshark 
sudo apt install xfce4 xfce4-goodies
sudo apt install xinit
sudo apt install wireshark

## GUI Starting 
startx -- -verbose 5 -logverbose 5
