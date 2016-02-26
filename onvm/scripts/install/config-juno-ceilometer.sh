#!/usr/bin/env bash
# $1 osrelease

source /onvm/scripts/ini-config
eval $(parse_yaml '/onvm/conf/ids.conf.yml' 'leap_')

chmod +x /onvm/scripts/install/getpath.py
c_dir=`/onvm/scripts/install/getpath.py`

cp /onvm/ceilometer/dispatcher/http_"$1".py $c_dir/dispatcher/http.py

iniset /etc/ceilometer/ceilometer.conf DEFAULT rpc_backend 'rabbit'
iniset /etc/ceilometer/ceilometer.conf DEFAULT debug 'True'
iniset /etc/ceilometer/ceilometer.conf DEFAULT rabbit_host "${leap_rabbit_host}"
iniset /etc/ceilometer/ceilometer.conf DEFAULT rabbit_userid "${leap_rabbit_userid}"
iniset /etc/ceilometer/ceilometer.conf DEFAULT rabbit_password "${leap_rabbit_password}"
iniset /etc/ceilometer/ceilometer.conf DEFAULT auth_strategy 'keystone'
iniset /etc/ceilometer/ceilometer.conf DEFAULT dispatcher 'http'

iniset /etc/ceilometer/ceilometer.conf keystone_authtoken auth_uri "${leap_auth_uri}"
iniset /etc/ceilometer/ceilometer.conf keystone_authtoken identity_uri "${leap_identity_uri}"
iniset /etc/ceilometer/ceilometer.conf keystone_authtoken admin_tenant_name "${leap_admin_tenant_name}"
iniset /etc/ceilometer/ceilometer.conf keystone_authtoken admin_user "${leap_admin_user}"
iniset /etc/ceilometer/ceilometer.conf keystone_authtoken admin_password "${leap_admin_password}"

iniset /etc/ceilometer/ceilometer.conf service_credentials os_auth_url "${leap_rabbit_host}"
iniset /etc/ceilometer/ceilometer.conf service_credentials os_username 'ceilometer'
iniset /etc/ceilometer/ceilometer.conf service_credentials os_tenant_name 'service'
iniset /etc/ceilometer/ceilometer.conf service_credentials os_password "${leap_ceilometer_password}"

iniset /etc/ceilometer/ceilometer.conf dispatcher_http target "${leap_qradar_endpoint}"
iniset /etc/ceilometer/ceilometer.conf dispatcher_http cadf_only "${leap_cadf_only}"

EGG_FILE=`find /usr -type f -path "*/ceilometer-201*.egg-info/entry_points.txt"`
iniset $EGG_FILE 'ceilometer.dispatcher' http 'ceilometer.dispatcher.http:HttpDispatcher'

iniremcomment /etc/ceilometer/ceilometer.conf

service ceilometer-agent-notification restart
service ceilometer-collector restart