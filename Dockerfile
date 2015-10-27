FROM ubuntu
MAINTAINER mwaeckerlin

ENV ADMIN "admin"
ENV PASSWORD "admin"
ENV ROOT "/dokuwiki"

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y debconf-utils apache2 dokuwiki
RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y dokuwiki
RUN touch /firstrun

CMD if test -e /firstrun; then \
      if test -z "${PASSWORD}"; then \
        echo "**** ERROR: set a password, use -e PASSWORD=YourPassWord" 1>&2; \
        exit 1; \
      fi; \
      echo "Setting Up Dokuwiki ..."; \
      ( echo "dokuwiki dokuwiki/wiki/superuser string ${ADMIN}"; \
        echo "dokuwiki dokuwiki/wiki/password password ${PASSWORD}"; \
        echo "dokuwiki dokuwiki/wiki/confirm password ${PASSWORD}"; \
        echo "dokuwiki dokuwiki/system/documentroot string ${ROOT}"; \
        echo "dokuwiki dokuwiki/system/configure-webserver multiselect apache2"; \
        echo "dokuwiki dokuwiki/system/writeplugins boolean true"; \
        echo "dokuwiki dokuwiki/system/writeconf boolean true"; \
        echo "dokuwiki dokuwiki/system/accessible select global"; \
        echo "dokuwiki dokuwiki/system/purgepages boolean false"; \
        echo "dokuwiki dokuwiki/system/restart-webserver boolean false"; \
        echo "dokuwiki dokuwiki/wiki/license select gnufdl"; \
        echo "dokuwiki dokuwiki/wiki/policy select public"; \
        echo "dokuwiki dokuwiki/wiki/acl boolean true"; ) \
      | debconf-set-selections; \
      DEBIAN_FRONTEND=noninteractive apt-get install -y dokuwiki; \
      rm /firstrun; \
      echo "Dokuwiki Configured."; \
    fi; \
    echo "see: http://localhost${ROOT}"; \
    apache2ctl -DFOREGROUND

VOLUME /var/lib/dokuwiki
VOLUME /etc/dokuwiki
