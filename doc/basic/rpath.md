# rpath

最近研究CMake,发现CMake对于RPATH的管理也非常人性化。官方说法是当动态库的编译也和执行档在同级目录下的时候，CMake会自动给执行档加入适当的RPATH.具体可以通过readelf -d executable来查看相关的RPATH路径。所以有的时候用QMake编译之后还得手动加一把LD_LIBRARY_PATH，而用CMake编译之后，直接执行执行档就可以了。

相关RPATH的说明，同学可以自行google学习，简单来说，RPATH就是在LD_LIBRARY_PATH之前，会优先让执行档去寻找相应的动态库，当然了有的操作系统支持RUNPATH的话，会在RUNPATH设置情况下自动忽略RPATH,而会先去寻找LD_LIBRARY_PATH之后再去着RUNPATH,(注意这里面的顺序关系，RUNPATH在LD_LIBRARY_PATH之后,而其会让RPATH忽略，但RPATH却在LD_LIBRARY_PATH之前)，相关顺序这里简单交代下： RPATH   --   LD_LIBRARY_PATH -- RUNPATH(出现会屏蔽RPATH) -- /etc/ld.so.conf -- builtin dircetories(/lib, /usr/lib)。

在这里我主要介绍下CMake对于RPATH的相关管控。默认行为已经在第一段说明了，那就是CMake在默认情况下是会给你的exe加入相关RPATH的，这个时候可能会有不想要相关RPATH的需求，仔细查阅寻找之后发现，CMake里面维护了3个比较重要的RPATH变量，即CMAKE_SKIP_RPATH,CMAKE_SKIP_BUILD_RPATH,CMKAE_INSTALL_RPATH.

对于第一个变量CMAKE_SKIP_RPATH,简单的来说，就是强制CMake不在构建期间和安装install期间给你加上它所认为的RPATH.

即

```sh
cmake .. -DCMAKE_SKIP_RPATH=TRUE
```

第二个和第三个变量也比较简单，就是分别在构建期间和安装期间不允许CMake给你加入相关RPATH

```sh
cmake .. -DCMAKE_SKIP_BUILD_RPATH=TRUE
cmake .. -DCMAKE_SKIP_INSTALL_RPATH=TRUE
```

当然了，如果你之后想要追加RPATH,只需要对这三个变量设置成FALSE就可以了。

之前写过一篇<探讨CMake中关于RPATH的使用>，只要针对的方面是在编译生成之后（不包括安装的make install）如何去除RPATH的问题。今天给大家主要介绍一下如何让CMake在用install命令之后如何保持RPATH。

我先来简单介绍下CMake关于RPATH的机制，在之前文章中介绍过，如果你没有显示指定CMAKE_SKIP_RPATH,CMAKE_BUILD_WITH_INSTALL_RPATH,CMAKE_SKIP_BUILD_RAPTH,CMAKE_SKIP_INSTALL_RPATH的话，默认CMake在帮你编译之后，如果你使用了相关动态库，它会在相应的executable中增加你相关生成动态库的路径，这样当你每次去执行的时候你不需要每次都LD_LIBRARY_PATH就可以正常运行。这个时候你可以用一下

```sh
readelf -d myexe
```

你可以看到，当前myexe中的RPATH字段有一个Library rpath,其中指定了你生成相应动态库target的目标路径。当然你也可以通过

```sh
ldd -r myexe
```

来查看当前executable已经寻找到了哪些动态库。当然你可以因此做一个小实验，就是移动相关shared_lib库的路径，这个时候你再去运行myexe,你就会发现它已经找不到相关的动态库了，因为目前的RPATH都是写的绝对路径，所以如果你只是移动exe而不是lib,则没有任何问题。

再来说一下make install下CMake是如何处理RPATH的。CMake为了方便用户的安装，默认在make install之后会自动remove删除掉相关的RPATH,这个时候你再去查看exe的RPATH，已经发现没有这个字段了。因此，当每次make install之后，我们进入到安装路径下执行相关exe的时候，就会发现此时的exe已经找不到相关的库路径了，因为它的RPATH已经被CMake给去除了。

那么，如何让CMake能够在install的过程中写入相关RPATH并且该RPATH不能使当初build的时候的RPATH呢？答案就是CMAKE_INSTALL_RPATH这个全局变量和INSTALL_RPATH这个target属性。下面举一下简单的例子。

大家都知道，CMake在安装的过程会有一个和configure一样的安装路径，CMAKE_INSTALL_PREFIX（configure下是--prefix,当然也可以用shell下的全局变量DESTDIR）,这个时候它会把你的安装文件安装到你prefix下的相对路径下，因此当我们希望在make install的时候，比如当前的share_lib在lib目录下，我们希望安装之后的RPATH可以自动找到它，我们就可以这么写

`set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)`

需要注意的是，这个变量是全局变量，意味着你所有的target的RPATH都会在install的时候被写成这个(包括myexe和不需要RPATH的share_lib)，有没有简单的针对某个target呢，聪明的你应该已经想到了

`set_target_properties(myexe PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")`

这样就可以保证只针对当前的target进行make install的时候RPATH的写入了。

以上就是对前面一篇CMake与RPATH的补充，希望你会喜欢 : )
