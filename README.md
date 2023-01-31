# github.com/tiredofit/docker-openldap

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-openldap?style=flat-square)](https://github.com/tiredofit/docker-openldap/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-openldap/build?style=flat-square)](https://github.com/tiredofit/docker-openldap/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/openldap.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/openldap/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/openldap.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/openldap/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)


### About

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

### Table of Contents


- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
  - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Required for new setup](#required-for-new-setup)
    - [Logging Options](#logging-options)
    - [Backup Options:](#backup-options)
      - [Backing Up to S3 Compatible Services](#backing-up-to-s3-compatible-services)
    - [Password Policy Options](#password-policy-options)
    - [TLS options](#tls-options)
    - [Replication options](#replication-options)
    - [Other environment variables](#other-environment-variables)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
  - [References](#references)

## Prerequisites and Assumptions

- None

## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/openldap)

```bash
docker pull docker.io/tiredofdit/openldap:(imagetag)
```
Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-openldap/pkgs/container/docker-openldap) 
 
```
docker pull ghcr.io/tiredofit/docker-openldap:(imagetag)
``` 

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-tiredofdit/pkgs/container/docker-tiredofdit) 
 
```
docker pull ghcr.io/tiredofit/docker-tiredofdit:(imagetag)
``` 

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Version | OpenLDAP Version | Container OS | Tag       |
| ------- | ---------------- | ------------ | --------- |
| latest  | 2.6.x            | Alpine       | `:latest` |
| `2.6`   | 2.6.x            | Alpine       | `:2.6`    |
| `2.4`   | 2.4.x            | Alpine       | `:2.4`    |

### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v6`, `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary
__NOTE__: Please allow up to 2 minutes for the application to start for the first time if you are generating self signed TLS certificates.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory                        | Description                                                                                                              |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `/var/lib/openldap`              | Data Directory                                                                                                           |
| `/etc/openldap/slapd.d`          | Configuration Directory                                                                                                  |
| `/assets/custom-scripts/`        | If you'd like to execute a script during the initialization process drop it here (Useful for using this image as a base) |
| `/assets/custom-backup-scripts/` | If you'd like to execute a script after the backup process drop it here (Useful for using this image as a base)          |
| `/certs/`                        | Drop TLS Certificates here (or use your own path)                                                                        |
| `/data/backup`                   | Backup Directory                                                                                                         |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |

#### Required for new setup

| Variable               | Description                                                   | Default                |
| ---------------------- | ------------------------------------------------------------- | ---------------------- |
| `DOMAIN`               | LDAP domain.                                                  | `example.org`          |
| `BASE_DN`              | LDAP base DN. If empty automatically set from `DOMAIN` value. | (empty)                |
| `ADMIN_PASS`           | Ldap Admin password.                                          | `admin`                |
| `CONFIG_PASS`          | Ldap Config password.                                         | `config`               |
| `ORGANIZATION`         | Organization Name                                             | `Example Organization` |
| `ENABLE_READONLY_USER` | Add a read only/Simple Security Object/DSA                    | `false`                |
| `READONLY_USER_USER`   | Read only user username.                                      | `readonly`             |
| `READONLY_USER_PASS`   | Read only user password.                                      | `readonly`             |
| `SCHEMA_TYPE`          | Use `nis` or `rfc2307bis` core schema.                        | `nis`                  |

#### Logging Options

| Variable    | Description                   | Default        |
| ----------- | ----------------------------- | -------------- |
| `LOG_FILE`  | Filename for logging          | `openldap.log` |
| `LOG_LEVEL` | Set LDAP Log Level            | `256`          |
| `LOG_PATH`  | Path for Logs                 | `/logs/`       |
| `LOG_TYPE`  | Output to `CONSOLE` or `FILE` | `CONSOLE`      |

#### Backup Options:


| Parameter                     | Description                                                                                                                                                                                        | Default         |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `ENABLE_BACKUP`               | Enable Backup System                                                                                                                                                                               | `TRUE`          |
| `BACKUP_LOCATION`             | Backup to `FILESYSTEM` or `S3` compatible services like S3, Minio, Wasabi                                                                                                                          | `FILESYSTEM`    |
| `BACKUP_COMPRESSION`          | Use either Gzip `GZ`, Bzip2 `BZ`, XZip `XZ`, ZSTD `ZSTD` or none `NONE`                                                                                                                            | `GZ`            |
| `BACKUP_COMPRESSION_LEVEL`    | Numberical value of what level of compression to use, most allow `1` to `9` except for `ZSTD` which allows for `1` to `19`                                                                         | `3`             |
| `BACKUP_INTERVAL`             | How often to do a dump, in minutes. Defaults to 1440 minutes, or once per day.                                                                                                                     |                 |
| `BACKUP_BEGIN`                | What time to do the first dump. Defaults to immediate. Must be in one of two formats                                                                                                               |                 |
|                               | Absolute HHMM, e.g. `2330` or `0415`                                                                                                                                                               |                 |
|                               | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half                                                     |                 |
| `BACKUP_RETENTION`            | Value in minutes to delete old backups (only fired when dump freqency fires). 1440 would delete anything above 1 day old. You don't need to set this variable if you want to hold onto everything. |                 |
| `BACKUP_MD5`                  | Generate MD5 Sum in Directory, `TRUE` or `FALSE`                                                                                                                                                   | `TRUE`          |
| `BACKUP_PARALLEL_COMPRESSION` | Use multiple cores when compressing backups `TRUE` or `FALSE`                                                                                                                                      | `TRUE`          |
| `BACKUP_PATH`                 | Filesystem path on where to place backups                                                                                                                                                          | `/data/backup`  |
| `BACKUP_TEMP_LOCATION`        | If you wish to specify a different location, enter it here                                                                                                                                         | `/tmp/backups/" |


##### Backing Up to S3 Compatible Services

If `BACKUP_LOCATION` = `S3` then the following options are used.

| Variable               | Description                                                                             | Default       |
| ---------------------- | --------------------------------------------------------------------------------------- | ------------- |
| `BACKUP_S3_BUCKET`     | S3 Bucket name e.g. 'mybucket'                                                          |               |
| `BACKUP_S3_HOST`       | Hostname of S3 Server e.g "s3.amazonaws.com" - You can also include a port if necessary |               |
| `BACKUP_S3_KEY_ID`     | S3 Key ID                                                                               |               |
| `BACKUP_S3_KEY_SECRET` | S3 Key Secret                                                                           |               |
| `BACKUP_S3_PATH`       | S3 Pathname to save to e.g. '`backup`'                                                  |               |
| `BACKUP_S3_PROTOCOL`   | Use either `http` or `https` to access service                                          | `https`       |
| `BACKUP_S3_URI_STYLE`  | Choose either `VIRTUALHOST` or `PATH` style                                             | `VIRTUALHOST` |


#### Password Policy Options

If you already have a check_password.conf or ppm.conf in /etc/openldap/ the following environment variables will not be applied

| Variable                       | Description                               | Default |
| ------------------------------ | ----------------------------------------- | ------- |
| `ENABLE_PPOLICY`               | Enable PPolicy Module utilization         | `TRUE`  |
| `PPOLICY_CHECK_RDN`            | Check RDN Parameter (ppm.so)              | `0`     |
| `PPOLICY_FORBIDDEN_CHARACTERS` | Forbidden Characters (ppm.so)             | ``      |
| `PPOLICY_MAX_CONSEC`           | Maximum Consective Character Pattern      | `0`     |
| `PPOLICY_MIN_DIGIT`            | Minimum Digit Characters                  | `0`     |
| `PPOLICY_MIN_LOWER`            | Minimum Lowercase Characters              | `0`     |
| `PPOLICY_MIN_POINTS`           | Minimum Points required to pass checker   | `3`     |
| `PPOLICY_MIN_PUNCT`            | Minimum Punctuation Characters            | `0`     |
| `PPOLICY_MIN_UPPER`            | Minimum Uppercase Characters              | `0`     |
| `PPOLICY_USE_CRACKLIB`         | Use Cracklib for verifying words (ppm.so) | `1`     |

#### TLS options

| Variable                | Description                                                        | Default                                                                                                                 |
| ----------------------- | ------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| `ENABLE_TLS`            | Add TLS capabilities. Can't be removed once set to `TRUE`.         | `true`                                                                                                                  |
| `TLS_CA_NAME`           | Selfsigned CA Name                                                 | `ldap-selfsigned-ca`                                                                                                    |
| `TLS_CA_SUBJECT`        | Selfsigned CA Subject                                              | `/C=XX/ST=LDAP/L=LDAP/O=LDAP/CN=`                                                                                       |
| `TLS_CA_CRT_SUBJECT`    | SelfSigned CA Cert Sujbject                                        | `${TLS_CA_SUBJECT}${TLS_CA_NAME}`                                                                                       |
| `TLS_CA_CRT_FILENAME`   | CA Cert filename                                                   | `${TLS_CA_AME}.crt`                                                                                                     |
| `TLS_CA_KEY_FILENAME`   | CA Key filename                                                    | `${TLS_CA_NAME}.key`                                                                                                    |
| `TLS_CA_CRT_PATH`       | CA Certificates path                                               | `/certs/${TLS_CA_NAME}/`                                                                                                |
| `TLS_CIPHER_SUITE`      | Cipher Suite to use                                                | `ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:-DHE-DSS:-RSA:!aNULL:!MD5:!DSS:!SHA` |
| `TLS_CREATE_CA`         | Automatically create CA when generating certificates               | `TRUE`                                                                                                                  |
| `TLS_CRT_FILENAME`      | TLS cert filename                                                  | `cert.pem`                                                                                                              |
| `TLS_CRT_PATH`          | TLS cert path                                                      | `/certs/`                                                                                                               |
| `TLS_DH_PARAM_FILENAME` | DH Param filename                                                  | `dhparam.pem`                                                                                                           |
| `TLS_DH_PARAM_KEYSIZE`  | Keysize for DH Param                                               | `2048`                                                                                                                  |
| `TLS_DH_PARAM_PATH`     | DH Param path                                                      | `/certs/`                                                                                                               |
| `TLS_ENFORCE`           | Enforce TLS Usage                                                  | `FALSE`                                                                                                                 |
| `TLS_KEY_FILENAME`      | TLS Key filename                                                   | `key.pem`                                                                                                               |
| `TLS_KEY_PATH`          | TLS Key path                                                       | `/certs/`                                                                                                               |
| `TLS_RESET_PERMISSIONS` | Change permissions on certificate directories for OpenLDAP to read | `TRUE`                                                                                                                  |
| `TLS_VERIFY_CLIENT`     | TLS verify client.                                                 | `try`                                                                                                                   |

    Help: http://www.openldap.org/doc/admin24/tls.html

#### Replication options

| Variable                      | Description                                                                                                                                                                                                                                                                         | Default                                                                                                                                                                      |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ENABLE_REPLICATION`          | Add replication capabilities. Multimaster only at present.                                                                                                                                                                                                                          | `false`                                                                                                                                                                      |
| `REPLICATION_CONFIG_SYNCPROV` | olcSyncRepl options used for the config database. Without rid and provider which are automatically added based on `REPLICATION_HOSTS`.                                                                                                                                              | `binddn="cn=config" bindmethod=simple credentials=$CONFIG_PASS searchbase="cn=config" type=refreshAndPersist retry="5 5 60 +" timeout=1 filter="(!(objectclass=olcGlobal))"` |
| `REPLICATION_DB_SYNCPROV`     | olcSyncRepl options used for the database. Without rid and provider which are automatically added based on `REPLICATION_HOSTS`.                                                                                                                                                     | `binddn="cn=admin,$BASE_DN" bindmethod=simple credentials=$ADMIN_PASS searchbase="$BASE_DN" type=refreshAndPersist interval=00:00:00:10 retry="5 5 60 +" timeout=1`          |
| `REPLICATION_HOSTS`           | list of replication hosts seperated by a space, must contain the current container hostname set by --hostname on docker run command. If replicating all hosts must be set in the same order. Example - `ldap://ldap1.example.com ldap://ldap2.example.com ldap://ldap3.example.com` |
| `REPLICATION_SAFETY_CHECK`    | Check to see if all hosts resolve before starting replication - Introduced as a safety measure to avoid slapd not starting.                                                                                                                                                         | `TRUE`                                                                                                                                                                       |
| `WAIT_FOR_REPLICAS`           | should we wait for configured replicas to come online (respond to ping) before startup?                                                                                                                                                                                             | `false`                                                                                                                                                                      |

 #### Other environment variables

| Variable                    | Description                                                                 | Default                                        |
| --------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------- |
| `CONFIG_PATH`               | Configuration files path                                                    | `/etc/openldap`                                |
| `DB_PATH`                   | Data Files path                                                             | `/var/lib/openldap`                            |
| `REMOVE_CONFIG_AFTER_SETUP` | Delete config folder after setup.                                           | `true`                                         |
| `SLAPD_ARGS`                | If you want to override slapd runtime arguments place here . Default (null) |                                                |
| `SLAPD_HOSTS`               | Allow overriding the default listen parameters                              | `ldap://$HOSTNAME ldaps://$HOSTNAME ldapi:///` |
| `ULIMIT_N`                  | Set Open File Descriptor Limit                                              | `1024`                                         |

### Networking

The following ports are exposed and available to public interfaces

| Port  | Description        |
| ----- | ------------------ |
| `389` | LDAP               |
| `636` | TLS Encrypted LDAP |

## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

### References

* <https://openldap.org>
