# tiredofit/openldap

# Introduction

Dockerfile to build a [OpenLDAP Server](https://openldap.org) 
It contains TLS Encryption, Multi-Master Replication as configurable options.

This Container uses [Debian:Jessie](http://www.debian.org) as a base, and also includes automated backups.



[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](daveconroy@selfdesign.org)

# Table of Contents

- [Introduction](#introduction)
	- [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Dependencies](#dependendcies)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
	- [Data Volumes](#data-volumes)
	- [Database](#database)
	- [Environment Variables](#environmentvariables)   
	- [Networking](#networking)
- [Maintenance](#maintenance)
	- [Shell Access](#shell-access)
- [References](#references)


# Prerequisites

None.

# Dependencies

None.

# Installation

Automated builds of the image are available on [Docker Hub](https://tiredofit/openldap) and is the recommended method of installation.


```bash
docker pull tiredofit/openldap
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Map [Network Ports](#networking) to allow external access.

Start openldap using:

```bash
docker-compose up
```
__NOTE__: Please allow up to 1 minutes for the application to start.


## Data-Volumes


The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description |
|-----------|-------------|
| `/var/lib/ldap` | Data Directory |
| `/etc/ldap/slapd.d` | Configuration Directory |
| `/container/service/slapd/assets/certs/` | TLS Certificates |
| `/data/backup` | Backup Directory |   
      

## Environment Variables

The Following Configuration Options can be set.

Required and used for new ldap server only:

| Variable | Description |
|-----------|-------------|
| `LDAP_ORGANISATION` | Organisation name. Defaults to Example Inc. |
| `LDAP_DOMAIN` | Ldap domain. Defaults to example.org |
| `LDAP_BASE_DN` | Ldap base DN. If empty automatically set from LDAP_DOMAIN value. Defaults to (empty) |
| `LDAP_ADMIN_PASSWORD` | Ldap Admin password. Defaults to admin |
| `LDAP_CONFIG_PASSWORD` | Ldap Config password. Defaults to config |
| `LDAP_READONLY_USER` | Add a read only user. Defaults to false |
| `LDAP_READONLY_USER_USERNAME` | Read only user username. Defaults to readonly |
| `LDAP_READONLY_USER_PASSWORD` | Read only user password. Defaults to readonly |

Backend:

| Variable | Description |
|-----------|-------------|
| `LDAP_BACKEND` | Ldap backend. Defaults to hdb, other option is mdb |

    Help: http://www.openldap.org/doc/admin24/backends.html

Backup Options:

| Variable | Description |
|-----------|-------------|
| `LDAP_BACKUP_CONFIG_CRON_PERIOD` | Cron expression to schedule OpenLDAP config backup. Defaults to 0 4 * * *. Every days at 4am. |
| `LDAP_BACKUP_DATA_CRON_PERIOD` | Cron expression to schedule OpenLDAP data backup. Defaults to 0 4 * * *. Every days at 4am. |
| `LDAP_BACKUP_TTL ` | Backup TTL in days. Defaults to 15. |

TLS options:

| Variable | Description |
|-----------|-------------|
| `LDAP_TLS` | Add openldap TLS capabilities. Can't be removed once set to true. Defaults to true. |
| `LDAP_TLS_CRT_FILENAME` | Ldap ssl certificate filename. Defaults to ldap.crt |
| `LDAP_TLS_KEY_FILENAME` | Ldap ssl certificate private key filename. Defaults to ldap.key |
| `LDAP_TLS_CA_CRT_FILENAME` | Ldap ssl CA certificate filename. Defaults to ca.crt |
| `LDAP_TLS_ENFORCE` | Enforce TLS. Can't be disabled once set to true. Defaults to false. |
| `LDAP_TLS_CIPHER_SUITE` | TLS cipher suite. Defaults to SECURE256:+SECURE128:-VERS-TLS-ALL:+VERS-TLS1.2:-RSA:-DHE-DSS:-CAMELLIA-128-CBC:-CAMELLIA-256-CBC, based on Red Hat's TLS hardening guide |
| `LDAP_TLS_VERIFY_CLIENT: TLS verify client. Defaults to try

    Help: http://www.openldap.org/doc/admin24/tls.html


Replication options:

| Variable | Description |
|-----------|-------------|
| `LDAP_REPLICATION` | Add openldap replication capabilities. Defaults to false
| `LDAP_REPLICATION_CONFIG_SYNCPROV` |  olcSyncRepl options used for the config database. Without rid and provider which are automatically added based on LDAP_REPLICATION_HOSTS. Defaults to binddn="cn=admin,cn=config" bindmethod=simple credentials=$LDAP_CONFIG_PASSWORD searchbase="cn=config" type=refreshAndPersist retry="60 +" timeout=1 starttls=critical |
| `LDAP_REPLICATION_DB_SYNCPROV` | olcSyncRepl options used for the database. Without rid and provider which are automatically added based on LDAP_REPLICATION_HOSTS. Defaults to binddn="cn=admin,$LDAP_BASE_DN" bindmethod=simple credentials=$LDAP_ADMIN_PASSWORD searchbase="$LDAP_BASE_DN" type=refreshAndPersist interval=00:00:00:10 retry="60 +" timeout=1 starttls=critical |
| `LDAP_REPLICATION_HOSTS`  | list of replication hosts, must contain the current container hostname set by --hostname on docker run command. Defaults to :

    - ldap://ldap.example.org
    - ldap://ldap2.example.org


 Other environment variables:

| Variable | Description |
|-----------|-------------|
| `LDAP_REMOVE_CONFIG_AFTER_SETUP` | delete config folder after setup. Defaults to true |
| `LDAP_SSL_HELPER_PREFIX` | ssl-helper environment variables prefix. Defaults to ldap, ssl-helper first search config from LDAP_SSL_HELPER_* variables, before SSL_HELPER_* variables. |


## Networking

The following ports are exposed and available to public interfaces

| Port | Description |
|-----------|-------------|
| `389` | Unecrypted LDAP |
| `636` | TLS Encrypted LDAP |

## Maintenance
#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it openldap bash
```

# References

* https://openldap.org
