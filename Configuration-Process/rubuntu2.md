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



