#!/bin/sh

while true
do
	d=`date '+%F %T'`;
	num=`ps fax | grep '/ttnode' | egrep -v 'grep|echo|rpm|moni|guard' | wc -l`;
	echo $num;
	if [ $num -lt 1 ];then
		echo "[$d] ttnode 服务未启动...启动中";
		/usr/node/ttnode -p /mnts;
	fi
	sleep 1m
done