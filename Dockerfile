FROM docker.io/tiredofit/alpine:3.15
LABEL maintainer="Dave Conroy <dave at tiredofit dot ca>"

ENV OPENLDAP_VERSION=2.6.0 \
    SCHEMA2LDIF_VERSION=1.3

COPY CHANGELOG.md /tiredofit/

RUN set -x && \
### Add OpenLDAP user and group
    addgroup -g 389 ldap && \
    adduser -S -D -H -h /var/lib/openldap -s /sbin/nologin -G ldap -u 389 ldap && \
    \
### Fetch Build Dependencies
    apk update && \
    apk add -t .openldap-build-deps \
                alpine-sdk \
                autoconf \
                automake \
                build-base \
                bzip2-dev \
                cracklib-dev \
                cyrus-sasl-dev \
                db-dev \
                git \
                groff \
                heimdal-dev \
                libarchive-dev \
                libevent-dev \
                libsodium-dev \
                libtool \
                m4 \
                mosquitto-dev \
                openssl-dev \
                openssl-dev \
                unixodbc-dev \
                util-linux-dev \
                xz-dev \
                && \
    \
### Fetch Runtime Dependencies
    apk add -t .openldap-run-deps \
                bzip2 \
                cyrus-sasl \
                coreutils \
                cracklib \
                libltdl \
                libuuid \
                libintl \
                libsodium \
                openssl \
                perl \
                pigz \
                sed \
                unixodbc \
                xz \
                zstd \
                && \
    \
    mkdir -p /usr/src/pixz && \
    curl -ssL https://github.com/vasi/pixz/releases/download/v1.0.7/pixz-1.0.7.tar.gz | tar xfz - --strip=1 -C /usr/src/pixz && \
    cd /usr/src/pixz && \
    ./configure && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    \
    mkdir -p /usr/src/pbzip2 && \
    curl -ssL https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz | tar xfz - --strip=1 -C /usr/src/pbzip2 && \
    cd /usr/src/pbzip2 && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    \
### Grab OpenLDAP Source, Alpine Patches and Check ppolicy module
    mkdir -p /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/ && \
    curl -sSL https://openldap.org/software/download/OpenLDAP/openldap-release/openldap-${OPENLDAP_VERSION}.tgz | tar xfz - --strip 1 -C /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/ && \
    git clone --depth 1 git://git.alpinelinux.org/aports.git /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/alpine && \
    mkdir -p contrib/slapd-modules/ppolicy-check-password && \
    git clone https://github.com/cedric-dufour/ppolicy-check-password /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/contrib/slapd-modules/ppolicy-check-password && \
    rm -rf /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/contrib/slapd-modules/ppm && \
    #mkdir -p contrib/slapd-modules/ppm && \
    git clone https://github.com/ltb-project/ppm /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/contrib/slapd-modules/ppm && \
    cd /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/alpine && \
    git filter-branch --prune-empty --subdirectory-filter main/openldap HEAD && \
    \
### Apply Patches
    cd /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/ && \
    for patch in ./alpine/*.patch; do echo "** Applying $patch"; patch -p1 < $patch; done && \
### Compile OpenLDAP
    cd /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/ && \
    sed -i '/^STRIP/s,-s,,g' build/top.mk && \
    # Required for autoconf-2.70 #765043
	#sed 's@^AM_INIT_AUTOMAKE.*@AC_PROG_MAKE_SET@' -i configure.in && \
    AUTOMAKE=/bin/true autoreconf -fi && \
    \
    ./configure \
        --build=$CBUILD \
        --host=$CHOST \
        --prefix=/usr \
        --libexecdir=/usr/lib \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --localstatedir=/var/run/openldap \
        --enable-argon2 \
        --enable-asyncmeta=mod \
        --enable-balancer=yes \
        --enable-crypt \
        --enable-dnssrv=mod \
        --enable-dynamic \
        --enable-ldap=mod \
        --enable-lload=mod \
        --enable-mdb=mod \
        --enable-meta=mod \
        --enable-modules \
        --enable-monitor=yes \
        --enable-null=mod \
        --enable-overlays=mod \
        --enable-passwd=mod \
        --enable-relay=mod \
        --enable-spasswd \
        --enable-slapd \
        --enable-sock=mod \
        --enable-sql=mod \
        --with-cyrus-sasl \
		--with-systemd=no \
        --with-tls=openssl \
        && \
    make -j$(getconf _NPROCESSORS_ONLN) DESTDIR="" install && \
    \
    ## Modules
    cd /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/ && \
    make -j$(getconf _NPROCESSORS_ONLN) DESTDIR="" prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/autogroup install && \
    make -j$(getconf _NPROCESSORS_ONLN) DESTDIR="" prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/lastbind install && \
    make -j$(getconf _NPROCESSORS_ONLN) DESTDIR="" prefix=/usr libexec=/usr/lib -C contrib/slapd-modules/mqtt install && \
    make -j$(getconf _NPROCESSORS_ONLN) DESTDIR="" prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/passwd/pbkdf2 install && \
    make -j$(getconf _NPROCESSORS_ONLN) DESTDIR="" prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/passwd/sha2 install && \
    make -j$(getconf _NPROCESSORS_ONLN) DESTDIR="" prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/smbk5pwd install && \
    #
    ## Build ppolicy-check Module
    cd /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/ && \
    make -j$(getconf _NPROCESSORS_ONLN) prefix=/usr libexecdir=/usr/lib -C contrib/slapd-modules/ppolicy-check-password LDAP_INC_PATH=/tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}) && \
    cp /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/contrib/slapd-modules/ppolicy-check-password/check_password.so /usr/lib/openldap && \
    ## Build Alternative PPM Module
    cd /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/ && \
    make prefix=/usr libexecdir=/usr/lib etcdir=/etc -C contrib/slapd-modules/ppm LDAP_INC_PATH=/tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'}) && \
    cp /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/contrib/slapd-modules/ppm/ppm.so /usr/lib/openldap && \
    ### OpenLDAP Setup
    ln -s /usr/lib/slapd /usr/sbin && \
    mkdir -p /usr/share/doc/openldap && \
    mv /etc/openldap/*.default /usr/share/doc/openldap && \
    rm -rf /etc/openldap/* && \
    mkdir -p /etc/openldap/sasl2 && \
    echo "mech_list: plain external" > /etc/openldap/sasl2/slapd.conf && \
    mkdir -p /etc/openldap/schema && \
    cp -R /tiredofit/openldap:$(head -n 1 /tiredofit/CHANGELOG.md | awk '{print $2'})/servers/slapd/schema/*.schema /etc/openldap/schema && \
    mkdir -p /run/openldap && \
    chown -R ldap:ldap /run/openldap && \
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
           /usr/src \
           /var/cache/apk/*

### Networking
EXPOSE 389 636

### Add Assets
ADD install /
