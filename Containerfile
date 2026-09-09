# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="OpenLDAP" \
        org.opencontainers.image.description="Directory Server" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/openldap" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-openldap/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-openldap.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG OPENLDAP_VERSION="2.6.15" \
    CRACKLIB_VERSION="2.10.3" \
    CRACKLIB_REPO_URL="https://github.com/cracklib/cracklib" \
    SCHEMA2LDIF_VERSION="1.3"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

EXPOSE 389 636

ENV \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    IMAGE_NAME="nfrastack/openldap" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-openldap/"

RUN echo "" && \
    OPENLDAP_BUILD_DEPS_ALPINE=" \
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
                                    unixodbc-dev \
                                    util-linux-dev \
                                    xz-dev \
                               " \
                               && \
    OPENLDAP_RUN_DEPS_ALPINE=" \
                                bzip2 \
                                ca-certificates \
                                cyrus-sasl \
                                coreutils \
                                cracklib \
                                iptables \
                                libevent \
                                libltdl \
                                libuuid \
                                libintl \
                                libsasl \
                                libsodium \
                                libuuid \
                                openssl \
                                perl \
                                pigz \
                                pixz \
                                sed \
                                tar \
                                unixodbc \
                                xz \
                                zstd \
                             " \
                             && \
    \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user ldap 389 ldap 389 /var/lib/openldap && \
    package update && \
    package upgrade && \
    package install \
                        OPENLDAP_BUILD_DEPS \
                        OPENLDAP_RUN_DEPS \
                        && \
    \
    mkdir -p /usr/src/pbzip2 && \
    curl -ssL https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz | tar xfz - --strip=1 -C /usr/src/pbzip2 && \
    cd /usr/src/pbzip2 && \
    make -j$(( $nproc -1 )) && \
    make install && \
    container_build_log add "PBZip2" "1.1.13" "launchpad.net/pbzip2" && \
    \
    mkdir -p /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/ && \
    curl -sSL https://openldap.org/software/download/OpenLDAP/openldap-release/openldap-${OPENLDAP_VERSION}.tgz | tar xfz - --strip 1 -C /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/ && \
    git clone --depth 1 git://git.alpinelinux.org/aports.git /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/alpine && \
    mkdir -p contrib/slapd-modules/ppolicy-check-password && \
    git clone https://github.com/cedric-dufour/ppolicy-check-password /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/contrib/slapd-modules/ppolicy-check-password && \
    rm -rf /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/contrib/slapd-modules/ppm && \
    git clone https://github.com/ltb-project/ppm /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/contrib/slapd-modules/ppm && \
    cd /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/alpine && \
    git filter-branch --prune-empty --subdirectory-filter main/openldap HEAD && \
    \
    cd /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/ && \
    rm -rf ./alpine/tests-make-add-missing-dependency.patch && \
    for patch in ./alpine/*.patch; do echo "** Applying $patch"; patch -p1 < $patch; done && \
    cd /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/ && \
    sed -i '/^STRIP/s,-s,,g' build/top.mk && \
    \
    AUTOMAKE=/bin/true autoreconf -fi && \
    ./configure \
                --build=$CBUILD \
                --host=$CHOST \
                --prefix=/usr \
                --libexecdir=/usr/lib \
                --sysconfdir=/etc \
                --mandir=/usr/share/man \
                --localstatedir=/run/openldap \
                --enable-argon2 \
                --enable-asyncmeta=mod \
                --enable-auditlog=mod \
                --enable-balancer=yes \
                --enable-constraint=mod \
                --enable-crypt \
                --enable-deref=mod \
                --enable-dnssrv=mod \
                --enable-dyngroup=mod \
                --enable-dynlist=mod \
                --enable-dynamic \
                --enable-ldap=mod \
                --enable-lload=mod \
                --enable-mdb=mod \
                --enable-meta=mod \
                --enable-modules \
                --enable-monitor=yes \
                --enable-nestgroup=mod \
                --enable-null=mod \
                --enable-overlays=mod \
                --enable-proxycache=mod \
                --enable-passwd=mod \
                --enable-relay=mod \
                --enable-spasswd \
                --enable-slapd \
                --enable-sock=mod \
                --enable-sql=mod \
                --enable-syslog \
                --enable-valsort=mod \
                --with-cyrus-sasl \
                --with-systemd=no \
                --with-tls=openssl \
                && \
    make \
            -j $(( $(nproc) > 1 ? $(nproc) - 1 : 1 )) \
            DESTDIR="" \
            install \
            && \
    \
    container_build_log add "OpenLDAP" "${OPENLDAP_VERSION}" "openldap.org" && \
    cd /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/ && \
    for module in autogroup lastbind mqtt passwd/pbkdf2 passwd/sha2 smbk5pwd; do \
        make \
                -j $(( $(nproc) > 1 ? $(nproc) - 1 : 1 )) \
                DESTDIR="" \
                prefix=/usr \
                libexecdir=/usr/lib \
                -C contrib/slapd-modules/${module} \
                install \
                ; \
    done && \
    for module in ppolicy-check-password ppm; do \
        make \
                -j $(( $(nproc) > 1 ? $(nproc) - 1 : 1 )) \
                prefix=/usr \
                libexecdir=/usr/lib \
                -C contrib/slapd-modules/${module} \
                LDAP_INC_PATH=/nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}') \
                ; \
        cp /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/contrib/slapd-modules/${module}/*.so /usr/lib/openldap ; \
    done && \
    ln -s /usr/lib/slapd /usr/sbin && \
    mkdir -p /usr/share/doc/openldap && \
    mv /etc/openldap/*.default /usr/share/doc/openldap && \
    rm -rf /etc/openldap/* && \
    mkdir -p /etc/openldap/sasl2 && \
    echo "mech_list: plain external" > /etc/openldap/sasl2/slapd.conf && \
    mkdir -p /etc/openldap/schema && \
    cp -R /nfrastack/openldap:$(head -n 1 /container/build/"${IMAGE_NAME/\//_}"/CHANGELOG.md | awk '{print $2}')/servers/slapd/schema/*.schema /etc/openldap/schema && \
    mkdir -p /run/openldap && \
    chown -R ldap:ldap /run/openldap && \
    \
    curl https://codeload.github.com/fusiondirectory/schema2ldif/tar.gz/${SCHEMA2LDIF_VERSION} | tar xvfz - --strip 1 -C /usr && \
    container_build_log add "Schema2LDIF" "${SCHEMA2LDIF_VERSION}" "https://github.com/fusiondirectory/schema2ldif" && \
    rm -rf /usr/Changelog && \
    rm -rf /usr/LICENSE && \
    \
    curl -sSL https://raw.githubusercontent.com/perl-ldap/perl-ldap/refs/heads/master/contrib/ldifsort.pl -o /usr/local/bin/ldifsort.pl && \
    chmod +x /usr/local/bin/ldifsort.pl && \
    \
    mkdir -p /usr/share/dict && \
    cd /usr/share/dict && \
    wget ${CRACKLIB_REPO_URL%/}/releases/download/v${CRACKLIB_VERSION}/cracklib-words-${CRACKLIB_VERSION}.gz && \
    create-cracklib-dict -o pw_dict cracklib-words-${CRACKLIB_VERSION}.gz && \
    rm -rf cracklib-words-${CRACKLIB_VERSION}.gz && \
    container_build_log add "Cracklib Words" "${CRACKLIB_VERSION}" "${CRACKLIB_REPO_URL}" && \
    rm -rf /nfrastack && \
    package remove \
                    OPENLDAP_BUILD_DEPS \
                    && \
    \
    package cleanup

COPY rootfs /
