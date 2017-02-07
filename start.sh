#!/bin/bash

if test -e /firstrun; then
    if test -z "${PASSWORD}"; then
        echo "**** ERROR: set a password, use -e PASSWORD=YourPassWord" 1>&2
        exit 1
    fi
    echo "Setting Up Dokuwiki ..."
    debconf-set-selections <<EOF
dokuwiki dokuwiki/wiki/superuser string ${ADMIN}
dokuwiki dokuwiki/wiki/password password ${PASSWORD}
dokuwiki dokuwiki/wiki/confirm password ${PASSWORD}
dokuwiki dokuwiki/system/documentroot string ${ROOT}
dokuwiki dokuwiki/system/configure-webserver multiselect apache2
dokuwiki dokuwiki/system/writeplugins boolean true
dokuwiki dokuwiki/system/writeconf boolean true
dokuwiki dokuwiki/system/accessible select global
dokuwiki dokuwiki/system/purgepages boolean false
dokuwiki dokuwiki/system/restart-webserver boolean false
dokuwiki dokuwiki/wiki/license select gnufdl
dokuwiki dokuwiki/wiki/policy select public
dokuwiki dokuwiki/wiki/acl boolean true
EOF
    #DEBIAN_FRONTEND=noninteractive apt-get install -y --no-download dokuwiki
    dpkg-reconfigure -f noninteractive dokuwiki
    rm /firstrun
    echo "Dokuwiki Configured."
fi

echo "see: http://localhost${ROOT}"
if test -f /run/apache2/apache2.pid; then
    rm /run/apache2/apache2.pid;
fi;
apache2ctl -DFOREGROUND
