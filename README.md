# Quick reference

* **Maintained by**: [Leon](https://github.com/opencsi-leon/tailscale)

## Tags

* [latest](https://hub.docker.com/layers/opencsi/tailscale/latest/images/sha256-a8e67e28d9877cb62dd0bffe1b74f910c745f80198e05437f52763256353f35a?context=explore), [stable](https://hub.docker.com/layers/opencsi/tailscale/stable/images/sha256-9949db51b5edde8ed82e5eefb2a471e37aff14cc08500a4b92dfd697b0c9a454?context=explore), [1.18.2](https://hub.docker.com/layers/opencsi/tailscale/1.18.2/images/sha256-9949db51b5edde8ed82e5eefb2a471e37aff14cc08500a4b92dfd697b0c9a454?context=explore)


* [stable-LantoLan](https://hub.docker.com/layers/opencsi/tailscale/stable-LantoLan/images/sha256-687afd9da95d99527373fa4b52765cbfc22a63654ce280928d083d8170d84499?context=explore), [1.18.2-LantoLan](https://hub.docker.com/layers/opencsi/tailscale/1.18.2-LantoLan/images/sha256-eb365d3f72953610e8af356b51e40c973759c7c7b0d53ba21993fdb0b2f8dea3?context=explore)

## What is Tailscale?

Zero config VPN. Installs on any device in minutes, manages firewall rules for you, and works from anywhere.

[Official Site](https://tailscale.com/)

# How to use this image

#### Prerequisites

* Auth key from <https://login.tailscale.com/admin/authkeys> (`tskey-12345...`)
* Enable Linux IP forwarding:

  ```
  sudo nano /etc/sysctl.conf
  ```

  Edit value to 1

  ```
  net.ipv4.ip_forward = 1 
  ```

  Save and exit

  Activate the changes

  ```
  sudo sysctl -p
  ```

#### Run a Container

```
docker run -d \
       --name tailscale-docker-$HOSTNAME \
       -h tailscale-docker-$HOSTNAME \
       --restart=always \
       -v tailscale:/tailscale \
       --cap-add=NET_ADMIN \
       --network=bridge \
       -e "ROUTES=192.168.0.0/24" \
       -e "AUTHKEY=tskey-12345..." \
       opencsi/tailscale:latest
```

The bridge network is necessary to give access to the local network.

The tailscale volume saves the tailscale configurations.

The route allows you to access the local network via the vpn. Enter the IP class of your local network. If you have multiple networks: separate the values with a comma (192.168.0.0/24,10.0.0.0/8).

You can also use this container with [exit node](https://tailscale.com/kb/1103/exit-nodes/?q=route).

Manage the Tailscale setting from the [Admin page](https://login.tailscale.com/admin/).

#### Tag Lan to Lan

Run the container in lan to lan tag to connect 2 or more site

Site1 (Lan 192.168.0.0)

```
docker run -d \
       --name tailscale-docker-$HOSTNAME \
       -h tailscale-docker-$HOSTNAME \
       --restart=always \
       -v tailscale:/tailscale \
       --cap-add=NET_ADMIN \
       --network=bridge \
       -e "ROUTES=192.168.0.0/24" \
       -e "AUTHKEY=tskey-12345..." \
       opencsi/tailscale:stable-LantoLan
```

Site2 (Lan 192.168.1.0)

```
docker run -d \
       --name tailscale-docker-$HOSTNAME \
       -h tailscale-docker-$HOSTNAME \
       --restart=always \
       -v tailscale:/tailscale \
       --cap-add=NET_ADMIN \
       --network=bridge \
       -e "ROUTES=192.168.1.0/24" \
       -e "AUTHKEY=tskey-12345..." \
       opencsi/tailscale:stable-LantoLan
```

Site3 (Lan 192.168.2.0)

```
docker run -d \
       --name tailscale-docker-$HOSTNAME \
       -h tailscale-docker-$HOSTNAME \
       --restart=always \
       -v tailscale:/tailscale \
       --cap-add=NET_ADMIN \
       --network=bridge \
       -e "ROUTES=192.168.2.0/24" \
       -e "AUTHKEY=tskey-12345..." \
       opencsi/tailscale:stable-LantoLan
```

In each site enable the route to the docker host running the container.

on site1: 

```
route add <lan site2> mask 255.255.255.0 <IP Docker Host on site1>
route add <lan site3> mask 255.255.255.0 <IP Docker Host on site1>
```

on site2: 

```
route add <lan site1> mask 255.255.255.0 <IP Docker Host on site2>
route add <lan site3> mask 255.255.255.0 <IP Docker Host on site2>
```

on site3: 

```
route add <lan site1> mask 255.255.255.0 <IP Docker Host on site3>
route add <lan site2> mask 255.255.255.0 <IP Docker Host on site3>
```

#### Credit

based of [Gruber](https://gitlab.com/gruberx/tailscale-docker) Dockerfile.
