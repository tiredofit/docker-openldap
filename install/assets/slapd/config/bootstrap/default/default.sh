#!/usr/bin/with-contenv bash

source /assets/functions/00-container
source /assets/defaults/10-openldap

PROCESS_NAME="openldap"

if [ -z "${BASE_DN}" ]; then
    IFS='.' read -ra BASE_DN_TABLE <<< "$DOMAIN"
    for i in "${BASE_DN_TABLE[@]}"; do
      EXT="dc=$i,"
      BASE_DN=$BASE_DN$EXT
    done

    BASE_DN=${BASE_DN::-1}
fi

IFS='.' read -a domain_elems <<< "${DOMAIN}"
SUFFIX=""
ROOT=""

for elem in "${domain_elems[@]}" ; do
    if [ "x${SUFFIX}" = x ] ; then
        SUFFIX="dc=${elem}"
        BASE_DN="${SUFFIX}"
        ROOT="${elem}"
    else
        BASE_DN="${BASE_DN},dc=${elem}"
    fi
done

transform_file_var \
                ADMIN_PASS \
                READONLY_USER_USER \
                READONLY_USER_PASS

ADMIN_PASS_ENCRYPTED=$(slappasswd -s "${ADMIN_PASS}")
READONLY_USER_PASS_ENCRYPTED=$(slappasswd -s "${READONLY_USER_PASS}")

cat <<EOF > /tmp/00-default-data.ldif
dn: ${BASE_DN}
changeType: add
o: ${ORGANIZATION}
dc: ${ROOT}
#ou: ${ROOT}
description: ${ROOT}
objectClass: top
objectClass: dcObject
objectClass: organization

dn: cn=admin,${BASE_DN}
changeType: add
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword: ${ADMIN_PASS_ENCRYPTED}
EOF

if var_true "${ENABLE_READONLY_USER}" ; then
  	cat <<EOF >> /tmp/00-default-data.ldif

dn: cn=${READONLY_USER_USER},${BASE_DN}
changeType: add
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: cn=${READONLY_USER_USER}
description: LDAP read only user
userPassword: ${READONLY_USER_PASS_ENCRYPTED}
EOF
fi

silent ldapmodify -H 'ldapi:///' -D "cn=admin,${BASE_DN}" -w $ADMIN_PASS -f /tmp/00-default-data.ldif
rm -rf /tmp/00-default-data.ldif

exit 0