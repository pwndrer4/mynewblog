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

![image](https://github.com/wonderseen/wonderseen.github.io/blob/master/postimg/2019-03-14vgg-test.png) 

## ICS前期实验 ##

![ICS](https://github.com/wonderseen/wonderseen.github.io/blob/master/postimg/2019-03-14-ICS-test.png?raw=true)

在随机训练后，可视化随机的batch在输入层的分布。发现：在输入层的分布稳定上，差异并不大。

（意思可能是：虽然，主体的偏移和高密度区域一致，但是在低概率上分布还是有偏差的）。

由此提出两个问题：

1. BN的有效性是否真的和ICS相关？
2. BN所造成的层输入分布稳定性是否确实减少的ICS?

## 探究BN是否有效控制ICS的实验 ##

对每个样本在BN层后，都加入`服从独立同分布的非0均值和非单位方差的随机噪声`，并且每个step，都使用不同分布的噪声。加入噪声会产生ICS位移，这么做是为了使得每次激活都发生不同程度的偏差。

![](https://github.com/wonderseen/wonderseen.github.io/blob/master/postimg/2019-03-14-ICS-comparison.png)

上图记录了训练的每个step中，网络的指定层的均值和方差的单步变化值（时序上的差分）和与网络初始状态的差异值。

根据上图和下图右侧可以体现：注入噪声的网络，在后层的参数分布更不稳定。

![](https://github.com/wonderseen/wonderseen.github.io/blob/master/postimg/2019-03-14-BN-noise-experiments.png)

然而，根据最终的训练准确度可以发现，带BN的网络中ICS的增加，并没有对模型的性能产生明显的影响，并且均高于不加BN层且不注入噪声的网络。

除此之外，作者在不带BN情况下做同等的噪声注入，发现训练无法完成收敛。

