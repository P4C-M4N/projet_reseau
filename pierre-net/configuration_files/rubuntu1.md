# General Configuration
```
sudo nano /etc/default/keyboard
```
# Network Configuration
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
                -   10.10.10.1/30
            routes: 
                -   to: 0.0.0.0/0
                    via: 10.10.10.2
            dhcp4: false
        enp0s9: 
            addresses:
                -   192.168.10.254/24
            routes: 
                -   to: 172.16.10.0/29
                    via: 10.10.10.2
            dhcp4: false
        enp0s10: 
            addresses:
                -   192.168.20.254/24
            routes: 
                -   to: 172.16.10.0/29
                    via: 10.10.10.2
            dhcp4: false
    version: 2
```
```
sudo netplan apply 
```
# Static DNS Configuration
```
sudo vi /etc/systemd/resolved.conf
```
```
[Resolve]
DNS=172.16.10.2
```
# IP Routing Activation
```
sudo sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
```
# DHCP Configuration
```
sudo apt install isc-dhcp-server
```
```
vi /etc/dhcp/dhcpd.conf
```
```
default-lease-time 600;
max-lease-time 7200;
authoritative;
```
## Pool for enp0s9 (direction)
```
subnet 192.168.10.0 netmask 255.255.255.0 {
    range 192.168.10.100 192.168.10.150;
    option routers 192.168.10.254;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 172.16.10.2;
}
```
## Pool for enp0s10 (employees)
```
subnet 192.168.20.0 netmask 255.255.255.0 {
    range 192.168.20.100 192.168.20.150;
    option routers 192.168.20.254;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 172.16.10.2;
}
```
```
vi /etc/default/isc-dhcp-server
```
```
INTERFACESv4="enp0s9 enp0s10"
INTERFACESv6=""
```
```
sudo systemctl enable isc-dhcp-server
sudo systemctl start isc-dhcp-server
sudo systemctl status isc-dhcp-server
sudo tail -f /var/log/syslog

```



