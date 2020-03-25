FROM ubuntu:19.10
RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository -y ppa:named-data/ppa \
    && apt-get install -y nfd \
    && apt-get -y purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get clean

EXPOSE 6363/tcp
EXPOSE 6363/udp

CMD /usr/bin/nfd --config /etc/ndn/nfd.conf
