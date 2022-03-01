# github.com/tiredofit/docker-openldap

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-openldap?style=flat-square)](https://github.com/tiredofit/docker-openldap/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-openldap/build?style=flat-square)](https://github.com/tiredofit/docker-openldap/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/openldap.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/openldap/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/openldap.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/openldap/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)




This as a Dockerfile to build a [OpenLDAP](https://openldap.org) server for maintaining a directory.
Upon starting this image it will give you a ready to run server with many configurable options.

* Tracks latest release
* Compiles from source
* Multiple backends (bdb, hdb, mdb, sql)
* All overlays compiled
* Supports TLS encryption
* Supports Replication
* Scheduled Backups of Data
* Ability to choose NIS or rfc2307bis Schema
* Additional Password Modules (Argon, SHA2, PBKDF2)
* Two Password Checking Modules - check_password.so and ppm.so
* Zabbix Monitoring templates included

### Maintainer

- [Dave Conroy](dave@tiredofit.ca)

## See individual branches

