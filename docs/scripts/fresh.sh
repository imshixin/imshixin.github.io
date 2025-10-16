#!/bin/bash

# --------------------------------------------------------
# 关闭指定用户sudo的密码
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf "\e[1;36m关闭指定用户的sudo密码，请输入要关闭的用户名（留空跳过）：\e[0m"
read -r username
if [ -n "$username" ];then
printf "\e[1;36m已向/etc/sudoers.d/${username}写入：\e[0m\n"
echo "${username} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"${username}"
sudo chmod 440 /etc/sudoers.d/"${username}"
fi

# --------------------------------------------------------
# 设置apt的代理
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf "\e[1;36m设置apt代理\e[0m\n"
printf "\e[1;36m请输入HTTP/HTTPS代理地址（留空跳过），格式如 192.168.120.1:10808\e[0m\n："
read -r proxy
if [ -n "$proxy" ];then
printf "\e[1;36m已向/etc/apt/apt.conf.d/proxy.conf写入：\e[0m\n"
echo "Acquire::http::Proxy \"http://${proxy}\";" | sudo tee /etc/apt/apt.conf.d/proxy.conf
echo "Acquire::https::Proxy \"http://${proxy}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf
fi

# 设置时间同步地址
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf "\e[1;36m配置时间同步\e[0m\n"
printf "\e[1;36m请输入时间同步服务器地址，多个用空格分开（留空跳过设置）\e[0m\n："
read -r ntphost

if [ -n "$ntphost" ];then
sudo sed -i 's/^NTP=/# &/;  s/^RootDistanceMaxSec=/# &/' /etc/systemd/timesyncd.conf
sudo sed -i "s/\[Time\]/\[Time\]\nNTP=${ntphost}\nRootDistanceMaxSec=100y/" /etc/systemd/timesyncd.conf
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd
timedatectl timesync-status
fi
