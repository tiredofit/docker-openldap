## 2.6-7.4.0 2023-03-30 <dave at tiredofit dot ca>

   ### Changed
      - Rework OpenLDAP Backup routines to become more in line with parent tiredofit/db-backup image
      - config and data both get compressed into same tar file going forward
      - Added ability to create "latest" symlink to last good backup
      - Added ability to "archive" backups to an archive folder after a specified period of time for better external backup capabilities


## 2.6-7.3.2 2023-03-07 <adrianparilli@github>

   ### Changed
      - Fix for Custom schemas not loading


## 2.6-7.3.1 2023-02-23 <dave at tiredofit dot ca>

   ### Changed
      - Fix for update_template function not firing


## 2.6-7.3.0 2023-02-22 <dave at tiredofit dot ca>

   ### Added
      - Compatibility with Docker 23.0.0 and newer versions of Kubernetes
      - Modernize image


## 2.6-7.2.19 2023-02-21 <dave at tiredofit dot ca>

   ### Changed
      - Modernize Dockerfile


## 2.6-7.2.18 2023-02-21 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.6.4


## 7.2.17 2022-11-23 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.17 base


## 7.2.16 2022-11-03 <dave at tiredofit dot ca>

   ### Changed
      - Switch ADD to COPY


## 7.2.15 2022-08-17 <dave at tiredofit dot ca>

   ### Changed
      - Switch to using exec to launch process


## 7.2.14 2022-08-06 <dave at tiredofit dot ca>

   ### Changed
      - Minor tweak to loading custom scripts


## 7.2.13 2022-07-14 <dave at tiredofit dot ca>

   ### Changed
      - Silence warning with a dirty chown command


## 7.2.12 2022-07-14 <dave at tiredofit dot ca>

   ### Changed
      - Stop patching one of the makefiles to allow successful builds


## 7.2.11 2022-07-14 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.6.3


## 7.2.10 2022-07-09 <sniper7kills@github>

   ### Fixed
      - Custom Schemas not inserting properly


## 7.2.9 2022-07-05 <dave at tiredofit dot ca>

   ### Changed
      - Version Bump for dependencies


## 7.2.8 2022-05-24 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.16 base


## 7.2.7 2022-05-15 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.6.2


## 7.2.6 2022-04-25 <dave at tiredofit dot ca>

   ### Changed
      - Fix to allow RFC2307bis schemas to install


## 7.2.5 2022-03-14 <dave at tiredofit dot ca>

   ### Changed
      - Fix for slapd-restore and S6 Overlay 3.xx


## 7.2.4 2022-03-01 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.6.1

   ### Changed
      - Repair quirks with OpenLDAP script (S3 backups, temp directories)
      - Disable anonymous bind on initial OpenLDAP setup
      - Rework replication to deprecate olcMirrorMode attributes
      - Code Cleanup and modernization


## 7.2.3 2021-12-07 <dave at tiredofit dot ca>

   ### Added
      - Add Zabbix Auto register support for templates


## 7.2.2 2021-11-24 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.15 base


## 7.2.1 2021-11-12 <dave at tiredofit dot ca>

   ### Changed
      - Fix for 7.2.0 - Ppolicy schema is wrapped into the module now, and solve some configuration test issues


## 7.2.0 2021-11-09 <tiredofit@github>

   ### Added
      - OpenLDAP 2.6.0


## 7.1.22 2021-09-15 <bmalovyn@github>

   ### Changed
      - Wait for slapd to really be ready before running ldapmodify


## 7.1.21 2021-09-06 <dave at tiredofit dot ca>

   ### Changed
      - Fix for ENABLE_BACKUP=FALSE disabling main slapd process


## 7.1.20 2021-09-04 <dave at tiredofit dot ca>

   ### Changed
      - Change the way logrotation is configured for future log parsing capabilities


## 7.1.19 2021-09-01 <dave at tiredofit dot ca>

   ### Changed
      - Change internal envionrment variables to accomodate for upstream changes


## 7.1.18 2021-07-05 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.4.59
      - Alpine 3.14 Base


## 7.1.17 2021-06-01 <janpolito@github>

   ### Fixed
      - slapd-restore script wasn't restoring gzipped databases

## 7.1.16 2021-05-08 <dave at tiredofit dot ca>

   ### Added
      - Introduce `REPLICATION_SAFETY_CHECK` variable to bypass DNS checking of replication hosts


## 7.1.15 2021-04-20 <dave at tiredofit dot ca>

   ### Added
      - Add support for smbk5pwd overlay (credit: @ludwig-burtscher)
      - Fix custom script sorting


## 7.1.14 2021-03-18 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.4.58


## 7.1.13 2021-03-18 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.4.58


## 7.1.12 2021-03-18 <jkrenzer@github>

   ### Added
      - Autogroup overlay


## 7.1.11 2021-03-15 <dave at tiredofit dot ca>

   ### Changed
      - Fix sloppy S3 backup configuration


## 7.1.10 2021-02-13 <dave at tiredofit dot ca>

   ### Changed
      - Fix to compile pixz with new musl base


## 7.1.9 2021-02-13 <dave at tiredofit dot ca>

   ### Added
      - OpenLDAP 2.4.57

   ### Changed
      - Change /assets/custom-scripts/ location for executing post backups scripts to /assets/custom-backup-scripts/


## 7.1.8 2021-01-14 <dave at tiredofit dot ca>

   ### Changed
      - Alpine 3.13 Base


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


