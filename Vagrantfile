# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_hostname = "4fitter"

# http port
vm_forward_http_on = 8080
# https port
vm_forward_https_on = 8443

# simple java server direct port
vm_forward_simple_server_on = 8081



Vagrant.configure(2) do |config|
      	config.vm.box = "ubuntu/trusty64"
	config.vm.hostname = "#{vm_hostname}"

 	config.vm.provision "shell", path: "bootstrap.sh" 
	config.vm.provision "puppet" do |puppet|
		puppet.options = "--verbose"
	end
  
	config.vm.network "forwarded_port", guest: 80, host: "#{vm_forward_http_on}"
	config.vm.network "forwarded_port", guest: 443, host: "#{vm_forward_https_on}"

	# uncomment for direct access for simple java server
	# config.vm.network "forwarded_port", guest: 8081, host: "#{vm_forward_simple_server_on}"

	# Left for testing
	# config.vm.network "private_network", ip: "192.168.55.10"
end
