# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_hostname = "4fitter"
vm_forward_http_on = 8080
vm_forward_https_on = 8443

Vagrant.configure(2) do |config|
      	config.vm.box = "ubuntu/trusty64"
	config.vm.hostname = "#{vm_hostname}"

 	#config.vm.provision "shell", path: "bootstrap.sh" 
	config.vm.provision "puppet" do |puppet|
		puppet.options = "--verbose"
	end
  
	config.vm.network "forwarded_port", guest: 80, host: "#{vm_forward_http_on}"
	config.vm.network "forwarded_port", guest: 443, host: "#{vm_forward_https_on}"

	config.vm.network "private_network", ip: "192.168.55.10"
end
