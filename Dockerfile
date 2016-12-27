############################################################
# Dockerfile to build OpenZWave Library container images
# Based on rpi-raspbian:jessie for raspberry pi
############################################################

FROM resin/rpi-raspbian:jessie

# File Author / Maintainer
MAINTAINER Eugen Mayer

WORKDIR /opt

# Add the package verification key
RUN apt-get update \
 && apt-get upgrade \
 && apt-get install -y wget git supervisor \
 && mkdir -p /var/log/supervisor

COPY Makefile.PATCHED /tmp/Makefile.PATCHED

# compile libmicrohttpd / open-zwave and open-zwave-panel
RUN apt-get install -y build-essential libudev-dev libmicrohttpd-dev libgnutls28-dev \
 && wget ftp://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.19.tar.gz \
 && tar zxvf libmicrohttpd-0.9.19.tar.gz && mv libmicrohttpd-0.9.19 libmicrohttpd && rm libmicrohttpd-0.9.19.tar.gz \
 && cd libmicrohttpd && ./configure && make && make install \
 && ldconfig \
 && cd /opt \
 && git clone https://github.com/OpenZWave/open-zwave.git open-zwave \
 && cd open-zwave && make \
 && cd /opt \
 && git clone https://github.com/OpenZwave/open-zwave-control-panel open-zwave-control-panel \
 && cd open-zwave-control-panel \
 && ln -sd ../open-zwave/config \
 && mv /tmp/Makefile.PATCHED Makefile \
 && make \
 && apt-get purge buld-essential libudev-dev libmicrohttpd-dev libgnutls28-dev

COPY supervisor/supervisor_main.conf /etc/supervisor/conf.d/main.conf
COPY supervisor/open-zwave.conf /etc/supervisor/conf.d/open-zwave.conf

#ADD https://raw.githubusercontent.com/OpenZWave/open-zwave/master/cpp/tinyxml/tinyxml.h $HOME/open-zwave-control-panel/
#ADD https://raw.githubusercontent.com/OpenZWave/open-zwave/master/cpp/tinyxml/tinystr.h $HOME/open-zwave-control-panel/

ENTRYPOINT ["/usr/bin/supervisord", "-c"]
CMD ["/etc/supervisor/supervisord.conf"]