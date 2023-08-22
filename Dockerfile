FROM fedora:38
LABEL org.opencontainers.image.source https://github.com/sethhall/zeekjs-container

# Dependencies required to compile and test ZeekJS on Fedora
RUN dnf install -y \
    cmake \
    diffutils \
    dnf-plugins-core \
    gcc-c++ \
    gdb \
    which \
    clang-tools-extra \
    flex \
    bison \
    libpcap-devel \
    swig \
    python3-devel \
    ninja-build \
    zlib-devel \
    openssl-devel \
    nodejs-devel \
    v8-devel

ENV ZEEK_VERSION=6.0.0
ENV ZEEK_SHA256=cc37587389ec96a2437c48851a6ef8300b19a39d9e6a1c9066570c25b070d0e2

RUN mkdir /zeek && \
    curl -sSL https://download.zeek.org/zeek-${ZEEK_VERSION}.tar.gz | tar -xzC /zeek --strip-components=1 && \
    cd /zeek && \
    ./configure --build-type=Release --generator=Ninja --disable-python && \
    cd build && \
    ninja install && \
    cd / && \
    rm -rf /zeek

RUN dnf install -y \
    yarnpkg \
    git \
    git-lfs \
    procps

ENV PATH=/usr/local/zeek/bin:$PATH
#RUN zkg install --force zeekjs zeek-af_packet-plugin
