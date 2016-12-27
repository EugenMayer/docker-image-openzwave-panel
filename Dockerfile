############################################################
# Dockerfile to build OpenZWave Library container images
# Based on rpi-raspbian:jessie for raspberry pi
############################################################

FROM resin/rpi-raspbian:jessie

# File Author / Maintainer
MAINTAINER Eugen Mayer


# Add the package verification key
RUN apt-get update \
 && apt-get upgrade \
 && apt-get install -y wget git supervisor \
 && mkdir -p /var/log/supervisor

COPY Makefile.PATCHED /tmp/Makefile

RUN apt-get install -y build-essential libmicrohttpd-dev libgnutls28-dev \
 && ldconfig \
 && git clone https://github.com/OpenZWave/open-zwave.git open-zwave
 && git clone https://github.com/OpenZwave/open-zwave-control-panel open-zwave-control-panel \
 && cd open-zwave-control-panel \
 && mv /tmp/Makefile .

# TOOD: merge that with the upper when we finalized the build
# RUN make

# RUN apt-get purge buld-essential

COPY supervisor/supervisor_main.conf /etc/supervisor/conf.d/main.conf
COPY supervisor/open-zwave.conf /etc/supervisor/conf.d/open-zwave.conf

#COPY /files/Makefile $HOME/open-zwave-control-panel/
#ADD https://raw.githubusercontent.com/OpenZWave/open-zwave/master/cpp/tinyxml/tinyxml.h $HOME/open-zwave-control-panel/
#ADD https://raw.githubusercontent.com/OpenZWave/open-zwave/master/cpp/tinyxml/tinystr.h $HOME/open-zwave-control-panel/
#EXPOSE 8008
#ENTRYPOINT ["/home/ozwcp_user/open-zwave-control-panel/ozwcp", "-p 8008"]
ENTRYPOINT ["/usr/bin/supervisord", "-c"]
CMD ["/etc/supervisor/supervisord.conf"]