#!/usr/bin/env bash

set -e

sudo apt update
sudo apt install python3-pip -y
pip3 config set global.trusted-host https://pypi.tuna.tsinghua.edu.cn
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
sudo pip3 config set global.trusted-host https://pypi.tuna.tsinghua.edu.cn
sudo pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 额外安装软件
sudo apt install pigz bc -y
# for smacc2
sudo apt install -y libboost-dev libboost-thread-dev
