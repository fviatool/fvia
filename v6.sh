#!/bin/bash

# Clear sysctl.conf
echo > /etc/sysctl.conf

# Append IPv6 configuration to sysctl.conf
cat <<EOF >> /etc/sysctl.conf
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
EOF

# Apply sysctl settings
sysctl -p

# Get the IPv6 address of the system
IPv6_ADDR=$(curl -6 -s ifconfig.co)

# Check if IPv6 address is retrieved successfully
if [ -n "$IPv6_ADDR" ]; then
    # Extract the network prefix from the IPv6 address
    IPV6_PREFIX=$(echo "$IPv6_ADDR" | awk -F'::' '{print $1}')

    # Configure IPv6 address and gateway
    cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
IPV6INIT=yes
IPV6_AUTOCONF=no
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
IPV6ADDR=${IPV6_PREFIX}::1/64
IPV6_DEFAULTGW=${IPV6_PREFIX}::1
EOF

    # Restart the network service
    service network restart

    echo "Set IPv6 $IPv6_ADDR"
else
    echo "Không thể truy xuất địa chỉ IPv6. Vui lòng kiểm tra kết nối mạng của bạn."
fi

# Remove the script
rm -f ipv6_auto.sh
