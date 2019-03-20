---
layout: post
title:  "bazel编译tensorflow-c++"
date:   2018-09-19 23:14:50
categories: bazel c++ tensorflow
tags: bazel tensorflow
excerpt: bazel共同编译tensorflow和opencv脚本
mathjax: true
---

由于tensorflow工程庞大，c++库依赖比较复杂，直接用gcc或者cmake相对麻烦，源仓库使用编译器`bazel`进行编译。意味着如果要同时使用tf和opencv的c++ interface，opencv的库也需要通过bazel编译。

而关于bazel的教程比较少。

这里总结一下如何使用bazel编译opencv-tensorflow的c++脚本。

----------

## 编译

### 1. 在tensorflow的根目录(`WORKSPACE`所在目录)下创建文件 `opencv.BUILD`

### 2. 输入
> cc_library(
	name="opencv",
	srcs=glob(["lib/*.so*"]),
	hdrs=glob(["include/**/*.hpp"]),
	includes=["include"],
	visibility=["//visibility:public"],
	linkstatic=1,
)

### 3. 打开WORKSPACE文件,最后添加
> new_local_repository(
	name = "opencv",
	path = "/usr/local",
	build_file = "opencv.BUILD",
)

### 4. 确保有文件/etc/ld.so.conf.d/opencv.conf 打开确保有下句:
> /usr/local/lib

### 5. 再运行一次
> sudo ldconfig -v


----------

## demo测试

### 1. 在label_image输入以下
> include "opencv/core.hpp"
> using namespace cv;
> Mat test;

### 2. terminal cd到tensorflow根目录,执行
> bazel build tensorflow/examples/label_image/...

### 3。 如果成功通过编译,则成功


