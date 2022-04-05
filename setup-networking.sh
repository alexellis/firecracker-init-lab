#!/bin/bash

sudo ip tuntap add dev ftap0 mode tap
sudo ip addr add 172.16.0.1/24 dev ftap0
sudo ip link set ftap0 up
ip addr show dev ftap0


IFNAME=enp7s0
#sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

sudo iptables -t nat -A POSTROUTING -o $IFNAME -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ftap0 -o $IFNAME -j ACCEPT
