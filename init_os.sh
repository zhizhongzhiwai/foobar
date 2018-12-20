#! /usr/bin/env bash

set -e
set -u

dpkg-reconfigure locales

apt update

#
apt -y install apt-file build-essential curl binutils sudo aptitude tcpdump zile
apt -y install build-essential cmake pkg-config libboost-all-dev libssl-dev 
apt -y install libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev 
apt -y install doxygen graphviz libpgm-dev gdebi

apt -y install build-essential cmake git libgit2-dev clang libncurses5-dev libncursesw5-dev zlib1g-dev pkg-config libssl-dev



#
apt -y install python-dev
curl -o - https://bootstrap.pypa.io/get-pip.py |python
pip install -U pip 
pip install toolz 

apt -y install supervisor fail2ban tcpdump libncursesw5-dev gpg dirmngr apt-transport-https source-highlight


apt -y install lsof net-tools screen nload iproute2 emacs24-nox htop

#
localectl set-locale LANG=en_US.UTF-8


git config --system alias.co checkout
git config --system alias.br branch
git config --system alias.ci commit
git config --system alias.st status
git config --system log.date 'format:%Y-%m-%d %H:%M:%S'
