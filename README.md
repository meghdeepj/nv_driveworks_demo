# nv_driveworks_demo

## 简介

driveworks开发demo

- 上位机docker编译环境
- 上位机docker运行调试环境
- 上位机docker交叉编译环境
- 目标机orin部署环境
- 目标机orin远程调试环境

## 可执行权限问题

```sh
chmod +x -R ./docker/
chmod +x -R ./scripts/
```

## docker环境

### sdk-docker

```sh
docker load -i ./drive-sdk-docker-6.0.6.tar
docker pull nvcr.io/drive/driveos-sdk/drive-agx-orin-linux-aarch64-sdk-build-x86
# nvcr.io/drive/driveos-sdk/drive-agx-orin-linux-aarch64-sdk-build-x86   6.0.6.0-0004               2a61be9dd0a0   8 weeks ago    54.1GB
# 启动docker, 容器名称为gw_sdk_20.04_${USER}
./docker/build/sdk_build.sh
# 进入container
./docker/build/sdk_into.sh
# 额外安装软件
./docker/scripts/sdk_postbuild.sh
```

### orin-docker

运行时docker在x86平台构建

```sh
docker pull arm64v8/ros:foxy
# 启动docker, 容器名称为gw_orin_20.04_${USER}
./docker/build/orin_build.sh
# 进入container
./docker/build/orin_into.sh
# 额外安装软件
./docker/scripts/orin_postbuild.sh
```

### target-docker

运行时docker在orin平台运行 <https://developer.nvidia.com/blog/running-docker-containers-directly-on-nvidia-drive-agx-orin/>

```sh
docker pull arm64v8/ros:foxy
# 启动docker, 容器名称为gw_orin_20.04_${USER}
./docker/run/orin_build.sh
# 进入container
./docker/run/orin_into.sh
# 额外安装软件
./docker/scripts/target_postbuild.sh
```

## 构建

### 本地编译

cmake的使用参考<https://manpages.ubuntu.com/manpages/bionic/man1/cmake.1.html>

```sh
cd gw_demo
cmake -B /gw_demo/target/x86/build
rm -rf /gw_demo/target/x86/build

make -C /gw_demo/target/x86/build -j3
make -C /gw_demo/target/x86/build -j3 clean

make -C /gw_demo/target/x86/build -j3 install

cd target/x86/install/example/dwcgf_helloworld/lib/
ldd ./libcgf_custom_nodes.so
ldd ./libcgf_custom_nodes.so | grep found
```

### driveworks验证

```sh
cmake -B /gw_demo/target/aarch64-sample/build \
    -DCMAKE_TOOLCHAIN_FILE=/usr/local/driveworks/samples/cmake/Toolchain-V5L.cmake \
    -DVIBRANTE_PDK=/drive/drive-linux -S /usr/local/driveworks/samples
make -C /gw_demo/target/aarch64-sample/build -j3
make -C /gw_demo/target/aarch64-sample/build -j3 install
```

### 交叉编译

- 构建目录设置到`target`目录，`target` 目录拷贝到目标机器

```sh
cd gw_demo
./gw.sh cmake_aarch64
./gw.sh make_aarch64
./gw.sh install_aarch64
# clean
./gw.sh clean
```

```sh
cd gw_demo

cmake -B /gw_demo/target/aarch64/build \
    -DCMAKE_TOOLCHAIN_FILE=/gw_demo/cmake/Toolchain-V5L.cmake \
    -DVIBRANTE_PDK=/drive/drive-linux

rm -rf /gw_demo/target/aarch64/build

make -C /gw_demo/target/aarch64/build -j3
make -C /gw_demo/target/aarch64/build -j3 clean

make -C /gw_demo/target/aarch64/build -j3 install

# install path is ./install/gw_demo/
# copy target to orin device
cd target/aarch64/install/gw_demo/lib/
ldd ./libcgf_custom_nodes.so
ldd ./libcgf_custom_nodes.so | grep found
```

### 交叉编译ROS2包

- 构建目录设置到`target`目录，`target` 目录拷贝到目标机器

```sh
cd gw_demo
./gw_ros.sh build_rel
# clean
./gw_ros.sh clean
```

### 打包(不可用)

- 构建目录设置到`target`目录，`target` 目录拷贝到目标机器

```sh
# 不可用
make -C /gw_demo/target/aarch64/build -j3 package
```

## vscode编译配置

### tasks

已经配置好`tasks.json`，可通过task实现快捷操作

使用方式为：`Ctrl+Shift+P` + `Tasks: Run Task` + `选择具体的task`


### cpp开发支持

安装cpp插件，编辑`./.vscode/c_cpp_properties.json` 设置driveworks和driveos的目录，即可跳转。

安装cmake-tools插件，即可获得完整cmake开发体验。

### 错误查看和跳转

为了实现查看错误跳转，创建一些软连接

```sh
ln -s $PWD ./gw_demo
sudo ln -s $PWD /gw_demo
# to use dwcgf-tools out of docker
sudo ln -s ~/orin_ws/nv_driveworks/driverorks-5.10/ /usr/local/driveworks
```

