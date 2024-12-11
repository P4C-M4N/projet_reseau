# General Configuration
sudo vi /etc/default/keyboard

# Network Configuration (Static)
sudo vi /etc/netplan/50-cloud-init.yaml

'''
network:
    ethernets:
        enp0s3: 
            dhcp4: true
        enp0s8:
            addresses:
                -   172.16.10.1/29
            routes: 
                -   to: 0.0.0.0/0
                    via: 172.16.10.6
            dhcp4: false
    version: 2
'''
sudo netplan apply

# Bind9 DNS-Server Configuration 
sudo apt install bind9 bind9utils -y

## Configuration of main Bind9 Configuration File
sudo vi /etc/bind/named.conf.local
'''
zone "pchaveroux.webserver.com" {
    type master;
    file "/etc/bind/db.pchaveroux.webserver.com";
};
'''

## Creating DNS Zone File
sudo cp /etc/bind/db.local /etc/bind/db.pchaveroux.webserver.com
sudo vi /etc/bind/db.pchaveroux.webserver.com

'''
$TTL    604800
@       IN      SOA     pchaveroux.webserver.com. admin.pchaveroux.webserver.com. (
                        2023113001 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

; Nom de serveur DNS
@       IN      NS      ns.pchaveroux.webserver.com.

; Adresse IP du serveur DNS
ns      IN      A       172.16.10.2

; Enregistrement pour pchaveroux.webserver.com
@       IN      A       172.16.10.1
'''

## Allowing DNS queries
options {
    directory "/var/cache/bind";

    listen-on { 172.16.10.2; };
    
    allow-qwery {any;};
    
    recursion yes;
    
    forwarders {
        150.150.150.1;  
    };

    forward only;
};


## Bind9 Configuration verification
sudo named-checkconf
sudo named-checkzone pchaveroux.webserver.com /etc/bind/db.pchaveroux.webserver.com

sudo systemctl restart bind9
sudo systemctl enable bind9

