#! /usr/bin/env bash

set -e
set -u

apt update

#
apt -y install apt-file build-essential curl binutils sudo aptitude
apt -y install build-essential cmake pkg-config libboost-all-dev libssl-dev 
apt -y install libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev 
apt -y install doxygen graphviz libpgm-dev

apt -y install build-essential cmake git libgit2-dev clang libncurses5-dev libncursesw5-dev zlib1g-dev pkg-config libssl-dev


#
apt -y install python-dev
pip install -U pip

apt -y install supervisor


apt -y install lsof net-tools screen nload iproute2 

