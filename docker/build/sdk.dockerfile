# https://yeasy.gitbook.io/docker_practice/image/build
# docker build -t nvcr.io/drive/driveos-sdk/drive-agx-orin-linux-aarch64-sdk-build-x86:6.0.6.0-0004-dev -f ./docker/build/sdk.dockerfile .
# docker save -o drive-sdk-docker-6.0.6-dev.tar nvcr.io/drive/driveos-sdk/drive-agx-orin-linux-aarch64-sdk-build-x86:6.0.6.0-0004-dev
# 原则：环境变量docker-run后加，文件固化在docker中
FROM nvcr.io/drive/driveos-sdk/drive-agx-orin-linux-aarch64-sdk-build-x86:6.0.6.0-0004

# 安装deb依赖
RUN set -x; \
    cp /etc/apt/sources.list /etc/apt/sources.list.bak \
    && sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
    && sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
    && apt update \
    && apt install -y python3-numpy python3-pip \
    && pip3 config set global.trusted-host https://pypi.tuna.tsinghua.edu.cn \
    && pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && python3 -m pip install jsonschema vcstool colcon-common-extensions lark \
    && dpkg --add-architecture arm64 \
    && apt install -y libspdlog-dev:arm64 libyaml-dev:arm64 libpython3-dev:arm64 libtinyxml2-dev:arm64 libssl-dev:arm64 openssl:arm64 libboost-dev:arm64 libboost-thread-dev:arm64 \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/apt/sources.list \
    && mv /etc/apt/sources.list.bak /etc/apt/sources.list

ADD res/misc/ros-foxy.tar.gz /drive/drive-linux/filesystem/targetfs/
