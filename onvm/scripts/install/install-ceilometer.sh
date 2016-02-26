#!/usr/bin/env bash
# $1 osrelease

source /onvm/scripts/ini-config
eval $(parse_yaml '/onvm/conf/nodes.conf.yml' 'leap_')

dpkg --remove-architecture i386
apt-get -qqy update
apt-get -qqy install software-properties-common
add-apt-repository -y cloud-archive:"$1"
apt-key update
apt-get -qqy update

apt-get -qqy install ceilometer-collector ceilometer-agent-notification