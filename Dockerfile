FROM mwaeckerlin/very-base AS build
RUN mkdir /app
RUN wget -qO- https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz | tar xz --strip-components 1 -C /app
RUN for f in $(find -name '*.dist'); do mv $f ${f%.dist}; done
RUN ${ALLOW_USER} /app/conf /app/data /app/lib/plugins /app/lib/tpl

FROM mwaeckerlin/nginx
ENV CONTAINERNAME  "dokuwiki"
COPY --from=build /root /
COPY secure.conf /etc/nginx/server.d/secure.conf
VOLUME /app/conf
VOLUME /app/data
VOLUME /app/lib/plugins
VOLUME /app/lib/tpl
