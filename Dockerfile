FROM mwaeckerlin/ubuntu-base
MAINTAINER mwaeckerlin
ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

ENV ADMIN "admin"
ENV PASSWORD "admin"
ENV ROOT "/"

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y debconf-utils apache2 libapache2-mod-php dokuwiki graphviz default-jre-headless wget php7.0-xml
RUN mkdir -p /var/lib/dokuwiki/lib/plugins/plantuml
RUN wget -O/var/lib/dokuwiki/lib/plugins/plantuml/plantuml.jar 'http://downloads.sourceforge.net/project/plantuml/plantuml.jar?r=http%3A%2F%2Fplantuml.com%2Fdownload&ts=1480882003&use_mirror=netix'
RUN chown -R www-data.www-data /var/lib/dokuwiki/lib/plugins
RUN touch /firstrun
ADD start.sh /start.sh
CMD /start.sh

EXPOSE 80
VOLUME /var/lib/dokuwiki
VOLUME /etc/dokuwiki
