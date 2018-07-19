#!/bin/bash

#config
LDAP_SERVER="ldap://localhost"
LDAP_PORT="389"
LDAP_USER="cn=admin,<LDAP_BASE_DN>"
LDAP_PASS="<LDAP_ADMIN_PASSWORD>"

#dynamic
LDAP_PARAM="$1"
LDAP_RESPONSE_KEY="${2:-monitorCounter}"

#get LDAP response
COMMAND="ldapsearch -H $LDAP_SERVER:$LDAP_PORT -b $LDAP_PARAM -D $LDAP_USER -w $LDAP_PASS"
RAW=$($COMMAND -s base '(objectClass=*)' '*' '+')

#parse out number
RESULT=$(eval "echo '$RAW' | sed -n 's/^[ \t]*$LDAP_RESPONSE_KEY:[ \t]*\(.*\)/\1/p'")

echo $RESULT

