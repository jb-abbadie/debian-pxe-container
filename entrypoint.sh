#!/bin/sh

set -ex

sed -i "s/{DHCP_SERVER}/$DHCP_SERVER/" /etc/dnsmasq.conf
sed -i "s/{PXE_SERVER}/$PXE_SERVER/" pxelinux.cfg/default
sed -i "s/{SERVER_HOSTNAME}/$SERVER_HOSTNAME/" pxelinux.cfg/default

sed -i "s/{SERVER_HOSTNAME}/$SERVER_HOSTNAME/" preseed.cfg
sed -i "s/{SERVER_IP}/$SERVER_IP/" preseed.cfg
sed -i "s/{SERVER_USER}/$SERVER_USER/" preseed.cfg
sed -i "s|{SERVER_USER_SSH_KEY}|$SERVER_USER_SSH_KEY|" preseed.cfg

dnsmasq
