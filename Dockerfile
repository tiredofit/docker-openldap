FROM tiredofit/alpine:3.6
MAINTAINER Dave Conroy <dave at tiredofit dot ca>

### Set Environment Variables
ENV LDAP_LOG_LEVEL=256 \
    LDAP_ORGANISATION="Example Inc." \
    LDAP_DOMAIN=example.org \
    LDAP_BASE_DN= \
    LDAP_ADMIN_PASSWORD=admin \
    LDAP_CONFIG_PASSWORD=config \
    LDAP_READONLY_USER=false \
    LDAP_READONLY_USER_USERNAME=readonly \
    LDAP_READONLY_USER_PASSWORD=readonly \
    LDAP_BACKEND=hdb \
    LDAP_TLS=true \
    LDAP_TLS_CRT_FILENAME=ldap.crt \
    LDAP_TLS_KEY_FILENAME=ldap.key \
    LDAP_TLS_CA_CRT_FILENAME=ca.crt \
    LDAP_TLS_ENFORCE=false \
    LDAP_TLS_CIPHER_SUITE="SECURE256:+SECURE128:-VERS-TLS-ALL:+VERS-TLS1.2:-RSA:-DHE-DSS:-CAMELLIA-128-CBC:-CAMELLIA-256-CBC" \
    LDAP_TLS_VERIFY_CLIENT=try \
    LDAP_SSL_HELPER_PREFIX=ldap \
    LDAP_REPLICATION=false \
    LDAP_REMOVE_CONFIG_AFTER_SETUP=true \
    LDAP_BACKUP_CONFIG_CRON_PERIOD="0 4 * * *" \
    LDAP_BACKUP_DATA_CRON_PERIOD="0 4 * * *" \
    LDAP_BACKUP_TTL=15 \
    ZABBIX_HOSTNAME=openldap

### Package Install
   RUN apk update && \
       apk add \
           coreutils \
           jq \
           libressl \
           openldap \
           openldap-back-bdb \
	       openldap-back-hdb \
	       openldap-back-monitor \
	       openldap-back-sql \
	       openldap-clients \
	       openldap-mqtt \
	       py2-pyldap \
	       sed

	       
## OpenLDAP Setup
	RUN rm -rf /var/lib/openldap 
	RUN rm -rf /etc/ldap/slapd.d
	ADD assets/slapd /assets/slapd/

## OpenLDAP Backup
	ADD assets/cron /assets/cron/
	ADD install/slapd-backup/ /usr/sbin/

## Log Helpers
	ADD install/loghelper /usr/sbin

## SSL Helpers
	ADD install/ssl-tools /usr/sbin
	ADD assets/ssl-tools /assets/ssl-tools/
	RUN curl -o /usr/sbin/cfssl -SL https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
		chmod 700 /usr/sbin/cfssl && \
		curl -o /usr/sbin/cfssljson -SL https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
		chmod 700 /usr/sbin/cfssljson && \
		chmod +x /usr/sbin/*

## Nginx
	COPY install/nginx/nginx.conf /etc/nginx/nginx.conf
	COPY install/nginx/placeholder.html /www/html/index.html

## Zabbix
	ADD install/sbin/ /usr/sbin
    ADD install/zabbix/ /etc/zabbix
    RUN mkdir -p /var/log/zabbix && \
        chmod +x /etc/zabbix/zabbix_agentd.conf.d/*.sh && \
        chown -R zabbix:root /var/log/zabbix

## Networking
	EXPOSE 80 389 636 10050

### S6 Setup
    ADD install/s6 /etc/s6
    

## Logrotate Setup
#    ADD install/logrotate.d /etc/logrotate.d

## Entrypoint
	COPY install/run.sh /run.sh
	RUN chmod +x /run.sh
	CMD ["/run.sh"]

