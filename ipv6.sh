#!/bin/sh
echo > /etc/sysctl.conf
##
tee -a /etc/sysctl.conf <<EOF
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
EOF
##
sysctl -p
IPC=$(curl -4 -s icanhazip.com | cut -d"." -f3)
IPD=$(curl -4 -s icanhazip.com | cut -d"." -f4)
##
if [ $IPC == 4 ]
then
   tee -a /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
	IPV6INIT=yes
	IPV6_AUTOCONF=no
	IPV6_DEFROUTE=yes
	IPV6_FAILURE_FATAL=no
	IPV6_ADDR_GEN_MODE=stable-privacy
	IPV6ADDR=2402:800:6312:3fbb:3402::$IPD:0000/64
	IPV6_DEFAULTGW=2402:800:6312:3fbb:3402
	EOF
elif [ $IPC == 5 ]
then
   tee -a /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
	IPV6INIT=yes
	IPV6_AUTOCONF=no
	IPV6_DEFROUTE=yes
	IPV6_FAILURE_FATAL=no
	IPV6_ADDR_GEN_MODE=stable-privacy
	IPV6ADDR=2402:800:6312:3fbb:3402$IPD:0000/64
	IPV6_DEFAULTGW=2402:800:6312:3fbb:3402
	EOF
elif [ $IPC == 244 ]
then
   tee -a /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
	IPV6INIT=yes
	IPV6_AUTOCONF=no
	IPV6_DEFROUTE=yes
	IPV6_FAILURE_FATAL=no
	IPV6_ADDR_GEN_MODE=stable-privacy
	IPV6ADDR=2402:800:6312:3fbb:3402::$IPD:0000/64
	IPV6_DEFAULTGW=2402:800:6312:3fbb:3402
	EOF
else
	tee -a /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
	IPV6INIT=yes
	IPV6_AUTOCONF=no
	IPV6_DEFROUTE=yes
	IPV6_FAILURE_FATAL=no
	IPV6_ADDR_GEN_MODE=stable-privacy
	IPV6ADDR=2402:800:6312:3fbb:3402$IPC::$IPD:0000/64
	IPV6_DEFAULTGW=2402:800:6312:3fbb:3402$IPC::1
	EOF
fi

service network restart

rm -rf ipv6.sh
