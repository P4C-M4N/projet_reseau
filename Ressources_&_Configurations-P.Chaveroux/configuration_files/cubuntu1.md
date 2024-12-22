# General Configuration
```
sudo nano /etc/default/keyboard
```
# Network Configuration (Static)
```
sudo nano /etc/netplan/50-cloud-init.yaml
```
```
network:
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            addresses:
                -   192.168.10.1/24
            routes: 
                -   to: 0.0.0.0/0
                    via: 192.168.10.254
            dhcp4: false
    version: 2
```
```
sudo netplan apply
```
# Network Configuration (DHCP)
```
sudo nano /etc/netplan/50-cloud-init.yaml
```
```
network:
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            # addresses:
            #     -   192.168.10.1/24
            # routes: 
            #     -   to: 0.0.0.0/0
            #         via: 192.168.10.254
            # dhcp4: false
            dhcp4: true
    version: 2
```
```
sudo netplan apply
```
