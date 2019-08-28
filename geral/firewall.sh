#!/bin/bash

IPTABLES=/sbin/iptables

# recover IPs
ETH0IP=`ifconfig wlan0 | grep "inet addr:" | sed 's/.*inet addr://' | cut -d ' ' -f 1`
ETH1IP=`ifconfig eth0 | grep "inet addr:" | sed 's/.*inet addr://' | cut -d ' ' -f 1`
ETH2IP=`ifconfig wlan1 | grep "inet addr:" | sed 's/.*inet addr://' | cut -d ' ' -f 1`

# clean all possible old mess
$IPTABLES -t filter -F 
$IPTABLES -t nat -F 
$IPTABLES -t mangle -F

# masquerading
# wlan0 = interface de rede de acesso a internet.
echo 1 > /proc/sys/net/ipv4/ip_forward
$IPTABLES -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

# opening all 
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT

$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t filter -P FORWARD ACCEPT

# web proxy squid
# ens34 - interface interna
iptables -t nat -A PREROUTING -i ens34 -p tcp --dport 80 -j REDIRECT --to-port 3128
