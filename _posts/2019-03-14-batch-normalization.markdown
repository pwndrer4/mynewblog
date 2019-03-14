---
layout: post
title:  "笔记: 2018 NIPS How Does BN Help Optimization"
date:   2019-03-13 23:14:50
categories: Optimization
tags: Optimization DL
excerpt: 关于BN的笔记"How Does BN help Optimizaiton?"
mathjax: true
---

## 总结 ##
---
首先，关于BN为什么work，最广为流传的是：

* BN控制了输入层的分布(均值、方差)变化，成功地减少了*internal covariate shift **(ICS)***
	
本文主要通过实验，证实了 **输入层的分布稳定性对BN毫无帮助**，真正产生效果的原因是：

* 优化平面变得更加光滑
* 光滑平面诱导了更稳定的梯度下降过程，有利于更快地训练


## 前期实验 ##
---
用标准的`VGG`分别加BN和不加BN，在 `CIFAR-10`进行了实验，记录了训练准确率和测试准确率的变化曲线。

注意:往往BN总是在非线性层之前进行的，比如Relu。

![image](../postimg/2019-03-14vgg-test.png) 

## ICS实验部分 ##

<<<<<<< HEAD
![ICS](../postimg/2019-03-14-ICS-test.png)
=======
![ICS](../postimg/2019-03-14-ICS-test.png)
>>>>>>> a68454ab3cae64bc19f0d7fd82001eda88f2bc59
