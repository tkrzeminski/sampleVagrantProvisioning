# sampleVagrantProvisioning
Sample vagrant based provisioning with simple app and monitoring.

# Steps

* Clone repository
```
git clone https://github.com/tkrzeminski/sampleVagrantProvisioning .
```

* Start vagrant
```
vagrant up
```

* wait

* Open browser on page [http://localhost:8080](http://localhost:8080) or [https://localhost:8443/](https://localhost:8443/)

* Checkout monitoring on page [http://localhost:8080/munin/](http://localhost:8080/munin/) or [https://localhost:8443/munin/](https://localhost:8443/munin/)

* Ping local simple java server requesting page [http://localhost:8080/ping](http://localhost:8080/ping) or [https://localhost:8443/ping](https://localhost:8443/ping) behind proxy


* Try to burn vagrant box requesting page [http://localhost:8080/stress](http://localhost:8080/stress) or [https://localhost:8443/stress](https://localhost:8443/stress) or use console ab command:
```
ab -n 100 -c 5 http://localhost:8080/stress
```
