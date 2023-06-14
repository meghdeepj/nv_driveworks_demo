#!/usr/bin/env bash

set -e

GW_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd -P )"
GW_RES_DIR=$GW_ROOT_DIR/res/misc

# 额外安装软件
sudo apt update
sudo apt install python3-numpy -y
sudo apt install python3-pip -y
pip3 config set global.trusted-host https://pypi.tuna.tsinghua.edu.cn
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
sudo pip3 config set global.trusted-host https://pypi.tuna.tsinghua.edu.cn
sudo pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
sudo -H python3 -m pip install jsonschema
# gtest 暂不实施
# sudo apt install libgtest-dev
# cd /usr/src/gtest
# sudo cmake CMakeLists.txt
# sudo make
# sudo cp lib/*.a /usr/lib

# download res
# wget -N -tries=20 -c -i $GW_RES_DIR/files.txt -P $GW_RES_DIR

# ros2 development tool
sudo tar --use-compress-program=pigz -xvpf res/misc/ros-foxy.tar.gz -C /drive/drive-linux/filesystem/targetfs/
sudo -H python3 -m pip install -U vcstool colcon-common-extensions lark
sudo dpkg --add-architecture arm64
sudo apt install libspdlog-dev:arm64 libyaml-dev:arm64 libpython3-dev:arm64 libtinyxml2-dev:arm64 libssl-dev:arm64 openssl:arm64 -y

# ros2 cross-build dependencies: may break host drivesdk environment
sudo apt install -y libboost-dev:arm64 libboost-thread-dev:arm64
# uuid-dev:arm64 break driveos

# ros2 prebuilt-binary
# sudo mkdir -p /drive/drive-linux/filesystem/targetfs/opt/ros/foxy-smacc2/
# sudo tar --use-compress-program=pigz -xvpf res/misc/ros-foxy-smacc2.tar.gz -C /drive/drive-linux/filesystem/targetfs/opt/ros/foxy-smacc2/
