FROM ubuntu:19.10

LABEL author="Deepak Nadig" \
      version="1.0" \
      description="Named Data Networking (NDN) Docker container." \
      ndn-version="0.7"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository -y ppa:named-data/ppa \
    && apt-get install -y nfd ndn-tools ndn-traffic-generator \
    && apt-get -y purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 6363/tcp
EXPOSE 6363/udp
EXPOSE 9696/tcp
EXPOSE 9696/udp
EXPOSE 56363/tcp
EXPOSE 56363/udp

ENTRYPOINT /config/nfd-start -f
