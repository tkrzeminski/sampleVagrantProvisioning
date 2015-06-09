#!/usr/bin/env bash

# export {http_proxy,https_proxy,ftp_proxy}='http://10.11.46.234:8118';

[ ! -d /etc/puppet/modules ] && mkdir -p /etc/puppet/modules;
puppet module install puppetlabs/apache
puppet module install puppetlabs-java
puppet module install ssm-munin
puppet module install ajcrowe-supervisord
