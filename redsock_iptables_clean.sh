#! /usr/bin/env bash


iptables -t nat -F PREROUTING
iptables -t nat -F OUTPUT
iptables -t nat -F REDSOCKS
iptables -t nat -X REDSOCKS
iptables -t nat -D REDSOCKS

iptables -t nat -F REDSOCKS_UDP
iptables -t nat -X REDSOCKS_UDP
iptables -t nat -D REDSOCKS_UDP


iptables-save
