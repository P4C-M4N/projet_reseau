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
                -   150.150.150.254/24
            routes: 
                -   to: 0.0.0.0/0
                    via: 172.16.10.6
            dhcp4: false
    version: 2
'''
sudo netplan apply

# Bind9 DNS-Server Configuration 
sudo apt install bind9 bind9-utils bind9-doc -y

## Configuration of main Bind9 Configuration File
sudo vi /etc/bind/named.conf.local
'''
zone "webserver.com" {
    type master;
    file "/etc/bind/db.webserver.com";
};
'''

## Creating DNS Zone File
sudo cp /etc/bind/db.local /etc/bind/db.webserver.com
sudo vi /etc/bind/db.webserver.com

'''
$TTL    86400
@       IN      SOA     ns1.webserver.com. admin.webserver.com. (
                         2024121501 ; Serial
                         3600       ; Refresh
                         1800       ; Retry
                         1209600    ; Expire
                         86400 )    ; Minimum TTL

        IN      NS      ns1.webserver.com.

tsilvestre     IN      A       150.150.150.1
pchaveroux     IN      A       150.150.150.2
yfrancois      IN      A       150.150.150.3

ns1            IN      A       150.150.150.254
'''

## Allowing DNS queries
sudo vi /etc/bind/named.conf.options

'''
options {
    directory "/var/cache/bind";

    recursion yes;
    allow-recursion { any; }; // Ou limite aux IP autorisées si nécessaire

    forwarders {
        8.8.8.8; 
        1.1.1.1;  
    };
    
    dnssec-validation no;

    listen-on { any; };
    listen-on-v6 { any; };
};
'''

## Bind9 Configuration verification
sudo named-checkconf
sudo named-checkzone pchaveroux.webserver.com /etc/bind/db.pchaveroux.webserver.com
sudo systemctl restart bind9
