#!/usr/bin/env bash
# $1 osrelease

source /onvm/scripts/ini-config
eval $(parse_yaml '/onvm/conf/ids.conf.yml' 'leap_')

iniset /etc/ceilometer/ceilometer.conf DEFAULT rpc_backend 'rabbit'
iniset /etc/ceilometer/ceilometer.conf DEFAULT debug 'True'
iniset /etc/ceilometer/ceilometer.conf oslo_messaging_rabbit rabbit_host "${leap_rabbit_host}"
iniset /etc/ceilometer/ceilometer.conf oslo_messaging_rabbit rabbit_userid "${leap_rabbit_userid}"
iniset /etc/ceilometer/ceilometer.conf oslo_messaging_rabbit rabbit_password "${leap_rabbit_password}"
iniset /etc/ceilometer/ceilometer.conf DEFAULT auth_strategy 'keystone'
iniset /etc/ceilometer/ceilometer.conf DEFAULT dispatcher 'http'

iniset /etc/ceilometer/ceilometer.conf  keystone_authtoken auth_uri "${leap_auth_uri}"
iniset /etc/ceilometer/ceilometer.conf  keystone_authtoken identity_uri "${leap_identity_uri}"
iniset /etc/ceilometer/ceilometer.conf  keystone_authtoken admin_tenant_name "${leap_admin_tenant_name}"
iniset /etc/ceilometer/ceilometer.conf  keystone_authtoken admin_user "${leap_admin_user}"
iniset /etc/ceilometer/ceilometer.conf  keystone_authtoken admin_password "${leap_admin_password}"
inidelete /etc/ceilometer/ceilometer.conf keystone_authtoken auth_host
inidelete /etc/ceilometer/ceilometer.conf keystone_authtoken auth_port
inidelete /etc/ceilometer/ceilometer.conf keystone_authtoken auth_protocol

iniset /etc/ceilometer/ceilometer.conf  service_credentials os_auth_url "${leap_rabbit_host}"
iniset /etc/ceilometer/ceilometer.conf  service_credentials os_username 'ceilometer'
iniset /etc/ceilometer/ceilometer.conf  service_credentials os_tenant_name 'service'
iniset /etc/ceilometer/ceilometer.conf  service_credentials os_password "${leap_ceilometer_password}"
iniset /etc/ceilometer/ceilometer.conf  service_credentials os_region_name "${leap_region_name}"
iniset /etc/ceilometer/ceilometer.conf  service_credentials os_endpoint_type 'internalURL'

iniset /etc/ceilometer/ceilometer.conf dispatcher_http target "${leap_qradar_endpoint}"
iniset /etc/ceilometer/ceilometer.conf dispatcher_http cadf_only "${leap_cadf_only}"

iniremcomment /etc/ceilometer/ceilometer.conf

service ceilometer-agent-notification restart
service ceilometer-collector restart