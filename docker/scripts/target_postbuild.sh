#!/usr/bin/env bash

set -e

# 额外安装软件
sudo apt update
sudo apt install nano pigz bc strace ltrace -y

# ros2 runtime-dependencies
sudo apt install libboost-thread-dev

# ros2 prebuilt-binary
sudo mkdir -p /opt/ros/foxy-smacc2/
sudo tar --use-compress-program=pigz -xvpf res/ros-foxy-smacc2.tar.gz -C /opt/ros/foxy-smacc2/
