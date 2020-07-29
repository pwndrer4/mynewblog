---
layout: post
title:  "Let's Encrypt，免费好用的 HTTPS 证书"
date:   2020-7-28-13:32:50
categories: ML
tags: Margin
excerpt: Let's Encrypt，免费好用的 HTTPS 证书
mathjax: true
---
Let's Encrypt作为一个公共且免费SSL的项目逐渐被广大用户传播和使用，是由Mozilla、Cisco、Akamai、IdenTrust、EFF等组织人员发起，主要的目的也是为了推进网站从HTTP向HTTPS过度的进程，目前已经有越来越多的商家加入和赞助支持。

Let's Encrypt免费SSL证书的出现，也会对传统提供付费SSL证书服务的商家有不小的打击。到目前为止，Let's Encrypt获得IdenTrust交叉签名，这就是说可以应用且支持包括FireFox、Chrome在内的主流浏览器的兼容和支持，虽然目前是公测阶段，但是也有不少的用户在自有网站项目中正式使用起来。

虽然目前Let's Encrypt免费SSL证书默认是90天有效期，但是我们也可以到期自动续约，不影响我们的尝试和使用。

第一、安装Let's Encrypt前的准备工作

根据官方的要求，我们在VPS、服务器上部署Let's Encrypt免费SSL证书之前，需要系统支持Python2.7以上版本以及支持GIT工具。这个需要根据我们不同的系统版本进行安装和升级，因为有些服务商提供的版本兼容是完善的，尤其是debian环境兼容性比CentOS好一些。

第二、快速获取Let's Encrypt免费SSL证书

PS：在获取某个站点证书文件的时候，我们需要在安装PYTHON2.7以及GIT，更需要将域名解析到当前主机IP中。

1
2
3
git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt
./letsencrypt-auto certonly --standalone --email admin@laozuo.org -d laozuo.org -d www.laozuo.org
然后执行上面的脚本，我们需要根据自己的实际站点情况将域名更换成自己需要的。

第三、Let's Encrypt免费SSL证书获取与应用

在完成Let's Encrypt证书的生成之后，我们会在"/etc/letsencrypt/live/laozuo.org/"域名目录下有4个文件就是生成的密钥证书文件。

cert.pem  - Apache服务器端证书
chain.pem  - Apache根证书和中继证书
fullchain.pem  - Nginx所需要ssl_certificate文件
privkey.pem - 安全证书KEY文件

如果我们使用的Nginx环境，那就需要用到fullchain.pem和privkey.pem两个证书文件，在部署Nginx的时候需要用到。

1
2
ssl_certificate /etc/letsencrypt/live/laozuo.org/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/laozuo.org/privkey.pem;
比如我们在Nginx环境中，只要将对应的ssl_certificate和ssl_certificate_key路径设置成我们生成的2个文件就可以，最好不要移动和复制文件，因为续期的时候直接续期生成的目录文件就可以，不需要再手工复制。

第四、解决Let's Encrypt免费SSL证书有效期问题

我们从生成的文件中可以看到，Let's Encrypt证书是有效期90天的，需要我们自己手工更新续期才可以。

1
./letsencrypt-auto certonly --renew-by-default --email admin@laozuo.org -d laozuo.org -d www.laozuo.org
这样我们在90天内再去执行一次就可以解决续期问题，这样又可以继续使用90天。如果我们怕忘记的话也可以制作成定时执行任务，比如每个月执行一次。

第五、关于Let's Encrypt免费SSL证书总结

通过以上几个步骤的学习和应用，我们肯定学会了利用Let's Encrypt免费生成和获取SSL证书文件，随着Let's Encrypt的应用普及，SSL以后直接免费不需要购买，因为大部分主流浏览器都支持且有更多的主流商家的支持和赞助，HTTPS以后看来也是趋势。在Let's Encrypt执行过程在中我们需要解决几个问题。

A - 域名DNS和解析问题。在配置Let's Encrypt免费SSL证书的时候域名一定要解析到当前VPS服务器，而且DNS必须用到海外域名DNS，如果用国内免费DNS可能会导致获取不到错误。

B - 安装Let's Encrypt部署之前需要服务器支持PYTHON2.7以及GIT环境，要不无法部署。

C - Let's Encrypt默认是90天免费，需要手工或者自动续期才可以继续使用。

 

 

Let's Encrypt 发布的 ACME v2 现已正式支持通配符证书，接下来将为大家介绍怎样申请

一、acme.sh的方式
1.获取acme.sh

curl https://get.acme.sh | sh
如下所示安装成功



