FROM ubuntu:19.10

RUN apt-get update \
    && RUNTIME_DEPS=" \
        libboost-chrono1.67.0 \
        libboost-date-time1.67.0 \
        libboost-filesystem1.67.0 \
        libboost-iostreams1.67.0 \
        libboost-log1.67.0 \
        libboost-program-options1.67.0 \
        libboost-random1.67.0 \
        libboost-regex1.67.0 \
        libboost-stacktrace1.67.0 \
        libboost-system1.67.0 \
        libsqlite3-0 \
        libssl1.1 \
        libboost-thread1.67.0 \
        libpcap0.8" \
    && \
    BUILD_DEPS=" \
        software-properties-common \
        build-essential \
        pkg-config \
        libboost-all-dev \
        libsqlite3-dev \
        libssl-dev \
        libpcap-dev \
        git" \
    && apt-get install -y $BUILD_DEPS $RUNTIME_DEPS\
    && cd /root/ \
    && git clone https://github.com/named-data/ndn-cxx \
    && git clone --recursive https://github.com/named-data/NFD \
    && git clone https://github.com/named-data/ndn-tools.git \
    && cd /root/ndn-cxx \
    && git checkout -b ndn-cxx-0.7.0 \
    && ./waf configure && ./waf && ./waf install && ldconfig \
    && cd /root/ && rm -r ndn-cxx \
    && cd /root/NFD \
    && git checkout -b NFD-0.7.0 \
    && ./waf configure && ./waf && ./waf install \
    && cd /root/ && rm -r NFD \
    && cd /usr/local/etc/ndn \
    && cp nfd.conf.sample nfd.conf \
    && cd /root/ndn-tools \
    && git checkout -b ndn-tools-0.7 \
    && ./waf configure && ./waf && ./waf install \
    && cd /root/ && rm -r ndn-tools \
    && apt-get -y remove --purge $BUILD_DEPS \
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

COPY nfd-start /usr/bin/nfd-start
RUN chown root:root /usr/bin/nfd-start
RUN chmod +x /usr/bin/nfd-start

ENTRYPOINT /usr/bin/nfd-start -f
