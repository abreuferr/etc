#!/bin/bash

# variavel de trabalho
IPTABLES=/sbin/iptables

# Interface de rede ligada a internet
WAN="wlan0";
# Interface de rede ligada a rede interna 1
LAN1="eth0";
# Interface de rede ligada a rede interna 2
LAN2="wlan1";

# clean all possible old mess
$IPTABLES -t filter -F 
$IPTABLES -t nat -F 
$IPTABLES -t mangle -F

# masquerading
echo 1 > /proc/sys/net/ipv4/ip_forward
$IPTABLES -t nat -A POSTROUTING -o $WAN -j MASQUERADE

# opening all 
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT

$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t filter -P FORWARD ACCEPT

# web proxy squid
$IPTABLES -t nat -A PREROUTING -i $LAN1 -p tcp --dport 80 -j REDIRECT --to-port 3128

# redirecionar o trafego para o host squid.
$IPTABLES -t nat -A PREROUTING -i $LAN1 -p tcp --dport 80 -j DNAT --to-destination 192.168.10.3:3128

# redirecionamento de porta para acesso externo.
$IPTABLES -t nat -A PREROUTING -p tcp -d $WAN --dport 80 -j DNAT --to 192.168.10.15:80
