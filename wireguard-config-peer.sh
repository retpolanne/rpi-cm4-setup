#!/usr/bin/env sh

set -e

PEER_PUB_KEY="$1"
PEER_ENDPOINT="$2"

echo "Creating wg0 interface and peering with main peer 172.16.0.1 (the cloud peer)"
echo "This peer's address is 172.16.0.2"

ip addr show wg0 || \
    ip link add dev wg0 type wireguard && \
    ip addr add dev wg0 172.16.0.2 peer 172.16.0.1

ip addr show wg0

echo "Configuring wg peering with endpoint $PEER_ENDPOINT and pubkey $PEER_PUB_KEY"
wg set wg0 listen-port 51820 private-key ${HOME}/.wg/privatekey peer "$PEER_PUB_KEY" \
    allowed-ips 172.16.0.0/24 endpoint "$PEER_ENDPOINT"

echo "Starting up wg0 interface"
ip link set up dev wg0

echo "Pinging main peer 172.16.0.1 (the cloud peer)"
ping -I wg0 -W 5 -c 5 172.16.0.1
