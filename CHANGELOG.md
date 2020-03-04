## 6.7.2 2020-03-04 <dave at tiredofit dot ca>

   ### Added
      - Update image to support new tiredofit/alpine:4.4.0 base


## 6.7.1 2020-02-13 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.4.49


## 6.7.0 2020-01-14 <sargreal@github>

   ### Added
      - Add Secrets support for `CONFIG_PASS` `ADMIN_PASS` `READONLY_USER_PASS`


## 6.6.2 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Change to use LibreSSL instead of OpenSSL for creating dhparam.pem
      - Change warnings to notices
      - Fix when ENABLE_NGINX=FALSE container fails to initialize
      - Fix with Nginx run script looping with error


## 6.6.1 2019-12-30 <dave at tiredofit dot ca>

   ### Added
      - Allow configurable ULIMIT_N environment variable for open file descriptors


## 6.6.0 2019-12-29 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/alpine base image


## 6.5.1 2019-12-20 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.11 Base


## 6.5 2019-08-25 <dave at tiredofit dot ca>

* OpenLDAP 2.4.48

## 6.4 2019-06-19 <dave at tiredofit dot ca>

* Alpine 3.10

## 6.3.2 2019-03-21 <dave at tiredofit dot ca>

* Fixup

## 6.3.1 2019-03-21 <dave at tiredofit dot ca>

* Update Cracklist Words to 2.9.7

## 6.3 2019-03-21 <dave at tiredofit dot ca>

* Expose 389, 636 and 80 Ports

## 6.2 2018-12-27 <dave at tiredofit dot ca>

* OpenLDAP 2.4.47

## 6.1 2018-12-05 <dave at tiredofit dot ca>

* Fix Replication upon container/pod restart

## 6.0.2 2018-09-13 <dave at tiredofit dot ca>

* Fix for Dockerfile Build when applying OpenLDAP Patches to be displayed correctly

## 6.0.1 2018-08-27 <dave at tiredofit dot ca>

* Fix with ppm.conf generation for bad characters

## 6.0 2018-08-18 <dave at tiredofit dot ca>

* Stop relying on slapd.conf on first time initialization
* Properly apply ACLs for ppolicy 
* Generate Wordlist for ppm.so
* Automatically generate check_password.conf and ppm.conf

## 5.5 2018-08-16 <dave at tiredofit dot ca>

* Fix for ACLs not applying on initial boot 

## 5.4 2018-08-08 <dave at tiredofit dot ca>

* Add alternative Password Checking Module ppm.so
* Provide Default Configurations for check_password.conf and ppm.conf

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


