---
layout: post
title:  "linux与windows局域网互访"
date:   2017-07-20 13:00:00
categories: windows和linux系统之间的系统实时互访
tags: Linux
excerpt: 主要记录linux如何通过局域网访问windows共享文件夹
mathjax: true
---

## 场景

做无人机地面站时，地面站需要检测数据做实时飞行跟踪和轨迹预测。

但是比赛场地设备太多，信号嘈杂，m100通过蓝牙传向地面站的数据经常丢失，得到的数据实在不能用。

![实时访问数据后地面站做的预测](https://raw.githubusercontent.com/wonderseen/wonderseen.github.io/master/postimg/2017-07-20-flightdata.png)

所以，后来直接把m100的飞行数据记录在机载电脑里；地面站使用局域网访问机载电脑，得到的数据才相对稳定可以进行飞行预测。

![实时访问数据后地面站做的预测](https://raw.githubusercontent.com/wonderseen/wonderseen.github.io/master/postimg/2017-07-20-prediction.jpg)


一般的，windows和linux系统之间的系统网络互访方式如下：

- `Windows系统之间`，可以通过`共享目录`的方式，让远程系统直接访问;是Windows提供一种远程文件系统机制，NAS协议的一种——`CIFS协议`
- `Linux系统`另外一种NAS协议——`NFS协议`来实现远程访问
- 这两种NAS协议**不能互通**。
- 但是，在Linux系统实现`CIFS协议`的服务端和客户端。这样，Windows与Linux共享都可以借助这些实现。

下面重点说明Linux系统如何通过网络访问Windows系统的共享文档：


----------

## 一、共享windows文档给linux或者windows用户（通过网络）

1. 首先，确保两台计算机连接到同一个局域网

最好是设置为分配`静态ip地址`，因为我们是通过ip互访文件的。动态ip每次都得重新查询，相对麻烦。

2. 其次，开放windows的GUEST密码，Linux是作为GUEST访问windows的共享文档

具体操作为：

在windows系统中设置 `《计算机管理》` 的`用户`和`组`的`GUEST密码`。右键设置，设置的时候帐号密码全都**不要输入**，直接确定

3. 在Linux中，以下两条命令可以用来访问windows共享：

### 方法1：`smbclient访问`

>	smbclient -U  用户名  //IP地址/共享名

	例如： smbclient  -U   225-PC  //192.168.1.120/数据记录
	如果成功，会出现smb>提示符，好像是输入一个？，就可以看到能够使用的命令了。

### 方法2：`mount挂载`

>	mount  -o  username=225-PC   //192.168.1.120/数据记录    /home/wonderseen/桌面/windows

	例如： mount   -o   username=share  //192.168.4.165/fg    /test
	密码直接按回车，如果成功，直接访问linux系统中的/test目录，就可以看到WINDOWS的共享内容


方法2每次Linux主机重启后，需要 `重新挂载`。

如果想要开机自动挂起，需要在 `/etc/fstab` 最后加入以下内容，参数含义同上
> //WindowsHost/sharefolder /home/xxx/shared cifs > > > 
> defaults,auto,username="xxxx",password="***",gid="1000",uid="1000"

### 方法2(续): `卸载mount挂载`
> sudo umount windows

## 二. mount挂载过程可能会遇到的问题
`windows共享文档无法写入` 可能是由于两方面造成的：

- 共享文件所有者：

	这里就是windows，共享文档的共享权限和NTFS权限是与的关系。
	**都要允许才可以**。
	分别在右键属性的「安全」和「共享」中设置GUEST或者everyone属性。



- 共享文件访问者：

	这里就是Linux，要采取以下措施：	
	「关于linux在windows共享文档已经赋予写入权限后，linux对共享文件依然处于只读权限的原因：如果用mount挂载该共享文档，是不够由写入权限的，只能以root形式访问，必须加入两个参数gid和uid才能写入。gid和uid在控制台输入id即可查询。」
	
	格式如：

	> mount -t cifs -o username=225-PC,password=admin, gid=1000, uid=1000, dir_mode=0777, file_mode=0777 //192.168.1.3/数据记录 /home/wonderseen/桌面/windows



----------
## 补充: Samba软件实现共享Linux文件系统给Windows用户
1. Linux安装samba 
> terminal: sudo apt-get install samba

2. 安装完成后，修改配置文件，打开： `/etc/samba/smb.conf`，在文件末尾加上如下配置：
> [root]
>  comment = root 
>  path = /   
>  creat mask = 64 
>  writeable = yes   
>  browseable = yes 
>  valid users = root 

这个配置的意思是，创建名为 `root` 的共享，将根文件目录 `/` 共享给用户。允许登录的用户名是 `root`。