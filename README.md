```
# Configuration du Projet Réseau

## Topologie du Réseau
Le réseau comporte trois segments principaux :

1. **Internet** : Accessible via l'interface `enp0s3` du routeur (IP : 150.150.150.1/24).
2. **Réseau Privé** : Connecté à l'interface `enp0s8` du routeur (IP : 192.168.1.1/24).
3. **DMZ** : Connectée à l'interface `enp0s9` du routeur (IP : 172.16.1.1/29).

## Détails des Machines

### Routeur (Ubuntu Server)
- **Interfaces Réseau** :
  - `enp0s3` : 150.150.150.1/24 (Accès Internet).
  - `enp0s8` : 192.168.1.1/24 (Réseau Privé).
  - `enp0s9` : 172.16.1.1/29 (DMZ).

- **Services** :
  - **DHCP** : Actif sur `enp0s8` pour attribuer des adresses IP au réseau privé.
  - **Reverse Proxy** : Configuré avec Caddy.

#### Fichier Caddyfile
(\`\`\`)
150.150.150.1:80 {
   reverse-proxy 172.16.1.2:80
}
(\`\`\`)

#### Configuration des IPTables
(\`\`\`)
# Politiques par défaut
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# Autoriser le ping
iptables -A FORWARD -p icmp -j ACCEPT

# LAN <-> DMZ
iptables -A FORWARD -i enp0s8 -o enp0s9 -p tcp -j ACCEPT
iptables -A FORWARD -i enp0s8 -o enp0s9 -p udp -j ACCEPT
iptables -A FORWARD -i enp0s9 -o enp0s8 -p tcp -j ACCEPT
iptables -A FORWARD -i enp0s9 -o enp0s8 -p udp -j ACCEPT

# Internet <-> DMZ
iptables -A FORWARD -i enp0s9 -o enp0s3 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -i enp0s9 -o enp0s3 -p tcp --sport 53 -j ACCEPT

# Client <-> Internet
iptables -A FORWARD -i enp0s8 -o enp0s3 -p udp --dport 80 -j ACCEPT
iptables -A FORWARD -i enp0s3 -o enp0s8 -p udp --sport 80 -j ACCEPT
iptables -A FORWARD -i enp0s8 -o enp0s3 -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i enp0s3 -o enp0s8 -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
(\`\`\`)

### Client (Debian)
- Connecté au réseau privé via l'interface `enp0s8`.
- Reçoit son adresse IP dynamiquement via DHCP.

### Serveur Web (Ubuntu Server)
- Situé dans la DMZ.
- IP statique : 172.16.1.2/29 (interface connectée à `enp0s9`).
- Service : Apache.

### Serveur DNS (Ubuntu Server)
- Situé dans la DMZ.
- IP statique : 172.16.1.3/29 (interface connectée à `enp0s9`).
- Service : Bind9.
- Zone configurée : `tsilvestre.webserver.com` pointant vers le serveur web (172.16.1.2).

#### Fichier de Zone DNS
(\`\`\`)
$TTL 86400
@   IN  SOA dns.tsilvestre.webserver.com. admin.tsilvestre.webserver.com. (
    2024121801 ; Serial
    3600       ; Refresh
    1800       ; Retry
    1209600    ; Expire
    86400 )    ; Minimum TTL

@   IN  NS  dns.tsilvestre.webserver.com.
@   IN  A   172.16.1.2
(\`\`\`)

## Résumé
- Le routeur permet l'accès à Internet pour les clients du réseau privé.
- La DMZ contient les services critiques (Web et DNS) accessibles via le reverse proxy configuré sur le routeur.
- Les règles IPTables assurent la sécurité et le contrôle du trafic entre les différents segments du réseau.
```

