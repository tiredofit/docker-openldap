## 7.1.7 2020-11-25 <goldsam at github>

   ### Changed
      - Change the way that custom scripts execute - Don't force chmod +x for files already.


## 7.1.6 2020-11-14 <dave at tiredofit dot ca>

   ### Added
      - Openldap 2.4.56


## 7.1.5 2020-11-06 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.4.55

## 7.1.4 2020-09-26 <frznvm0@github>

   ### Changed
      - Fix ldap.conf from being copied onto itself

## 7.1.3 2020-09-14 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.4.53

## 7.1.2 2020-08-31 <bfidel@github>

   ### Changed
      - Fix for BASE_DN getting overwritten when DOMAIN environment variable exists

## 7.1.1 2020-08-31 <dave at tiredofit dot ca>

   ### Changed
      - Delete OLC limits from replication


## 7.1.0 2020-08-11 <dave at tiredofit dot ca>

   ### Added
      - Add SHA2 password support
      - Add Argon password support

   ### Reverted
      - Remove Nginx for Letsencrypt Certificate Generation - It served its purpose, there are better ways now.


## 7.0.3 2020-07-26 <dave at tiredofit dot ca>

   ### Added
      - Add change-password shell script for quickly changing config/schema passwords


## 7.0.2 2020-06-25 <dave at tiredofit dot ca>

   ### Added
      - Rewrote entire image seperating into functions
      - Rewrote TLS functionality, now generating CA, KEY, CERT via image instead of Cloudflare helper scripts - Check your settings!
      - Implemented Logging to File functionality with logrotate `LOG_TYPE=FILE`)
      - Rewrote Backup Routines - Now has the capabilities of backing up multiple times per day and various compression options
      - Support multiple log levels

   ### Changed
      - Reworked some Ppolicy routines

   ### Reverted
      - Helper scripts removed
      - Removed HDB Database functionality, only supporting mdb going forward


## 6.9.2 2020-06-18 <dave at tiredofit dot ca>

   ### Changed
      - Fixed initialization script not pulling defaults properly


## 6.9.1 2020-06-15 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.12


## 6.9.0 2020-06-09 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/alpine 5.0.0 base image


## 6.8.9 2020-06-01 <dave at tiredofit dot ca>

   ### Changed
      - Patchup for 6.8.8


## 6.8.8 2020-06-01 <dave at tiredofit dot ca>

   ### Changed
      - Repairs for LDAP local client referencing proper TLS CA, Cert, and Key Files


## 6.8.7 2020-05-06 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.4.50


## 6.8.6 2020-05-06 <dave at tiredofit dot ca>

   ### Changed
      - Fix for TLS DH_PARAM environment variable substitution


## 6.8.5 2020-04-28 <dave at tiredofit dot ca>

   ### Changed
      - Move code that was not a function out of functions file


## 6.8.3 2020-04-27 <dave at tiredofit dot ca>

   ### Changed
      - Patchup for DHParam not utilizing full path when generating


## 6.8.2 2020-04-16 <dave at tiredofit dot ca>

   ### Changed
      - Fix for SLAPD_ARGS variable default
      - Fix for TLS_RESET_PERMISSIONS
      - Fix for generating dhparam.pem files on read only file systems (credit eduardosan@github)


## 6.8.1 2020-04-16 <frebib@github>

   ### Added 
      - Allow overriding slapd runtime arguments
  
   ### Changed
      - Fixed spelling mistake for OpenLDAP version

## 6.8.0 2020-04-15 <dave at tiredofit dot ca>

   ### Added
      - Environment Variables to control keysize of DH Param file
      - New variables to define custom TLS Patches
      - New variables to skip changing ownership on TLS Certificates

   ### Changed
      - Moved environment variable defaults to /assets/functions/10-openldap
      - Cleanup of TLS functionality to support new environment variables
      - Properly support ULIMIT_N environment variable
      - Fix Default for Nginx


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


