FROM mwaeckerlin/php-fpm
MAINTAINER mwaeckerlin

ENV ADMIN          "admin"
ENV PASSWORD       ""
ENV NAME           ""
ENV MAIL           ""
ENV BASEURL        ""
ENV BASEDIR        ""

ENV CONTAINERNAME  "dokuwiki"
ENV WEB_ROOT_PATH  "/dokuwiki"
USER root
RUN mv /start.sh /start-php-fpm.sh \
 && mkdir -p "${WEB_ROOT_PATH}"/etc \
 && wget -qO- https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz \
    | tar xz --strip-components 1 -C "${WEB_ROOT_PATH}" \
 && chown -R ${WWWUSER}:${WWWGROUP} "${WEB_ROOT_PATH}"/conf "${WEB_ROOT_PATH}"/etc "${WEB_ROOT_PATH}"/data  \
 && for file in local.php plugins.local.php acl.auth.php users.auth.php; do \
        path="${WEB_ROOT_PATH}"/conf/$file; \
        if test -e "$path"; then \
            mv "$path" "${WEB_ROOT_PATH}"/etc/$file; \
        elif test -e "$path".dist; then \
            mv "$path".dist "${WEB_ROOT_PATH}"/etc/$file; \
        else \
            touch "${WEB_ROOT_PATH}"/etc/$file; \
        fi; \
        ln -s ../etc/$file "$path" || exit 1; \
    done \
 && apk add php-xml php-gd php-session php-json php-ldap
ADD nginx.conf /etc/nginx/conf.d/default.conf
ADD start.sh /start.sh
USER ${WWWUSER}

VOLUME "${WEB_ROOT_PATH}"/etc
VOLUME "${WEB_ROOT_PATH}"/data
