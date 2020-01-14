#!/usr/bin/with-contenv bash

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
function file_env () {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  local val="$def"
  if [ "${!fileVar:-}" ]; then
    val="$(cat "${!fileVar}")"
  elif [ "${!var:-}" ]; then
    val="${!var}"
  fi
  if [ -z ${val} ]; then
    print_error "error: neither $var nor $fileVar are set but are required"
    exit 1
  fi
  export "$var"="$val"
  unset "$fileVar"
}

# if BASE_DN is empty set value from DOMAIN
  if [ -z "$BASE_DN" ]; then
    IFS='.' read -ra BASE_DN_TABLE <<< "$DOMAIN"
    for i in "${BASE_DN_TABLE[@]}"; do
      EXT="dc=$i,"
      BASE_DN=$BASE_DN$EXT
    done

    BASE_DN=${BASE_DN::-1}
  fi

file_env 'ADMIN_PASS'

#dynamic
LDAP_PARAM="$1"
LDAP_RESPONSE_KEY="${2:-monitorCounter}"

#get LDAP response
COMMAND="ldapsearch -H ldap://$HOSTNAME:389 -b $LDAP_PARAM -D cn=admin,$BASE_DN -w $ADMIN_PASS"
RAW=$($COMMAND -s base '(objectClass=*)' '*' '+')

#parse out number
RESULT=$(eval "echo '$RAW' | sed -n 's/^[ \t]*$LDAP_RESPONSE_KEY:[ \t]*\(.*\)/\1/p'")

echo $RESULT

