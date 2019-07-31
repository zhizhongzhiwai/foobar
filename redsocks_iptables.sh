#! /usr/bin/env bash

set -x
iptables -t nat -F PREROUTING


iptables -t nat -F REDSOCKS
iptables -t nat -X REDSOCKS
iptables -t nat -N REDSOCKS

iptables -t nat -F REDSOCKS_UDP
iptables -t nat -X REDSOCKS_UDP
iptables -t nat -N REDSOCKS_UDP

set +x



## redsocks tcp
iptables -t nat -A REDSOCKS -d 45.63.65.35 -j RETURN
iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 100.64.0.0/10 -j RETURN
iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A REDSOCKS -d 198.18.0.0/15 -j RETURN
iptables -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN
iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-port=12345

## redsocks udp
#iptables -t nat -A REDSOCKS_UDP -p udp --dport=53 -j REDIRECT --to-port=5353



### tranparent
iptables -t nat -A OUTPUT -m owner --uid-owner socks -j RETURN
# iptables -t nat -A OUTPUT -p tcp -j REDSOCKS
# iptables -t nat -A OUTPUT -p udp --dport 53 -j REDSOCKS_UDP

# iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDSOCKS
# iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDSOCKS





#iptables -t nat -A OUTPUT -p tcp -j REDSOCKS


### router
iptables -t nat -A PREROUTING -p tcp -j REDSOCKS
#iptables -t nat -A PREROUTING -p udp -j REDSOCKS_UDP


#
iptables-save
