#!/bin/bash

set -e

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# enable updating of /etc/resolv.conf when updating
echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

echo
echo "Updating environment..."
apt-get -y update
apt-get -y install software-properties-common
apt-get -y update
apt-get -y dist-upgrade
apt-get -y autoremove

echo
echo "Installing prerequisites..."
apt-get -y install \
    coreutils \
    cron \
    iptables \
    iproute2 \
    logrotate \
    lsb-release \
    nano \
    net-tools \
    python3 \
    python3-pip \
    python3-virtualenv \
    rsyslog \
    ssh \
    sudo \
    unattended-upgrades \
    wget

echo
echo Setting up unattended upgrades...
cp -f $SCRIPTPATH/resources/50unattended-upgrades /etc/apt/apt.conf.d/
cat > /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "3";
APT::Periodic::Unattended-Upgrade "1";
EOF

exit 0
