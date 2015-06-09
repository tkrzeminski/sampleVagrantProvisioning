#!/usr/bin/env bash

# insert valid proxy server, if host is behind some rigorous firewall
# export {http_proxy,https_proxy,ftp_proxy}='http://10.11.46.234:8118';

[ ! -d /etc/puppet/modules ] && mkdir -p /etc/puppet/modules;

# install required puppet modules
puppet module install puppetlabs/apache
puppet module install puppetlabs-java
puppet module install ssm-munin
puppet module install ajcrowe-supervisord
