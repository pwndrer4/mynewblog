---
layout: post
title:  "从网络角度综合看Cloudflare自选节点"
date:   2021-5-28-8:20:50
categories: ML
tags: Margin
excerpt: Cloudflare(下文简称cf)自选节点技术相信大家都了解吧！我们今天就一起从网络角度看，因为只有这样才能更好的比较节点好坏
mathjax: true
---
Cloudflare(下文简称cf)自选节点技术相信大家都了解吧！我们今天就一起从网络角度看，因为只有这样才能更好的比较节点好坏

IP Tansit：互联网运营商骨干网之间的互联主要有两种，一种是对等或不对等的网间互联Peer，这种是存在双方利益的、用于双方互通的链路；另一种是Transit，由弱势方向强势方购买，让强势方通过自身网络为弱势方提供到第三方网络的链路。

运营商评级：国际上对于运营商的评级是根据覆盖来的，具体而言就是看是否购买了Transit。顶级运营商Tier1自身连通性很好，不需要Transit来打通到其他运营商的链路。区域顶级运营商就是Tier2，如电信联通等就是能够以少量的Transit完成互联。至于Tier3，就像移动AS9808这种，完全依赖Transit完成全球互联。当然运营商评级并不反映运营商的网络质量和规模，如印度的TATA和美国Cogent等，网络稳定性和传输容量并不是顶级的。而很多Tier2比如电信，国内随便一个省级汇聚的容量都可以达到数T级别，相比之下北美一个州的所有流量汇聚才几百G级别。首先，cf使用了anycast技术，但是我们通过
自选节点，还是能改变些许的路由的，能优化些
可以通过ipip的路由追踪来查看路由走法
cloudflare的路由经常调整，下面给的图片中ip的路由走法失效了大致不会更新，有空了教大家扫描吧
从电信说起
## 1.电信
电信由于是区域顶级运营商，比较强势，全球范围内只向level3购买了少量的Transit
选择1:北美163
洛杉矶/圣何塞163直连
点评：这是目前电信最好的选择了吧！洛杉矶和圣何塞整体差不多吧，洛杉矶率好于圣何塞
[![](https://img11.360buyimg.com/ddimg/jfs/t1/188992/38/1327/386265/60913ad2E42009dc4/7dfb7e4a170d3164.png)](https://img11.360buyimg.com/ddimg/jfs/t1/188992/38/1327/386265/60913ad2E42009dc4/7dfb7e4a170d3164.png)

[![](https://img14.360buyimg.com/ddimg/jfs/t1/191811/16/1324/393445/60913ad2Ebf408d4d/b5c7ba5fca9bb9a4.png)](https://img14.360buyimg.com/ddimg/jfs/t1/191811/16/1324/393445/60913ad2Ebf408d4d/b5c7ba5fca9bb9a4.png)

选择2:欧洲level3
[![](https://img14.360buyimg.com/ddimg/jfs/t1/193195/31/1300/403934/60922600E0bb42603/21508f8986cdc9c7.png)](https://img14.360buyimg.com/ddimg/jfs/t1/193195/31/1300/403934/60922600E0bb42603/21508f8986cdc9c7.png)
这个嘛，不是很推荐，尤其是电信目前北美C-I扩容背景下，由于欧洲廉价带宽更多，相对会更拥堵

## 2.联通
选择1:洛杉矶gtt
较为推荐，联通接入洛杉矶gtt不多，cf接入也不是很多，但只在高峰期略有卡顿
[![](https://img14.360buyimg.com/ddimg/jfs/t1/183629/31/4440/446091/60a0fab2E6bd40fad/9dc93923531281f8.png)](https://img14.360buyimg.com/ddimg/jfs/t1/183629/31/4440/446091/60a0fab2E6bd40fad/9dc93923531281f8.png)
这里必须补充一下，大家都觉得cf听良心大气，这并没有错，但是作为大流量的cdn服务商，流量支出是大头，cf也想省钱啊而不是给你优化
比如，联通以前可以走日本ntt的，但是日本的带宽比美国贵啊，cf后来就把联通的日本ntt剥掉了
再比如，香港地区的网络，hkix方面cf只买了10G的带宽（隔壁Akamai有1.2T），后来趋于饱和了，cf就把免费版的路由拨到了日本、新加坡等地，这些地方虽然带宽也贵，但比香港要便宜多了
这点上来讲cf还是很抠门的
选择2:圣何塞gtt
联通走gtt到CF慢，说实在还真不是联通的问题，到圣何塞gtt走的是上海-圣何塞的链路，主要是圣何塞gtt接入CF的容量不够，只是晚高峰有丢包现象。
[![](https://img12.360buyimg.com/ddimg/jfs/t1/176139/19/9867/473531/60a0fb75E1e7cf863/82e67e2c3a3a5512.jpg)](https://img12.360buyimg.com/ddimg/jfs/t1/176139/19/9867/473531/60a0fb75E1e7cf863/82e67e2c3a3a5512.jpg)
选择3:圣何塞cogentco
这个最近还行，比想象中的好，只是高峰期圣何塞cogentco接联通略有不足
![E02A4179-FD1D-4816-8A45-F5A39EAD5313.png](https://img11.360buyimg.com/ddimg/jfs/t1/173791/28/11851/412751/60b0faeaE8eab40fc/caae07823b6aa051.png)
选择4:北美其他gtt
测试不足，单看追踪还可以
一般用洛杉矶gtt就行
![D69B8813-74E1-4DBC-BCAC-45AAEC5B3BBC.png](https://img11.360buyimg.com/ddimg/jfs/t1/187682/21/5396/415381/60b0fb59E882f90f5/47cb908eb154a978.png)
选择5:洛杉矶cogentco
也还行，也只在晚高峰有卡顿
![1887CBAF-A14E-446A-8D44-E0AF163FB8AF.png](https://img12.360buyimg.com/ddimg/jfs/t1/182831/32/6373/388262/60b17db7Efc5e0da0/aa0007854756e111.png)
选择6:荷兰gtt
走圣何塞gtt做转发
这个延迟比较高，但圣何塞gtt到联通及荷兰gtt到cf都不堵
下载速度还可以
线路调整过后联通欧洲gtt直连的节点没有了
![E01C7366-ED29-4B0F-8C09-5811C1120F36.png](https://img14.360buyimg.com/ddimg/jfs/t1/128203/13/19220/433696/60b17e27Eb8c5ac96/d73cc05753c99ab4.png)
选择7:洛杉矶Verizon

这个段比较特殊，Verizon的网一向是给联通AS9929使用的，给AS4837使用的情况比较少；印象中联通走Verizon的速度是很稳定的，速度延迟都不错。
![68F3218D-5FB7-44A7-A065-48194149F697.png](https://img14.360buyimg.com/ddimg/jfs/t1/172297/1/11961/401096/60b17f17E2ac51ecc/d6a2b09fc3399513.png)
## 3.移动
选择1:香港cmi直连
这个还可以，但整体cf接香港cmi容量不足的
一般不推荐香港以外的
![8D5A85F3-F32A-4804-B3E0-A1D7342F0469.png](https://img10.360buyimg.com/ddimg/jfs/t1/172582/37/12073/444449/60b18a55Efa292ead/3cc641413a2c1d01.png)
选择2:洛杉矶cmi直连
移动到北美容量不足，卡顿...不太推荐
![C76F703D-7CC9-43B1-9D8F-D0447DF91DF1.png](https://img12.360buyimg.com/ddimg/jfs/t1/182613/40/6373/428104/60b18af2E1347520f/033e60467f8fda48.png)
选择3:圣何塞cmi直连
问题和2一样，表现稍微好一点
源站北美的可以试试
![17CAA599-FB30-4F68-99A3-4FF9054787EC.png](https://img11.360buyimg.com/ddimg/jfs/t1/181421/21/6422/440152/60b18b31E0bc9d0b2/3d2b817ac61eba8f.png)
选择4:德国cmi直连
也还可以，移动到欧洲的pop理论值小于北美的
源站欧洲的可以测下
![EDC35D0D-3C50-4CAB-8B93-D1435568A6E3.png](https://img11.360buyimg.com/ddimg/jfs/t1/188803/30/5509/422370/60b18b8bE44fa7b57/0f7fd32309858daf.png)
选择5:新加坡ntt
回程会绕美，效果不好
选择6:西雅图cmi直连
移动自己骨干问题，卡顿的
![A4BB146E-4B0F-4236-849F-7191498B8DF2.png](https://img10.360buyimg.com/ddimg/jfs/t1/172969/24/11850/411161/60b18c21E4d3e8b32/a05f244693cdca8f.png)
## 扫描
网上找来的win批处理
需要curl
https://static.lty.fun/%E5%85%B6%E4%BB%96%E8%B5%84%E6%BA%90/CF/win_bat.zip
好的，大概就是这样了，终于写完了
