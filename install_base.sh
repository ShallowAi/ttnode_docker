#!/bin/sh
#
# 甜糖一键部署脚本
#
# Copyright (C) 2019-2021 @ShallowAi
#
# Blog: swai.top
#

check_arch(){
	arch=`uname -m`
	bit=`getconf LONG_BIT`
	case $arch in
	arm*)
		install_packages $bit
		;;
	aarch64)
		install_packages $bit
		;;
	*)
	    echo "[ERROR] 不支持的系统类型 $arch ($bit bit), 程序仍然会尝试安装"
		install_packages $bit
		;;
	esac
}

install_packages(){
    os_type=`cat /etc/os-release`
	mkdir /usr/node
	debian_modify
	echo "[INFO] 开始获取甜糖核心程序."
	if [ $1 = 32 ]
	then
		wget --no-check-certificate -O /usr/node/ttnode https://cdn.jsdelivr.net/gh/ShallowAi/ttnode@main/bin/ttnode_32
	else
		wget --no-check-certificate -O /usr/node/ttnode https://cdn.jsdelivr.net/gh/ShallowAi/ttnode@main/bin/ttnode
	fi
	echo "[INFO] 开始获取甜糖自动重启脚本"
	wget --no-check-certificate -O /usr/node/crash_monitor.sh https://cdn.jsdelivr.net/gh/ShallowAi/ttnode@main/bin/crash_monitor.sh
	chmod a+x /usr/node/*
	echo "[INFO] 创建甜糖日志文件."
	touch /usr/node/log.log
	echo "[INFO] 获取基础软件包, 并更新软件源."
	case $os_type in
	*Debian*)
		apt -y install qrencode
		;;
	*Ubuntu*)
		apt -y install qrencode
		;;
	*CentOS*)
		yum update
		yum -y install qrencode
		;;
	*)
		echo "[ERROR] 似乎不支持这个系统, 也有可能是尚未适配."
		echo "[WARN] 未适配的系统在结束时可能不会显示二维码. 会在后续修复."
		read -n1 -p "[WARN] 继续吗? 按任意键继续, 按 Ctrl+C 退出."
		;;
	esac
}

debian_modify(){
	cp /etc/apt/sources.list /etc/apt/sources.list.bak
	echo "[INFO] 已完成软件源备份."
	sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
	sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
	apt update
	apt install -y --no-install-recommends procps iputils-ping wget 
}

fstab_mount(){
	mkdir /mnts
	echo "[INFO] 开始创建并检测分区."
}

crontab_add(){
	crontab -l | { cat; echo "* * * * * /usr/node/crash_monitor.sh"; } | crontab
}

run_ttnode(){
	echo "[INFO] 开始运行甜糖星愿服务."
	/usr/node/ttnode -p /mnts | grep uid | sed -e 's/^.*uid = //g' -e 's/.\s//g' | tr -d '\n' | qrencode -o - -t UTF8
	echo "恭喜! 若无报错, 甜糖星愿服务即已运行, 扫描上述二维码即可添加设备!"
}

dns_change(){
	echo "nameserver 119.29.29.29" > /etc/resolv.conf
}

printf "%-50s\n" "-" | sed 's/\s/-/g'
echo
echo "Author: ShallowAi"
echo "Blog: swai.top"
echo "Email: Shallowlovest@qq.com"
echo "甜糖邀请码: 451003"
echo
printf "%-50s\n" "-" | sed 's/\s/-/g'
echo "欢迎使用甜糖一键部署脚本, 正在检测系统架构并准备相关文件..."
dns_change
check_arch
fstab_mount
crontab_add
run_ttnode
echo
echo "已完成安装! 感谢您的使用, 支持我 Email: Shallowlovest@qq.com 甜糖邀请码: 451003"