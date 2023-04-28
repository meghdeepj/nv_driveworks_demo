#!/usr/bin/env bash

set -e

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

# ros2 development tool
sudo tar --use-compress-program=pigz -xvpf res/ros-foxy.tar.gz -C /drive/drive-linux/filesystem/targetfs/
export ROS2_HOME=/drive/drive-linux/filesystem/targetfs/opt/ros/foxy/
export PYTHONPATH=${ROS2_HOME}/lib/python3.8/site-packages
export PATH=${PATH}:${ROS2_HOME}/bin
sudo -H python3 -m pip install -U vcstool colcon-common-extensions
sudo dpkg --add-architecture arm64
sudo apt install libspdlog-dev:arm64 libyaml-dev:arm64 libpython3-dev:arm64 libtinyxml2-dev:arm64 libssl-dev:arm64 openssl:arm64 -y
