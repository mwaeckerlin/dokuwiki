#!/bin/sh -e

# call option with parameters: $1=name $2=value $3=file
function config() {
    echo '---- configuring $conf['"'$1'] = $2; in ${3:-/dokuwiki/etc/local.php}"
    name=${1//\//\\/}
    value=${2//\//\\/}
    sed -i \
        -e '/^#\?\(\s*\$conf\['"'${name}'"'\]\s*=\s*\).*/{s//\1'"${value}"';/;:a;n;ba;q}' \
        -e '$a$conf['"'${name}'"'] = '"${value};" ${3:-/dokuwiki/etc/local.php}
}

test -e /dokuwiki/etc/plugins.local.php || touch /dokuwiki/etc/plugins.local.php

test -e /dokuwiki/etc/local.php || cat <<EOF > /dokuwiki/etc/local.php
<?php
\$conf['useacl'] = 1;
\$conf['superuser'] = '@admin';
EOF

test -e /dokuwiki/etc/acl.auth.php || cat <<EOF > /dokuwiki/etc/acl.auth.php
# acl.auth.php
# <?php exit()?>
# Don't modify the lines above
#
# Access Control Lists
#
# Editing this file by hand shouldn't be necessary. Use the ACL
# Manager interface instead.
#
# If your auth backend allows special char like spaces in groups
# or user names you need to urlencode them (only chars <128, leave
# UTF-8 multibyte chars as is)
#
# none   0
# read   1
# edit   2
# create 4
# upload 8
# delete 16
*               @ALL        0
EOF

test -e /dokuwiki/etc/users.auth.php || cat <<EOF > /dokuwiki/etc/users.auth.php
# users.auth.php
# <?php exit()?>
# Don't modify the lines above
#
# Userfile
#
# Format:
#
# login:passwordhash:Real Name:email:groups,comma,separated
EOF

for file in pages attic media media_attic meta media_meta cache index locks tmp; do
    test -e /dokuwiki/data/$file || mkdir /dokuwiki/data/$file
done

if test -n "${PASSWORD}" -a -n "${ADMIN}"; then
    if ! egrep -qe "^${ADMIN}:" /dokuwiki/etc/users.auth.php; then
        echo "---- configure initial admin user"
        echo ${ADMIN}:$(mkpasswd -m md5 "$PASSWORD"):${NAME:-${ADMIN}}:${MAIL:-${ADMIN}@localhost}':admin,user' >> /dokuwiki/etc/users.auth.php
        if ! egrep -qe '^ *\$conf['superuser'] *=' /dokuwiki/etc/local.php; then
            config superuser "'@admin'"
        fi
    fi
fi

test -z "${BASEURL}" || config baseurl "'${BASEURL}'"
test -z "${BASEDIR}" || config basedir "'${BASEDIR}'"

/start-php-fpm.sh
