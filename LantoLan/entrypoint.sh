#!/bin/sh

# Setup iptables
# iptables -t nat -A POSTROUTING -o tailscale0 -j MASQUERADE
iptables -t mangle -A FORWARD -i tailscale0 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

if [ ! -d /dev/net ]; then mkdir /dev/net; fi
if [ ! -e /dev/net/tun ]; then  mknod /dev/net/tun c 10 200; fi

# Wait 5s for the daemon to start and then run tailscale up to configure
/bin/sh -c "sleep 5; tailscale up --advertise-routes ${ROUTES} --snat-subnet-routes=false --login-server ${LOGINSERVER} --authkey ${AUTHKEY} --advertise-exit-node --accept-routes" &
exec /usr/bin/tailscaled --state=/tailscale/tailscaled.state
