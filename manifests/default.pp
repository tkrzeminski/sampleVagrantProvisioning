
# Define tool items 
class base {

	package { 'htop':
		name => 'htop',
		ensure => present
	}

	package { 'bash-completion':
		ensure => present
	}

	package { 'mc':
		name => 'mc',
		ensure => present
	}
}



#
# APACHE: define params
#
class { 'apache':
	mpm_module => 'prefork',
	keepalive => 'Off',
	serveradmin => 'tomasz@krzeminski.info',
	server_signature => 'Off',
	server_tokens => 'Prod',
	docroot => '/var/www/html'
}

class { 'apache::mod::status':
	allow_from      => ['127.0.0.1','::1'],
	extended_status => 'On',
	status_path     => '/server-status'
}

# Define custome apache vhosts
apache::vhost { '4fit':
	port => 80,
	options => ['None'],
	docroot  => '/var/www/html-4fit',
}

# and for SSL
apache::vhost { '4fitssl':
	port => 443,
	options => ['None'],
	docroot  => '/var/www/html-4fit',
	ssl => true,
} -> # after then
# Create welcome file for custom vhosts
file { '/var/www/html-4fit/index.html':
	ensure => present,
	content => '<h1>Hello 4FIT!</html>'	
}

#
# Monitoring with munin
#
munin::master::node_definition { 'localhost':
    address => '127.0.0.1',
    config  => [ 'use_node_name yes' ],
}

# use cron task as default (refresh every 5 min)
class { 'munin::master' :
	graph_strategy => 'cron',
	html_strategy => 'cron',
}


class { 'munin::node' :
	allow => [ '127.0.0.1', '192.168.55.10', '::1' ]
} ->
file { '/etc/apache2/conf.d/munin.conf' :
	ensure => link,
	target => '/etc/munin/apache.conf'
}



#
# Java
#

class { 'java':
  distribution => 'jdk',
}


# Fire up required modules

include base
include apache
include java
include 'apache::mod::php'
include 'apache::mod::info'
include 'apache::mod::status'
include 'apache::mod::ssl'
include 'munin::master'
include 'munin::node'


