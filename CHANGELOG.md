## 5.3 2018-07-24 <dave at tiredofit dot ca>

* Stop being so thorough with exiting script when replicating - Fixed cont-init.d/10-openldap prematurely exiting with error 20

## 5.2 2018-07-21 <dave at tiredofit dot ca>

* Zabbix Monitoring Fixup

## 5.1 2018-07-21 <dave at tiredofit dot ca>

* Add a sanity checker for Replication errors if hostname doesn't exist in DNS or malformed IP address which causes container start 
fail on 2nd try
* Cleanup Config Pass item

## 5.0 2018-07-19 <dave at tiredofit dot ca>

* Rewrite entire image
* Alpine 3.8
* Compiled from source
* ppolicy-check module included

## 4.1 2018-07-11 <dave at tiredofit dot ca>

* Fix Replication
* Add Custom Assets

## 4.0 2017-10-20 <dave at tiredofit dot ca>

* Base update w/ S6
* Add Fail2Ban
* Script Cleanup

## 3.4 2017-07-05 <dave at tiredofit dot ca>

* Fix Daily Backup Routines

## 3.3 2017-07-05 <dave at tiredofit dot ca>

* Update Zabbix Checks


## 3.2 2017-07-03 <dave at tiredofit dot ca>

* Fix Cron Backup 


## 3.1 2017-03-20 <dave at tiredofit dot ca>

* Added Dyanmic Zabbix Ports for LDAP Checking

## 3.0 2017-03-20 <dave at tiredofit dot ca>

* Full Rebuild From Ground Up - Simplified Dockerfile and Code
* Self Signed Certs only at present


## 2.2 2017-02-22 <dave at tiredofit dot ca>

* Added nginx for dummy site to take advantage of Lets Encrypt SSL Certs

## 2.1 2017-02-22 <dave at tiredofit dot ca>

* Added man, vim

## 2.0 2017-02-14 <dave at tiredofit dot ca>

* Rebase with new Baseimage
* Added Zabbix Agent


## 1.0 2017-01-03 <dave at tiredofit dot ca>


