# projet_reseau

## Yoann network

### How-to :
Dynamic deployment of the "entreprise network" using **vagrant, virtualbox and docker**.
Do "sudo vagrant up" in the folder of the "Vagrantfile" order to deploy the LAN architecture.

### Technical choices : 
#### Deployment
I decided to use **Vagrant** as to introduce myself to the world of Infrastructure as Code. It is not efficient in the context of a small deployment as in this project. However, it was a way for me to further discover the "DevOps" culture and technical history background as it is my current job role.

This method has its virtues as, I believe, declarative configuration is somewhat superior to the imperative way of working. It allows for easier management and checks through versionning. It improves readability whilst making knowledge persistence and teaching far easier. 

The commented Vagrantfile contains the project, an introduction to "entreprise architecture" as a whole in just about 300 LoC.

The following method also offered some reassurance as we knew that if something would fail (perhaps a corrupted VM), we would have the Vagrantfile as a Source of Truth when it came to the multiple configurations of our devices and hosts.

I chose to use a mix of both virtualbox and docker in deployment, docker hosting web services while the reste is deployed in VMs.

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
graph TD
    subgraph Interco[Interco]
        style Interco fill:#e6f3ff,stroke:#333,stroke-width:4px
        EdgeRouter[Edge Router<br>192.169.1.1<br>42.42.42.1]
    end

    subgraph DMZ[DMZ: 192.169.1.0/24]
        style DMZ fill:#fff0e6,stroke:#333,stroke-width:4px
        NginxProxy[Nginx Proxy<br>192.169.1.10]
        Services[Services VM<br>192.169.1.20]
        subgraph DockerServices[Docker Services]
            style DockerServices fill:#e6ffe6,stroke:#333,stroke-width:2px
            Web1["Web1<br>Port: 8081"]
            Web2["Web2<br>Port: 8082"]
            Webserver["Webserver<br>Port: 8080"]
            Bind9["Bind9<br>Port: 53 (5353 on host)"]
            Edgeshark["Edgeshark<br>Port: 5001"]
        end
    end

    subgraph LAN[LAN: 42.42.42.0/24]
        style LAN fill:#ffe6e6,stroke:#333,stroke-width:4px
        Client[Client<br>42.42.42.100]
    end

    subgraph VagrantFile[VagrantFile Deployment]
        direction TB
        style VagrantFile fill:#f0e6ff,stroke:#333,stroke-width:2px
        VF1["config.vm.define 'edge-router'"]
        VF2["config.vm.define 'nginx-proxy'"]
        VF3["config.vm.define 'services'"]
        VF4["config.vm.define 'client'"]
    end

    Interco --- EdgeRouter
    EdgeRouter --- NginxProxy
    EdgeRouter --- Client
    NginxProxy --- Services
    Services --- DockerServices
    DockerServices --- Web1 & Web2 & Webserver & Bind9 & Edgeshark
    VF1 -.-> EdgeRouter
    VF2 -.-> NginxProxy
    VF3 -.-> Services
    VF4 -.-> Client

    classDef default fill:#f9f9f9,stroke:#333,stroke-width:2px;
    classDef vagrantFile fill:#f0e6ff,stroke:#333,stroke-width:2px;
    class VF1,VF2,VF3,VF4 vagrantFile;
```
