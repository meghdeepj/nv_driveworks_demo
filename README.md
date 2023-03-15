# nv_driveworks_demo

## 简介

driveworks开发demo

- 上位机docker编译环境
- 上位机docker运行调试环境
- 上位机docker交叉编译环境
- 目标机orin部署环境
- 目标机orin远程调试环境

## 构建

### 本地编译

```sh
cd gw_demo
cmake -B /gw_demo/target/gw_demo-linux-x86
rm -rf /gw_demo/target/gw_demo-linux-x86

make -C /gw_demo/target/gw_demo-linux-x86 -j3
make -C /gw_demo/target/gw_demo-linux-x86 -j3 clean

make -C /gw_demo/target/gw_demo-linux-x86 -j3 install

cd target/gw_demo-linux-x86/install/gw_demo/lib/
ldd ./libcgf_custom_nodes.so
ldd ./libcgf_custom_nodes.so | grep found
```

### 交叉编译

- 构建目录设置到`target`目录，`target` 目录拷贝到目标机器

```sh
cd gw_demo
cmake -B /gw_demo/target/gw_demo-linux-aarch64 \
    -DCMAKE_TOOLCHAIN_FILE=/usr/local/driveworks/samples/cmake/Toolchain-V5L.cmake \
    -DVIBRANTE_PDK=/drive/drive-linux

rm -rf /gw_demo/target/gw_demo*

make -C /gw_demo/target/gw_demo-linux-aarch64 -j3
make -C /gw_demo/target/gw_demo-linux-aarch64 -j3 clean

make -C /gw_demo/target/gw_demo-linux-aarch64 -j3 install

# install path is ./install/gw_demo/
# copy target to orin device
cd target/gw_demo-linux-aarch64/install/gw_demo/lib/
ldd ./libcgf_custom_nodes.so
ldd ./libcgf_custom_nodes.so | grep found
```

## 开发

todo: 优化开发体验：install vscode server in the docker container

## 调试

基于vscode工具链的调试

## 架构

参考了这个架构 `https://github.com/ZhenshengLee/zsESamples`

gaworks, 开发代号gw, GW
