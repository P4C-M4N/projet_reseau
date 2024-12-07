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

# Apache2 Web-Server Configuration 
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
echo "<h1> Welcome to my Web-Server !! Made by Pierre Chaveroux </h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart apache2





