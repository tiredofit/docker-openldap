#!/usr/bin/with-contenv bash

# if BASE_DN is empty set value from DOMAIN
  if [ -z "$BASE_DN" ]; then
    IFS='.' read -ra BASE_DN_TABLE <<< "$DOMAIN"
    for i in "${BASE_DN_TABLE[@]}"; do
      EXT="dc=$i,"
      BASE_DN=$BASE_DN$EXT
    done

    BASE_DN=${BASE_DN::-1}
  fi

#config
URI="ldap://127.0.0.1:389"

#dynamic
LDAP_PARAM="$1"
LDAP_RESPONSE_KEY="${2:-monitorCounter}"

#get LDAP response
COMMAND="ldapsearch -H $URI -b $LDAP_PARAM -D cn=admin,$BASE_DN -w $CONFIG_PASS"
RAW=$($COMMAND -s base '(objectClass=*)' '*' '+')

#parse out number
RESULT=$(eval "echo '$RAW' | sed -n 's/^[ \t]*$LDAP_RESPONSE_KEY:[ \t]*\(.*\)/\1/p'")

echo $RESULT

