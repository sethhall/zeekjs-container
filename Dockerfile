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

ENV ZEEK_VERSION=5.0.4
ENV ZEEK_SHA256=d01aa72864b1128513c0b3667148e765f83cd9f0befe9a751c51f0f19a8ba280

RUN mkdir /zeek && \
    curl -sSL https://download.zeek.org/zeek-${ZEEK_VERSION}.tar.gz | tar -xzC /zeek --strip-components=1 && \
    cd /zeek && \
    ./configure --generator=Ninja --disable-python && \
    cd build && \
    ninja -j5 install && \
    cd / && \
    rm -rf /zeek

RUN dnf install -y \
    nodejs-devel \
    v8-devel \
    yarnpkg \
    git \
    git-lfs

ENV PATH=/usr/local/zeek/bin:$PATH

ENV ZEEKJS_VER=0.4.2
ENV ZEEKJS_FILE=zeekjs-${ZEEKJS_VER}.tar.gz
ENV ZEEKJS_URL=https://github.com/corelight/zeekjs/archive/refs/tags/v${ZEEKJS_VER}.tar.gz
RUN curl -L -sSf -o ${ZEEKJS_FILE} ${ZEEKJS_URL} && \
    tar -xzf ${ZEEKJS_FILE} && \
    rm ${ZEEKJS_FILE} && \
    cd zeekjs-${ZEEKJS_VER} && \
    rm -rf build && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf zeekjs-${ZEEKJS_VER}
