# Entreprise Network setup (N5AN01B - Protocoles de l'Internet - Mise en place d’un réseau « d’entreprise »)

## Yoann's network

Dynamic deployment of the "entreprise network" using **vagrant, virtualbox and docker**.

### How-to :
Do "sudo vagrant up" in the folder of the "Vagrantfile" order to deploy the LAN architecture.

### Technical choices : 
#### Deployment
I decided to use **Vagrant** as to introduce myself to the world of Infrastructure as Code. It is not efficient in the context of a small deployment as in this project. However, it was a way for me to further discover the "DevOps" culture and technical history background as it is my current job role.

This method has its virtues as, I believe, declarative configuration is somewhat superior to the imperative way of working. It allows for easier management and checks through versionning. It improves readability whilst making knowledge persistence and teaching far easier. 

The commented Vagrantfile contains the project, an introduction to "entreprise architecture" as a whole in just about 300 LoC.

The following method also offered some reassurance as we knew that if something would fail (perhaps a corrupted VM), we would have the Vagrantfile as a Source of Truth when it came to the multiple configurations of our devices and hosts.

I chose to use a mix of both virtualbox and docker in deployment, docker hosting web services while the rest is deployed in VMs for ease of configuration on critical services (DNS and Reverse Proxy).
#### Services choices
| Service Name       | Description                                    | Reason for Choice |
|--------------------|------------------------------------------------|-------------------|
| Nginx Reverse Proxy| Proxy for routing requests to services         | Mainstream reverse-proxy. Used it instead of Traefik for ease of use and lots of tutorials on the web.  |
| DHCP Server        | Provides IP addresses to LAN clients           | Automates IP address assignment in LAN with dhcpd. |
| Web1 (Nginx)       | Web server for Web1 application                | Demonstrates multiple web service deployment. |
| Web2 (Nginx)       | Web server for Web2 application                | - |
| Edgeshark          | Network packet capturing service               | Provides network analysis and troubleshooting capabilities on the docker layer with wireshark and pretty web UI. |
| BIND DNS Server    | DNS service for name resolution                | Enables custom domain name resolution within the network. Textbook choice. |
| IPTables           | Firewall and NAT service                       | Essential for network security and routing between subnets. Used nftables at first but changed back to iptables for uniformity. |

#### Services Topology
| Service Name       | Description                                    | IP Address         | Ports              |
|--------------------|------------------------------------------------|---------------------|--------------------|
| **LAN Client**      | Client in the LAN network                       | 42.42.42.100       | -                  |
| **Edge Router**     | Main router connecting WAN, DMZ, and LAN      | WAN: 150.150.150.3 <br> DMZ: 192.169.1.1 <br> LAN: 42.42.42.1 | -                  |
| **->Nginx Reverse Proxy** | Proxy for routing requests to services    | 192.169.1.1        | Port 80            |
| **->DHCP Server**     | Provides IP addresses to LAN clients           | 192.169.1.1        | -                  |
| **Services VM**     | Hosts various services including web servers   | 192.169.1.20       | Port 80 (Apache) <br> Port 8081 (Web1) <br> Port 8082 (Web2) <br> Port 5001 (Edgeshark) |
| **->Web1**            | Nginx web server for Web1 application          | 192.169.1.20       | Port 8081          |
| **->Web2**            | Nginx web server for Web2 application          | 192.169.1.20       | Port 8082          |
| **->Edgeshark**       | Service for network packet capturing            | 192.169.1.20       | Port 5001          |
| **->BIND DNS Server** | DNS service for name resolution                 | 192.169.1.20       | Port 53            |


#### Issues


### Tasks : 
DONE :
  - Base Vagrantfile
  - Base schema with mermaid.js

TO DO :
  - High level schema draw.io
  - Add comments
  - Edit Readme
  - Ensure connectivity in the LAN
  - Test and PoC of Reverse Proxy
    
[Static schema](yoannn-net/schema_mermaid.png)

```mermaid
graph TB
    subgraph VagrantFile[VagrantFile Deployment]
        direction TB
        style VagrantFile fill:#fff0e6,stroke:#333,stroke-width:4px
        VF1["config.vm.define 'edge-router'"]
        VF2["config.vm.define 'services'"]
        VF3["config.vm.define 'lan-client'"]
    end

    subgraph PersonalNetwork[Personal Network Topology]
        direction TB
        subgraph WAN[WAN: 150.150.150.0/24]
            style WAN fill:#e6f3ff,stroke:#333,stroke-width:4px
            WANRouter[WAN Routers]
        end

        subgraph Interco[Interco]
            style Interco fill:#e6f3ff,stroke:#333,stroke-width:4px
            EdgeRouter[Edge Router<br>WAN: 150.150.150.3<br>DMZ: 192.169.1.1<br>LAN: 42.42.42.1]
            subgraph RouterServices[Router Services]
                style RouterServices fill:#e6ffe6,stroke:#333,stroke-width:2px
                NginxProxy["Nginx Reverse Proxy<br>Port: 80"]
                IPTables["IPTables"]
                DHCP["DHCP Server<br>LAN Range: 42.42.42.100-254"]
            end
        end

        subgraph DMZ[DMZ: 192.169.1.0/24]
            style DMZ fill:#fff0e6,stroke:#333,stroke-width:4px
            Services[Services VM<br>192.169.1.20]
            subgraph DockerServices[Docker Services]
                style DockerServices fill:#e6ffe6,stroke:#333,stroke-width:2px
                Web1["Web1<br>Port: 8081"]
                Web2["Web2<br>Port: 8082"]
                Edgeshark["Edgeshark<br>Port: 5001"]
                DNS["BIND DNS Server"]
            end
        end

        subgraph LAN[LAN: 42.42.42.0/24]
            style LAN fill:#ffe6e6,stroke:#333,stroke-width:4px
            Client[LAN Client<br>42.42.42.100]
        end
    end

    WANRouter <==> EdgeRouter
    EdgeRouter <==> Client
    EdgeRouter <==> Services
    Services --- DockerServices
    DockerServices --- Web1 & Web2 & Edgeshark & DNS
    VF1 -.-> EdgeRouter
    VF2 -.-> Services
    VF3 -.-> Client

    classDef default fill:#f9f9f9,stroke:#333,stroke-width:2px,color:black;
    classDef vagrantFile fill:#fff0e6,stroke:#333,stroke-width:4px,color:black;
    
    class DMZ,LAN,WAN default;
    class VagrantFile,Interco default;
```

## Vagrantfile

You can view the Vagrantfile [here](./code/Vagrantfile).
It is commented and easily understandable, centralizing the whole LAN configuration.

