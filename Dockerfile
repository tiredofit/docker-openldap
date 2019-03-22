FROM tiredofit/alpine:3.8
LABEL maintainer="Dave Conroy <dave@tiredofit.ca>"

ENV ADMIN_PASS=admin \
    BACKEND=mdb \
    BACKUP_CONFIG_CRON_PERIOD="0 4 * * *" \
    BACKUP_DATA_CRON_PERIOD="0 4 * * *" \
    BACKUP_TTL=15 \
    CONFIG_PASS=config \
    DOMAIN=example.org \
    ENABLE_NGINX=false \
    ENABLE_READONLY_USER=false \
    ENABLE_REPLICATION=false \
    ENABLE_SMTP=FALSE \
    ENABLE_TLS=true \
    LOG_LEVEL=256 \
    OPENLDAP_VERSION=2.4.47 \
    ORGANIZATION="Example Organization" \
    READONLY_USER_PASS=readonly \
    READONLY_USER_USER=readonly \
    REMOVE_CONFIG_AFTER_SETUP=false \
    SCHEMA2LDIF_VERSION=1.3 \
    SCHEMA_TYPE=nis \
    SSL_HELPER_PREFIX=ldap \
    TLS_CA_CRT_FILENAME=ca.pem \
    TLS_CIPHER_SUITE="ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:-DHE-DSS:-RSA:!aNULL:!MD5:!DSS:!SHA" \
    TLS_CRT_FILENAME=cert.pem \
    TLS_ENFORCE=false \
    TLS_KEY_FILENAME=key.pem \
    TLS_VERIFY_CLIENT=try \
    ZABBIX_HOSTNAME=openldap-app


COPY CHANGELOG.md /tiredofit/

RUN set -x && \
### Add OpenLDAP user and group
    addgroup -g 389 ldap && \
    adduser -S -D -H -h /var/lib/openldap -s /sbin/nologin -G ldap -u 389 ldap && \
    \
### Fetch Build Dependencies
    apk update && \
    apk add -t .openldap-build-deps \
        autoconf \
        automake \
        build-base \
        cracklib-dev \
        cyrus-sasl-dev \
        db-dev \
        git \
        groff \
        libressl-dev \
        libtool \
        m4 \
        mosquitto-dev \
        unixodbc-dev \
        util-linux-dev \
        && \
    \
### Fetch Runtime Dependencies
    apk add -t .openldap-run-deps \
        cyrus-sasl \
        coreutils \
        cracklib \
        libressl \
        libltdl \
        libuuid \
        libintl \
        nginx \
        perl \
        sed \
        sudo \
        unixodbc \
        && \
    \
### Grab OpenLDAP Source, Alpine Patches and Check ppolicy module
    \
    mkdir -p /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/ && \
    curl -sSL ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-$OPENLDAP_VERSION.tgz | tar xvfz - --strip 1 -C /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/ && \
    git clone --depth 1 git://git.alpinelinux.org/aports.git /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/alpine && \
    mkdir -p contrib/slapd-modules/ppolicy-check-password && \
    git clone https://github.com/cedric-dufour/ppolicy-check-password /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/contrib/slapd-modules/ppolicy-check-password && \
    mkdir -p contrib/slapd-modules/ppm && \
    git clone https://github.com/ltb-project/ppm /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/contrib/slapd-modules/ppm && \
    cd /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/alpine && \
    git filter-branch --prune-empty --subdirectory-filter main/openldap HEAD && \
    # Already applied
    rm -rf CVE-2017-9287.patch && \
    \
### Apply Patches
    cd /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/ && \
    for patch in ./alpine/*.patch; do echo "** Applying $patch"; patch -p1 < $patch; done && \
### Compile OpenLDAP
    cd /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/ && \
    libtoolize --force && \
    aclocal && \
    autoconf && \
    \
    ./configure \
        --build=$CBUILD \
        --host=$CHOST \
        --prefix=/usr \
        --libexecdir=/usr/lib \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --localstatedir=/var/run/openldap \
        --enable-slapd \
        --enable-crypt \
        --enable-modules \
        --enable-dynamic \
        --enable-bdb=mod \
        --enable-dnssrv=mod \
        --enable-hdb=mod \
        --enable-ldap=mod \
        --enable-mdb=mod \
        --enable-meta=mod \
        --enable-monitor=yes \
        --enable-null=mod \
        --enable-passwd=mod \
        --enable-spasswd \
        --enable-relay=mod \
        --enable-shell=mod \
        --enable-sock=mod \
        --enable-sql=mod \
        --enable-overlays=mod \
        --with-tls=openssl \
        --with-cyrus-sasl \
        && \
    \
    make DESTDIR="" install && \
    \
    ## Build MQTT overlay.
    make DESTDIR="" prefix=/usr libexec=/usr/lib -C contrib/slapd-modules/mqtt install && \
    #\
    ## Build passwd pbkdf2.
    make DESTDIR="" prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/passwd/pbkdf2 install && \
    #\
    ## Build ppolicy-check Module
    cd /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/ && \
    make prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/ppolicy-check-password LDAP_INC_PATH=/tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}` && \
    cp /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/contrib/slapd-modules/ppolicy-check-password/check_password.so /usr/lib/openldap && \
    ## Build Alternative PPM Module
    cd /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/ && \
    make prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/ppm LDAP_INC_PATH=/tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}` && \
    cp /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/contrib/slapd-modules/ppm/ppm.so /usr/lib/openldap && \
    \
### OpenLDAP Setup
    ln -s /usr/lib/slapd /usr/sbin && \
    mkdir -p /usr/share/doc/openldap && \
    mv /etc/openldap/*.default /usr/share/doc/openldap && \
    rm -rf /etc/openldap/* && \
    mkdir -p /etc/openldap/sasl2 && \
    echo "mech_list: plain external" > /etc/openldap/sasl2/slapd.conf && \
    mkdir -p /etc/openldap/schema && \
    cp -R /tiredofit/openldap:`head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}`/servers/slapd/schema/*.schema /etc/openldap/schema && \
    mkdir -p /run/openldap && \
    chown -R ldap:ldap /run/openldap && \
    \
### SSL Helpers
    curl -o /usr/sbin/cfssl -SL https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    chmod 700 /usr/sbin/cfssl && \
    curl -o /usr/sbin/cfssljson -SL https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    chmod 700 /usr/sbin/cfssljson && \
    \
## Install Schema2LDIF
    curl https://codeload.github.com/fusiondirectory/schema2ldif/tar.gz/${SCHEMA2LDIF_VERSION} | tar xvfz - --strip 1 -C /usr && \
    rm -rf /usr/Changelog && \
    rm -rf /usr/LICENSE && \
    \
## Create Cracklib Dictionary
    mkdir -p /usr/share/dict && \
    cd /usr/share/dict && \
    wget https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-words-2.9.7.gz && \
    create-cracklib-dict -o pw_dict cracklib-words-2.9.7.gz && \
    rm -rf cracklib-words-2.9.7.gz && \
    \
### Cleanup
    apk del \
        .openldap-build-deps \
        && \
    rm -rf /tiredofit \
           /var/cache/apk/*

### Networking
EXPOSE 80 389 636 

### Add Assets
ADD install /
