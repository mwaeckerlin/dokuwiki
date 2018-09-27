#!/bin/sh -e

# fill emtpy volumes
cd "${WEB_ROOT_PATH}"/conf.dist
for f  in *; do
    if ! test -e ../conf/"$f"; then
        cp -a "$f" ../conf/"$f"
    fi
done
rsync -a "${WEB_ROOT_PATH}"/lib/plugins.dist/ "${WEB_ROOT_PATH}"/lib/plugins/
rsync -a "${WEB_ROOT_PATH}"/lib/tpl.dist/ "${WEB_ROOT_PATH}"/lib/tpl/

# call option with parameters: $1=name $2=value $3=file
function config() {
    echo '---- configuring $conf['"'$1'] = $2; in ${3:-"${WEB_ROOT_PATH}"/conf/local.php}"
    name=${1//\//\\/}
    value=${2//\//\\/}
    sed -i \
        -e '/^#\?\(\s*\$conf\['"'${name}'"'\]\s*=\s*\).*/{s//\1'"${value}"';/;:a;n;ba;q}' \
        -e '$a$conf['"'${name}'"'] = '"${value};" ${3:-"${WEB_ROOT_PATH}"/conf/local.php}
}

test -e "${WEB_ROOT_PATH}"/conf/plugins.local.php || touch "${WEB_ROOT_PATH}"/conf/plugins.local.php

test -e "${WEB_ROOT_PATH}"/conf/local.php || cat <<EOF > "${WEB_ROOT_PATH}"/conf/local.php
<?php
\$conf['useacl'] = 1;
\$conf['superuser'] = '@admin';
EOF

test -e "${WEB_ROOT_PATH}"/conf/acl.auth.php || cat <<EOF > "${WEB_ROOT_PATH}"/conf/acl.auth.php
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

test -e "${WEB_ROOT_PATH}"/conf/users.auth.php || cat <<EOF > "${WEB_ROOT_PATH}"/conf/users.auth.php
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
    test -e "${WEB_ROOT_PATH}"/data/$file || mkdir "${WEB_ROOT_PATH}"/data/$file
done

if test -n "${PASSWORD}" -a -n "${ADMIN}"; then
    if ! egrep -qe "^${ADMIN}:" "${WEB_ROOT_PATH}"/conf/users.auth.php; then
        echo "---- configure initial admin user"
        echo ${ADMIN}:$(mkpasswd -m md5 "$PASSWORD"):${NAME:-${ADMIN}}:${MAIL:-${ADMIN}@localhost}':admin,user' >> "${WEB_ROOT_PATH}"/conf/users.auth.php
        if ! egrep -qe '^ *\$conf['superuser'] *=' "${WEB_ROOT_PATH}"/conf/local.php; then
            config superuser "'@admin'"
        fi
    fi
fi

test -z "${BASEURL}" || config baseurl "'${BASEURL}'"
test -z "${BASEDIR}" || config basedir "'${BASEDIR}'"

/start-php-fpm.sh
