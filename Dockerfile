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
 && mkdir "${WEB_ROOT_PATH}" \
 && wget -qO- https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz \
    | tar xz --strip-components 1 -C "${WEB_ROOT_PATH}" \
 && chown -R ${WWWUSER}:${WWWGROUP} "${WEB_ROOT_PATH}"/conf "${WEB_ROOT_PATH}"/data "${WEB_ROOT_PATH}"/lib/plugins "${WEB_ROOT_PATH}"/lib/tpl  \
 && cp -a "${WEB_ROOT_PATH}"/conf "${WEB_ROOT_PATH}"/conf.dist \
 && cp -a "${WEB_ROOT_PATH}"/lib/plugins "${WEB_ROOT_PATH}"/lib/plugins.dist \
 && cp -a "${WEB_ROOT_PATH}"/lib/tpl "${WEB_ROOT_PATH}"/lib/tpl.dist \
 && apk add php-xml php-gd php-session php-json php-ldap php7-openssl graphviz rsync
ADD nginx.conf /etc/nginx/conf.d/default.conf
ADD start.sh /start.sh
WORKDIR "${WEB_ROOT_PATH}"
USER ${WWWUSER}

VOLUME "${WEB_ROOT_PATH}"/conf
VOLUME "${WEB_ROOT_PATH}"/data
VOLUME "${WEB_ROOT_PATH}"/lib/plugins
VOLUME "${WEB_ROOT_PATH}"/lib/tpl
