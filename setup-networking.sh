#!/bin/bash

# Run this once on the host, or upon reboot

# Add a tap device to act as a bridge between the microVM
# and the host.
sudo ip tuntap add dev ftap0 mode tap

# The subnet is 172.16.0.0/24 and so the 
# host will be 172.16.0.1 and the microVM is going to be set to 
# 172.16.0.2
sudo ip addr add 172.16.0.1/24 dev ftap0
sudo ip link set ftap0 up
ip addr show dev ftap0

# Set up IP forwarding and masquerading

# Change IFNAME to match your main ethernet adapter, the one that
# accesses the Internet - check "ip addr" or "ifconfig" if you don't 
# know which one to use.
IFNAME=enp7s0

# Enable IP forwarding
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

# Enable masquerading / NAT - https://tldp.org/HOWTO/IP-Masquerade-HOWTO/ipmasq-background2.5.html
sudo iptables -t nat -A POSTROUTING -o $IFNAME -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ftap0 -o $IFNAME -j ACCEPT
