---
layout: post
title:  "Bazel "
date:   2017-11-15 03:00:00
categories: tensorflow通过cmake调用c++接口
tags: Linux
excerpt: 主要记录linux如何通过局域网访问windows共享文件夹
mathjax: true
---

cmake调用tf-master的c++接口坑实在是太多，各种版本不兼容，各种官方文档也写的很不规范，终于熬过来了...

有必要记录一下整体流程和中间遇到的坑怎么解决。

## 一、本文所在环境
1. ubuntu 16.04
2. bazel最新版本
3. python2.x或者3.x
4. 下载了tensorflow源
5. 下载了tensorflow-cmake-master例
6. 下载了protobuf-master源包

## 二、整体流程

1. `bazel`编译`tensorflow`源，根目录下会生成`bazel-bin/bazel-genfile/....`等重要文档
2. 按照`tensorflow-cmake-master`指示，更新c++接口适配的`eigen`和`protobuf`(PS: tf的c++接口还不完善，并没有像python接口那样方便的适配最新源码所推荐的`eigen`和`protobuf`版本)
3. 按照`tensorflow-cmake-master`抽取出c++所必须的库，统一放在同个位置，如系统环境`/usr/local`中
4. 注意仔细查看`FOUND_PROTOBUF(EIGEN | TENSORFLOW)` 的链接地址和库位置是否正确
5. 检查无误，开始更新到最新的`protobuf 3.4.0`版本，进入`protobuf-master`
6. 安装结束，编译`tensorflow-cmake-master`工程，此时已经能顺利完成编译与运行
7. 更新python的tensorflow最新版本，见下文 **三、(三)`protobuf`版本解决方案**
8. 结束


## 三、遇到的问题和解决方案

### （一） 编译出`libtensorflow_cc.so`

需要在tensorflow根目录下，先编译出`libtensorflow_cc.so`进行c++接口动态调用。

注意：

1. `libtensorflow.so`是c接口
2. `libtensorflow_all.so` 包括了各种各样的接口，在单独编译c++，如果没有导入所有接口的头文件，执行全部相应的编译格式，会出错，不要用 `libtensorflow_all.so`

### （二）`protobuf`版本问题

通过tensorflow最新的源(20171109)自动更新的 `protobuf` 版本是`3.3.0`，然而对应源提供的cmake需要`protobuf 3.4.0`版本。

所以，通过tensorflow编译完的库，不能直接使用，需要从protobuf源重新安装`3.4.0`的版本，否则会出现 `error...by a newer/older version of protobuf...`。

到这个时候，已经编译好三个模块：`EIGE`、`TENSORFLOW`、`PROTOBUF`

而这时候，用户之前通过 `pip` 装上tensorflow的modules将无法使用，主要是因为出现了 `google.protobuf` 无法使用的情况。

### （三）`protobuf`版本解决方案

需要重新安装这些模块:
		
	以python2的tf模块为例：
	> sudo pip uninstall tensorflow
	
	> sudo pip install tensorflow
	
	以python3的tf模块为例:
	> sudo apt install python3-pip
	
	> sudo pip3 uninstall tensorflow
	
	> sudo pip3 install --upgrate tensorflow

### （四）`protobuf`版本解决方案（可选）

如果出现以下错误:

> UserWarning: The installed version of numexpr 2.4.3 is not supported in pandas......

terminal安装:
>	sudo pip install -U Numexpr

### （五）编译`protobufanzhaugn`出错（可选）

编译`protobufanzhaugn` 最新版本的时候出现
> /autogen.sh: 48: autoreconf: not found

是在不同版本的 `tslib` 下执行 `autogen.sh` 产生。它们产生的原因一样，是因为没有安装 `automake` 工具。

ubuntu 16.04用下面的命令安装好就可以了。

> sudo apt-get install autoconf automake libtool
