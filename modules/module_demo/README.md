# module_demo

## 构建架构

```sh
date && tree -L 3
Tue Apr  4 02:59:59 PM CST 2023
.
├── include # 公共头文件，和lib一起导出，安装到bin目录下，拷贝到extern目录中供其他模块使用
│   └── demo
│       └── demo.h
├── lib # 库模块, 私有的头文件也放在此文件夹，不导出
│   └── demo
│       └── demo.cpp
├── src # 使用库的主程序，作为示例
│   └── main.cpp
└── test # 单元测试
    └── demo
        └── demo_test.cpp
```
