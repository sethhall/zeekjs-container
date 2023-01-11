FROM fedora:37
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
    openssl-devel

ENV ZEEK_VERSION=5.0.5
ENV ZEEK_SHA256=d01aa72864b1128513c0b3667148e765f83cd9f0befe9a751c51f0f19a8ba280

RUN mkdir /zeek && \
    curl -sSL https://download.zeek.org/zeek-${ZEEK_VERSION}.tar.gz | tar -xzC /zeek --strip-components=1 && \
    cd /zeek && \
    ./configure --build-type=Release --generator=Ninja --disable-python && \
    cd build && \
    ninja -j5 install && \
    cd / && \
    rm -rf /zeek

RUN dnf install -y \
    nodejs-devel \
    v8-devel \
    yarnpkg \
    git \
    git-lfs \
    python3-GitPython \
    python3-semantic_version \
    procps

ENV PATH=/usr/local/zeek/bin:$PATH
RUN zkg install --force zeekjs zeek-af_packet-plugin
