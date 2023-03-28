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

```sh
docker load -i ./drive-sdk-docker-6.0.6.tar
# nvcr.io/drive/driveos-sdk/drive-agx-orin-linux-aarch64-sdk-build-x86   6.0.6.0-0004               2a61be9dd0a0   8 weeks ago    54.1GB
# 启动docker, 容器名称为gw_sdk_20.04_${USER}
./docker/build/docker_build.sh
# 进入container
./docker/build/docker_into.sh
# 额外安装软件
pip3 config set global.trusted-host https://pypi.tuna.tsinghua.edu.cn
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
sudo pip3 config set global.trusted-host https://pypi.tuna.tsinghua.edu.cn
sudo pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

sudo apt update
sudo apt install python3-numpy -y
sudo apt install python3-pip -y
sudo -H python3 -m pip install jsonschema
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

cmake -B /gw_demo/target/aarch64/build \
    -DCMAKE_TOOLCHAIN_FILE=/usr/local/driveworks/samples/cmake/Toolchain-V5L.cmake \
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

## 打包(暂不可用)

```sh
make -C /gw_demo/target/aarch64/build -j3 package
```

## 开发

todo: 优化开发体验：install vscode server in the docker container

### vscode跳转

安装cpp插件，编辑`./.vscode/c_cpp_properties.json` 设置driveworks和driveos的目录，即可跳转。

安装cmake-tools插件，即可获得完整cmake开发体验。

## 调试

基于vscode工具链的调试

## 架构

### 构建架构

内部代号：gaworks, 开发代号gw, GW

```sh
.
├── 3rdparty
│   ├── linux-aarch64  # linux-aarch64交叉编译的内容
│   │   ├── vibrante
│   │   ├── vibrante_Xlibs
│   │   └── zlib
│   └── src
│       ├── glew
│       ├── glfw
│       └── lodepng
├── cmake  # cmake配置文件
├── doc # 文档
│   ├── basic
│   ├── deploy
│   ├── design
│   │   └── cgf
│   ├── schema
│   │   ├── 5.10
│   │   └── 5.8
│   └── tutorial
│       └── dwcgf
├── docker # docker配置文件
│   ├── build # 当前进入默认docker的脚本
│   ├── run # 进入项目docker的脚本(暂未实现)
│   ├── scripts # 一些附加脚本
│   └── sdkm # sdk manager的docker运行脚本
├── example # 示例项目，按照项目单独安装其目标文件
│   └── dwcgf
│       └── helloworld
├── extern # 引用的外部库目录，从git-repo clone下来，包括项目名/inclue 和项目名/lib 以及对应的cmake
├── modules # 项目模块，根据功能分项目，分文件夹，其目标文件安装在deb顶层
│   ├── dwcgf # 图模型项目
│   └── perception_demo # 一个算法模块示例项目
├── scripts # 脚本
├── target # 目标目录，该目录不上库
│   └── x86 # cmake构建架构
│       ├── build # build目录
│       └── install # 安装目录
└── tools # 工具
```

### 运行架构

```sh
.
├── bin # 项目bin目录
├── data # 项目data目录
├── example # 示例目录
│   └── dwcgf_helloworld # 示例项目的安装目标文件
│       ├── bin
│       ├── data
│       ├── graphs
│       └── lib
├── graphs # 项目graphs目录
└── lib # 项目lib目录
```

## 已知问题

### docker环境问题

- docker环境下terminal没有彩色输出
- docker环境下terminal apt安装不能tab
- docker环境下不能启动界面?
