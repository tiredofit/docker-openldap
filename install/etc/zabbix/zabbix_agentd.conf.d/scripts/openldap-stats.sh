#!/command/with-contenv bash

source /assets/functions/00-container

# if BASE_DN is empty set value from DOMAIN
if [ -z "${BASE_DN}" ]; then
    IFS='.' read -ra BASE_DN_TABLE <<< "$DOMAIN"
    for i in "${BASE_DN_TABLE[@]}"; do
        EXT="dc=$i,"
        BASE_DN=$BASE_DN$EXT
    done

    BASE_DN=${BASE_DN::-1}
fi

transform_file_var \
                ADMIN_PASS

#dynamic
LDAP_PARAM="$1"
LDAP_RESPONSE_KEY="${2:-monitorCounter}"

#get LDAP response
COMMAND="ldapsearch -H ldap://$HOSTNAME:389 -b $LDAP_PARAM -D cn=admin,$BASE_DN -w $ADMIN_PASS"
RAW=$($COMMAND -s base '(objectClass=*)' '*' '+')

#parse out number
RESULT=$(eval "echo '$RAW' | sed -n 's/^[ \t]*$LDAP_RESPONSE_KEY:[ \t]*\(.*\)/\1/p'")

echo ${RESULT}

