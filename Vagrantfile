# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_hostname = "4fitter"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = #{vm_hostname}
  
	config.vm.provision :shell do |shell|
  		shell.inline = "export {http_proxy,https_proxy,ftp_proxy}='http://10.11.46.234:8118';
  		[ ! -d /etc/puppet/modules ] && mkdir -p /etc/puppet/modules;
        puppet module install puppetlabs/apache;
        puppet module install mayflower-php;
        puppet module install puppetlabs-java;
        puppet module install ssm-munin;
        puppet module install ajcrowe-supervisord"
	end
  config.vm.provision "puppet"
  
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"
end