注：我在centos 7上遇到问题，安装完后执行acme.sh，提示命令没找到，如果遇到跟我一样的问题，请关掉终端然后再登陆，或者执行以下指令：

source ~/.bashrc
2.开始获取证书

acme.sh强大之处在于，可以自动配置DNS，不用去域名后台操作解析记录了，我的域名是在阿里注册的，下面给出阿里云解析的例子，其他地方注册的请参考这里自行修改：传送门

请先前往阿里云后台获取App_Key跟App_Secret 传送门，然后执行以下脚本

复制代码
# 替换成从阿里云后台获取的密钥
export Ali_Key="sdfsdfsdfljlbjkljlkjsdfoiwje"
export Ali_Secret="jlsdflanljkljlfdsaklkjflsa"
# 换成自己的域名
acme.sh --issue --dns dns_ali -d zhuziyu.cn -d *.zhuziyu.cn
复制代码
这里是通过线程休眠120秒等待DNS生效的方式，所以至少需要等待两分钟

到了这一步大功告成，撒花

生成的证书放在该目录下: ~/acme.sh/domain/

下面是一个Nginx应用该证书的例子:

复制代码
# domain自行替换成自己的域名
server {
    server_name xx.domain.com;
    listen 443 http2 ssl;
    ssl_certificate /path/.acme.sh/domain/fullchain.cer;
    ssl_certificate_key /path/.acme.sh/domain/domain.key;
    ssl_trusted_certificate  /path/.acme.sh/domain/ca.cer;

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_pass http://127.0.0.1:10086;
    }
}
复制代码
acme.sh比certbot的方式更加自动化，省去了手动去域名后台改DNS记录的步骤，而且不用依赖Python，墙裂推荐

第一次成功之后，acme.sh会记录下App_Key跟App_Secret，并且生成一个定时任务，每天凌晨0：00自动检测过期域名并且自动续期。对这种方式有顾虑的，请慎重，不过也可以自行删掉用户级的定时任务，并且清理掉~/.acme.sh文件夹就行

 

二、 docker 镜像获取
如果装有docker环境的话，也可以用docker镜像来获取证书，只需一行命令即可

复制代码
docker run --rm  -it  \
  -v "$(pwd)/out":/acme.sh  \
  -e Ali_Key="xxxxxx" \
  -e Ali_Secret="xxxx" \
  neilpang/acme.sh  --issue --dns dns_ali -d domain.cn -d *.domain.cn
复制代码
成功之后，证书会保存在当前目录下的out文件夹，也可以指定路径，修改上面第一行 "$(pwd)/out"，改为你想要保存的路径即可。

详细用法，可以参考：传送门

获取下来的证书跟方式一 获取的一模一样，其他信息请参考方式一。

三、 certbot方式获取证书[不推荐]
1.获取certbot-auto

复制代码
# 下载
wget https://dl.eff.org/certbot-auto

# 设为可执行权限
chmod a+x certbot-auto
复制代码
2.开始申请证书

复制代码
# 注xxx.com请根据自己的域名自行更改
./certbot-auto --server https://acme-v02.api.letsencrypt.org/directory -d "*.xxx.com" --manual --preferred-challenges dns-01 certonly
复制代码
执行完这一步之后，会下载一些需要的依赖，稍等片刻之后，会提示输入邮箱，随便输入都行【该邮箱用于安全提醒以及续期提醒】



注意，申请通配符证书是要经过DNS认证的，按照提示，前往域名后台添加对应的DNS TXT记录。添加之后，不要心急着按回车，先执行dig xxxx.xxx.com txt确认解析记录是否生效，生效之后再回去按回车确认



到了这一步后，大功告成！！！ 证书存放在/etc/letsencrypt/live/xxx.com/里面

要续期的话，执行certbot-auto renew就可以了



注：经评论区 ddatsh 的指点，这样的证书无法应用到主域名xxx.com上，如需把主域名也增加到证书的覆盖范围，请在开始申请证书步骤的那个指令把主域名也加上，如下： 需要注意的是，这样的话需要修改两次解析记录

./certbot-auto --server https://acme-v02.api.letsencrypt.org/directory -d "*.xxx.com" -d "xxx.com" --manual --preferred-challenges dns-01 certonly


下面是一个nginx应用该证书的一个例子

复制代码
server {
    server_name xxx.com;
    listen 443 http2 ssl;
    ssl on;
    ssl_certificate /etc/cert/xxx.cn/fullchain.pem;
    ssl_certificate_key /etc/cert/xxx.cn/privkey.pem;
    ssl_trusted_certificate  /etc/cert/xxx.cn/chain.pem;

    location / {
      proxy_pass http://127.0.0.1:6666;
    }
}
复制代码
