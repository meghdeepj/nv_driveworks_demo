
# cmake基础知识

```cmake
#定义一个动态库archive 输出目标，文件有三个源文件
add_library(archive SHARED archive.cpp zip.cpp lzma.cpp)

#定义一个静态库archive 输出目标，也可以不指定STATIC 因为add_library默认输出目标是#静态库
add_library(archive STATIC archive.cpp zip.cpp lzma.cpp)

#从给出的源文件直接生成object文件，比如linux下C语言的.o文件
add_library(archive OBJECT archive.cpp zip.cpp lzma.cpp)
```

## 指定编译参数和链接参数

为add_executable() 或者add_library() 中定义的输出目标指定编译选项可以通过下面3个命令函数

```cmake
# 头文件
target_include_directories(<target> [SYSTEM] [BEFORE]<INTERFACE|PUBLIC|PRIVATE> [items1...] [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])
Include的头文件的查找目录，也就是Gcc的[-Idir...]选项

# 宏定义
target_compile_definitions(<target> <INTERFACE|PUBLIC|PRIVATE> [items1...][<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])
通过命令行定义的宏变量，也就是gcc的[-Dmacro[=defn]...]选项

# 编译选项
target_compile_options(<target> [BEFORE] <INTERFACE|PUBLIC|PRIVATE> [items1...] [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...]
gcc其他的一些编译选项指定，比如-fPIC

# gcc头文件查找目录，相当于-I选项，e.g -I/foo/bar
#CMAKE_SOURCE_DIR是cmake内置变量表示当前项目根目录
target_include_directories(test_elf
    PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/common
    ${CMAKE_SOURCE_DIR}/syscalls
)

# 编译的宏定义，e.g 相当于-D选项 e.g -Dmacro=defn
set(MONITOR_OMIT_BSS_INIT      "0")
set(MONITOR_OMIT_DATA_INIT     "0")
set(MONITOR_OMIT_T_CHECKS      "0")
target_compile_definitions(test_elf
    PRIVATE
    MONITOR_OMIT_BSS_INIT=${MONITOR_OMIT_BSS_INIT}
    MONITOR_OMIT_DATA_INIT=${MONITOR_OMIT_DATA_INIT}
    MONITOR_TRAP_NT_IRQS=${MONITOR_TRAP_NT_IRQS}
)

# 其他编译选项定义，e.g -fPIC
target_compile_options(test_elf
    PRIVATE
    -std=c99
    -Wall
    -Wextra
    -Werror
)
```

## 链接选项

```cmake
target_link_libraries(<target> <PRIVATE|PUBLIC|INTERFACE> <item>...                    [<PRIVATE|PUBLIC|INTERFACE> <item>...]...)
item可以是链接到该目标的库的名字（去掉前缀lib和扩展名后缀之后的库名字），也就是gcc链接器的-llibrary选项Item也可以是链接选项以-开始的item会被认为是链接选项（除了 -l和-framework）Item也可以是要链接到该目标的库文件的完整路径（针对非标准路径的库时可以这样指定，当然也可以用link_directories命令来为链接器增加搜索库的搜索路径）

# 链接选项设置
target_link_libraries(test_elf
    PRIVATE
    -msoft-float
    -static
    -nostdlib
)

#设置链接的标准路径的库
target_link_libraries(test_elf PRIVATE gcc)

#设置链接的本project自己输出的目标库libkernel.a
target_link_libraries(test_elf PRIVATE kernel)

#设置链接非标准路径中别人编译好的库
target_link_libraries(test_elf
PRIVATE
$ENV{HOME}/lib/libtest.a
)

```

备注：也可以用其他方式来设置编译链接的一些参数，比如直接设置cmake内置变量或者其他命令，我这里选择这些基于目标的命令来操作主要是因为，基于目标来管理更容易维护和管理，不会污染到其他的作用域。

PRIVATE 只给自己用，不给依赖者用
PUBLIC 自己和依赖者都可以用
INTERFACE 自己不用，给依赖着用

```cmake
add_library(archive archive.cpp)
target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

add_library(serialization serialization.cpp)
target_compile_definitions(serialization INTERFACE USING_SERIALIZATION_LIB)

add_library(archiveExtras extras.cpp)
target_link_libraries(archiveExtras PUBLIC archive)
target_link_libraries(archiveExtras PRIVATE serialization)
# archiveExtras is compiled with -DUSING_ARCHIVE_LIB
# and -DUSING_SERIALIZATION_LIB

add_executable(consumer consumer.cpp)
# consumer is compiled with -DUSING_ARCHIVE_LIB
target_link_libraries(consumer archiveExtras)
```