todo: 优化开发体验：install vscode server in the docker container

## 运行

### example

以`dwcgf_helloworld`为例

```sh
cd /target/aarch64/install/example/dwcgf_helloworld
sudo ./bin/run_cgf.sh
# 删除日志
sudo rm -rf ./LogFolder/ ./framesync_*
# 查看日志
tail -n 50 -f ./LogFolder/helloworld_process0_0.log
```

### 项目module

以`dwcgf_image_pipe`为例

```sh
cd /target/aarch64/install/bin
sudo ./dwcgf_image_pipe/runRawCameraDeployPipe.sh
# 删除日志
sudo rm -rf ./LogFolder/ ./framesync_*
# 查看日志
tail -n 50 -f ./LogFolder/dwcgf_image_pipe/RawCameraDeployPipe/pilotPipe_process_0.log
```

### ros2

```sh
# source prebuilt ros2 env
source ./docker/scripts/my.bashrc
# source the current project ros2 env
source ./colcon/install/local_setup.bash
```

### tmux

tmux是一款好用的工具，此处tmux脚本仅供运行时target-orin-docker使用。

```sh
# in host
cd /target
./tmux_into.sh
# close the tmux
tmux kill-session -t target_tmux_into
```

## 调试

### debug编译

由于设置了`set(CMAKE_DEBUG_POSTFIX _d)`, 所有debug lib都添加后缀`_d`

以下以x86平台为例

```sh
cmake -B /gw_demo/target/x86/build -DCMAKE_BUILD_TYPE=Debug
rm -rf /gw_demo/target/x86/build

make -C /gw_demo/target/x86/build -j3
make -C /gw_demo/target/x86/build -j3 clean

make -C /gw_demo/target/x86/build -j3 install

cd target/x86/install/bin/module_demo
ldd ./module_demo_main | grep _d

cd target/x86/install/lib/module_demo
ldd ./libmodule_demo_d.so
ldd ./libmodule_demo_d.so | grep found
```

### 开发时调试

已经编写了`launch.json`

```sh

```

### 运行时调试

已经编写了`launch.json`

```sh

```

## 架构

### 构建架构

内部代号：gaworks, 开发代号gw, GW

```sh
date && tree -d -L 3
Mon Apr 24 14:32:07 CST 2023
.
|-- 3rdparty
|   |-- linux-aarch64
|   |   |-- vibrante
|   |   |-- vibrante_Xlibs
|   |   `-- zlib
|   `-- src
|       |-- glew
|       |-- glfw
|       `-- lodepng
|-- cmake
|-- doc
|   |-- basic
|   |-- deploy
|   |-- design
|   |   `-- cgf
|   |-- module
|   |   `-- xcgf
|   |-- schema
|   |   |-- 5.10
|   |   `-- 5.8
|   `-- tutorial
|       `-- dwcgf
|-- docker
|   |-- build # 开发时容器环境
|   |-- run
|   |-- scripts
|   `-- sdkm
|-- example
|   `-- dwcgf
|       |-- camera_driver
|       `-- helloworld
|-- extern # 引用的外部库目录，从git-repo clone下来，包括项目名/inclue 和项目名/lib 以及对
|-- modules # 项目模块，根据团队分文件夹，一个团队一个git仓，根据功能分项目，其目标文件安装在deb顶层
|   |-- module_demo
|   |   |-- include
|   |   |-- lib
|   |   |-- src
|   |   `-- test
|   |-- perception # 感知团队
|   `-- xplatform # 平台团队
|       `-- xcgf
|-- packages # ros2 包
|   `-- demo_nodes_cpp_native
|       |-- include
|       |-- src
|       `-- test
|-- res # 资源
|-- scripts # 脚本
|-- target # 目标目录，该目录不上库
|   |-- aarch64 # 目标架构目录
|   |   |-- build # build目录
|   |   `-- install # 安装目录
|   |-- colcon # ros2 构建目录
|   |   |-- build
|   |   |-- install # ros2 安装目录
|   |   `-- log
|   `-- docker
|       |-- build
|       |-- run # 运行时容器环境
|       |-- scripts
|       `-- sdkm
`-- tools # 工具
```

### 运行架构

```sh
cd /target
date && tree -d -L 3
Mon May 15 01:57:24 PM CST 2023
.
├── aarch64 # 目标架构目录
│   └── install
│       ├── bin # 项目bin目录
│       ├── data data # 项目data目录
│       ├── example # 示例目录
│       ├── graphs # cgf图模型目录
│       └── lib
├── colcon
│   ├── install # ros2 安装目录
│   │   ├── include
│   │   ├── lib
│   │   └── share
├── docker
│   ├── build
│   ├── run # 运行时docker
│   ├── scripts
│   └── sdkm
└── res # 资源目录
```

## 已知问题

### docker环境问题

- docker环境下terminal没有彩色输出
- docker环境下terminal apt安装不能tab
- [*]docker环境下不能启动界面? (已解决 -e DISPLAY)
