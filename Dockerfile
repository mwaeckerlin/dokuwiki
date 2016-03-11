FROM ubuntu
MAINTAINER mwaeckerlin
ENV TERM xterm

ENV ADMIN "admin"
ENV PASSWORD "admin"
ENV ROOT "/dokuwiki"

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y debconf-utils apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yd dokuwiki
RUN touch /firstrun
ADD start.sh /start.sh
CMD /start.sh

EXPOSE 80
VOLUME /var/lib/dokuwiki
VOLUME /etc/dokuwiki