## 对输出目标的其他处理

```
比较常见的比如在linux下生成的elf输出目标，需要进一步进行处理从elf文件中抽出bin文件，可以使用add_custom_command命令进行处理，add_custom_command命令支持对目标编译链接之前进行处理，或者编译链接完之后进行处理
支持该处理方式的add_custom_command命令标签格式如下：

add_custom_command(TARGET <target> PRE_BUILD | PRE_LINK | POST_BUILD COMMAND command1 [ARGS] [args1...]  [COMMAND command2 [ARGS] [args2...] ...]  [BYPRODUCTS [files...]]  [WORKING_DIRECTORY dir]  [COMMENT comment]  [VERBATIM] [USES_TERMINAL])
Target是库或者可执行文件输出目标PRE_BUILD只有Visual Studio 8或者之后的版本才支持，其他情况等同于PRE_LINK  PRE_LINK在编译之后，链接之前运行， POST_BUILD，该目标的所有构建规则都执行完之后才运行  COMMAND ，指定要执行的命令行命令和参数



#在test_elf链接之前，先拷贝一些test_elf需要用到的文件到编译目录，在进行编译
add_custom_command(TARGET test_elf PRE_LINK
COMMAND
cp ${CMAKE_BINARY_DIR}/cfg/start.o ${CMAKE_BINARY_DIR}/. &&
cp ${CMAKE_SOURCE_DIR}/target/imx6_gcc/imx6.ld ${CMAKE_BINARY_DIR}/.
)

#把编译输出的test_elf进行进一步处理，生成最终的bin文件
add_custom_command(TARGET test_elf POST_BUILD
    COMMAND ${CUSTOM_CMD_OBJCOPY} -O binary -S test_elf test_elf.bin
)
```

## 自动生成源码规则制定

```
如果项目中用到了一些第三方的工具来自动生成一些源码，要怎么制定规则让cmake在编译源码之前先去调用第三方工具先去生成需要编译的源码，主要用到add_custom_target，add_custom_command，dependencies这几个命令

#先为这个第三方工具设置一个自定义目标，这个目标并没有实际输出文件，
#只是一个目标的名字比如这边的autoconfig
add_custom_target(autoconfig ALL)
#利用这个目标去运行这个第三方工具，这边是cfg，后面是这个工具需要的参数
add_custom_command(TARGET autoconfig PRE_BUILD
COMMAND
cfg --pass ${pass} ${CFG_ELF_INCLUDE} ${rom_image} ${symbol_table} ${T_file} ${CFG_TABLES}
)

#autoconfig和test_elf这两目标，没有直接的关系（像前面介绍的可执行程序，可能依赖其#他库输出目标，这里没有这样的关系），需要指定目标输出顺序，先对autoconfig进行输
#出（自动生成源码），在进行test_elf输出（编译和链接）
add_dependencies(test_elf autoconfig)

#把自动生成的源文件cfg_out.c加到test_elf目标去编译
target_sources(test_elf  PRIVATE cfg_out.c)
#指明cfg_out.c是自动生成的文件，否则会认为找不到文件而出错
set_source_files_properties(cfg_out.c PROPERTIES GENERATED 1)


add_custom_target(Name [ALL] [command1 [args1...]] [COMMAND command2[args2...] ...] [DEPENDS depend depend depend ... ] [BYPRODUCTS [files...]] [WORKING_DIRECTORY dir] [COMMENT comment] [VERBATIM] [USES_TERMINAL] [COMMAND_EXPAND_LISTS] [SOURCES src1 [src2...]])[items2...] ...])
增加一个名字为Name的目标，该目标没有输出，所以它总是被构建。ALL选项表明该目标被添加到默认的构建目标，所以它每次都会运行


add_dependencies(<target> [<target-dependency>]...)
在目标target在构建之前，后面的其他target-dependency依赖目标必须先被构建完成Target或者target-dependency目标是由add_executable(),add_library(),  add_custom_target()命令输出的目标


set_source_files_properties([file1 [file2 [...]]] PROPERTIES prop1 value1 [prop2 value2 [...]])
通过键/值对（ key/value）来设置源文件的一些属性
```
