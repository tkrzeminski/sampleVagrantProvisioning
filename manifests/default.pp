
# Make sure basic tools are installed
class base {

	package { 'htop':
		name => 'htop',
		ensure => present
	}

	package { 'maven':
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


# define path for commands
Exec {
	path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin" ]
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
	docroot => '/var/www/html',
	default_vhost => false,
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
	proxy_pass => [
		{ 'path' => "/ping", 'url' => 'http://localhost:8081/ping' },
		{ 'path' => "/stress", 'url' => 'http://localhost:8081/stress' },
	],
	custom_fragment => 'Alias /munin /var/cache/munin/www',
	directories => [ {
			path => '/var/cache/munin/www',
			options => ['None'],
			allow_override => [ 'None' ],
		}
	]
}

# and for SSL
apache::vhost { '4fitssl':
	port => 443,
	options => ['None'],
	docroot  => '/var/www/html-4fit',
	ssl => true,
	proxy_pass => [
		{ 'path' => "/ping", 'url' => 'http://localhost:8081/ping' },
		{ 'path' => "/stress", 'url' => 'http://localhost:8081/stress' },
	],
	custom_fragment => 'Alias /munin /var/cache/munin/www',
	directories => [ {
			path => '/var/cache/munin/www',
			options => ['None'],
			allow_override => [ 'None' ],
		}
	]
}
-> # after then
# Create welcome file for custom vhosts
file { '/var/www/html-4fit/index.html':
	ensure => present,
	content => '<h1>Hello 4FIT!</h1><p>Check out <a href="/munin">monitoring</a> or <a href="/ping">ping</a> simple java server</p>'
}



#
# Monitoring with munin
#
munin::master::node_definition { 'localhost':
    address => '127.0.0.1',
    config  => [ 'use_node_name yes' ],
}

# use cron task as default strategy
class { 'munin::master' :
	graph_strategy => 'cron',
	html_strategy => 'cron',
}


class { 'munin::node' :
	allow => [ '127.0.0.1', '192.168.55.10', '::1' ]
}



#
# Supervisord - take care of simple java server
#
class { 'supervisord':
	install_pip => true,
	require => Exec[ "create package" ],
	
}

supervisord::program { 'SimpleServer':
	command     => 'java -cp server-1.0-SNAPSHOT.jar info.krzeminski.server.SimpleHttpServer',
	priority    => '100',
	directory => "/opt/simpleServer/",
	environment => {
		'PATH'   => '/bin:/sbin:/usr/bin:/usr/sbin',
	}
}


#
# JDK
#

class { 'java':
  distribution => 'jdk',
}


#
# Build simple http server
#
file { "/opt/simpleServer/":
    ensure => "directory"
}
# build simpleServer maven package
exec { "create package":
	require => [ Class["java"], Package["maven"], File["/opt/simpleServer"] ],
	cwd => "/vagrant/SimpleServer/server/",
	command => "mvn package -Dalt.build.dir=/opt/simpleServer/"
}





# Fire up required modules

include base
include apache
include java
include supervisord
include 'apache::mod::php'
include 'apache::mod::info'
include 'apache::mod::status'
include 'apache::mod::ssl'
include 'munin::master'
include 'munin::node'


