---
layout: post
title:  "Oracle Cloud VPS CentOS 7 修改主机名,BBR 失联,root 登录等注意事项"
date:   2020-12-08-05:20:50
categories: ML
tags: Margin
excerpt: 折腾使用 Oracle Cloud 的免费 VPS 已有半年之久.由于奇葩的甲骨文云面板既无快照功能,重装又麻烦,经过不停的删机,抢机,最后也算是稳定的配置好了服务器.本文将简单总结和分享下在配置奇葩的甲骨文CentOS 7时遇到的一些问题和解决方法.
mathjax: true
---
解决方案
登录问题
虽然 Oracle 默认使用了SSK KEY的验证模式来登录 VPS ,同时关闭了root帐号登录方式.但有些场景还是需要使用账号密码来直接登录root账号.在加上网络问题导致经常遇到断开终端的情况,参考以下参数来进行配置.

切换至 root 创建密码
sudo -i
# 切换至 root 账号
passwd
# 修改密码
修改登录配置
vi /etc/ssh/sshd_config
# 编辑 sshd_config
添加或修改Port 22222以确保SSH端口安全.
查找到#PermitRootLogin yes,去掉#注释符号.
查找到#PasswordAuthentication yes,去掉#注释符号.
查找到#ClientAliveInterval 0,去掉#注释符号,0改为30.
查找到#MaxSessions 10,去掉#注释符号.

systemctl restart sshd
# 重启 sshd 生效
防火墙
由于甲骨文云有控制台可以配置安全防火墙,加上修改了SSH端口,可以禁用防火墙,使用iptables来管理.

systemctl stop firewalld
systemctl disable firewalld
修改主机名
甲骨文云的CentOS 7在使用hostnamectl set-hostname命令修改主机名时,重启服务器后依旧会恢复为 Web 端创建实例时所设置的名字.网上查找了各种方法都无效,最终找到了解决方案.
编辑修改oci-hostname.conf文件

vi /etc/oci-hostname.conf
将PRESERVE_HOSTINFO=0中的的值0修改为1

# This configuration file controls the hostname persistence behavior for Oracle Linux
# compute instance on Oracle Cloud Infrastructure (formerly Baremetal Cloud Services)
# Set PRESERVE_HOSTINFO to one of the following values
#   0 -- default behavior to update hostname, /etc/hosts and /etc/resolv.conf to 
#        reflect the hostname set during instance creation from the metadata service
#   1 -- preserve user configured hostname across reboots; update /etc/hosts and 
#           /etc/resolv.conf from the metadata service  
#   2 -- preserve user configured hostname across instance reboots; no custom  
#        changes to /etc/hosts and /etc/resolv.conf from the metadata service,
#        but dhclient will still overwrite /etc/resolv.conf
#   3 -- preserve hostname and /etc/hosts entries across instance reboots; 
#        update /etc/resolv.conf from instance metadata service
PRESERVE_HOSTINFO=0
使用hostnamectl set-hostname命令修改主机名即可.重启也不会失效.

hostnamectl set-hostname xxxxxx
BBR 注意事项
甲骨文云的CentOS 7系统也比较奇葩,使用各种BBRPlus脚本都会遇到每天一失联的情况,还必须在后台重启.只有使用原版 BBR,但是随着内核的升级,目前最新版内核会导致无法启动.经过多次尝试最终只有手动安装5.3.13版内核,并在yum的更新配置中忽略不升级内核,才能稳定运行.详细安装方法参考以下链接:

Oracle Cloud VPS CentOS 7 升级内核并开启官方原版BBR加速
卸载相关程序
rpcbind
使用netstat -ntlp命令发现rpcbind监听了111端口,如担心安全可执行以下命令卸载禁用:

systemctl stop rpcbind
systemctl stop rpcbind.socket
systemctl disable rpcbind
systemctl disable rpcbind.socket 
oracle-cloud-agent
卸载甲骨文云官方后台监控程序

systemctl stop oracle-cloud-agent
systemctl disable oracle-cloud-agent
systemctl stop oracle-cloud-agent-updater
systemctl disable oracle-cloud-agent-updater
结语
无话可说...奇葩甲骨文你行的...
