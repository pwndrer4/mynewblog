---
layout: post
title:  "教程 使用Cloudflare Workers加速任意网站"
date:   2020-7-30-12:20:50
categories: ML
tags: Margin
excerpt: Cloudflare Workers 的名称来自 Web Workers，更具体地说是 Service Workers，一个用于在 web 浏览器后台运行并拦截 HTTP 请求的脚本的 W3C 标准 API。Cloudflare Workers 是针对相同的标准 API 编写的，但是是在 Cloudflare 的服务器上运行，而不是在浏览器中运行。
mathjax: true
---
Cloudflare Workers 的名称来自 Web Workers，更具体地说是 Service Workers，一个用于在 web 浏览器后台运行并拦截 HTTP 请求的脚本的 W3C 标准 API。Cloudflare Workers 是针对相同的标准 API 编写的，但是是在 Cloudflare 的服务器上运行，而不是在浏览器中运行。



使用方法：

修改 index.js 开头的常量, 然后将它部署到 cloudflare workers 上即可。

优点：

用 cf workers 加速任意网站, 无需购买或配置服务器；

可以用来做静态资源 CDN..不用把域名接入 cf；

可以根据 user-agent 屏蔽部分地区或 ip；

可以绑定自定义域名；

缺点：

workers 一天免费 10 万次请求。

开源地址：https://github.com/Siujoeng-Lau/WorkersProxy

index.js 配置方法：

网址带上 http 或 https

 
// 所有绑定到这个 worker 的域名
const domain_list = ['xxxx', 'xxx.xxxxx.workers.dev']
 
// 要加速的网站.
const upstream =
 
// 要给手机用户加速的网站. (可以填成和上面一样的)
const upstream_mobile =
 
// 要屏蔽的地区
const blocked_region = ['CN', 'KP', 'SY', 'PK', 'CU']
 
// 要屏蔽的 ip
const blocked_ip_address = ['0.0.0.0', '10.0.0.0']
