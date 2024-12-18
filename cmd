Routeur :
	sudo ip addr add 192.168.1.1/24 dev enp0s8
	sudo ip addr add 172.16.1.1/29 dev enp0s9
	sudo ip addr add 72.14.100.12/16 dev enp0s3

Client :
	ip addr add 192.168.1.2/24 dev enp0s3

Web_serveur :
	ip addr add 172.16.1.2/29 dev enp0s3

DNS :
        ip addr add 172.16.1.3/29 dev enp0s3
