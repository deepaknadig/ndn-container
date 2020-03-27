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
    && apt-get -y remove --purge $BUILD_DEPS \
    && apt-get -y purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 6363

ENTRYPOINT ["/usr/local/bin/nfd"]
CMD ["-c", "/usr/local/etc/ndn/nfd.conf"]
