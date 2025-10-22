# 常用Ubuntu系统配置

> [!TIP]
> 现在可以使用脚本一键设置:
> `sh -c "$(curl -fsSL https://d.xinit.xyz/scripts/fresh.sh)"`
> 或：`sh -c "$(wget -qO- https://d.xinit.xyz/scripts/fresh.sh)"`

## 关闭sudo密码

```bash
printf "\e[1;36m关闭指定用户的sudo密码，请输入用户名（留空跳过）：\e[0m"
read -r username
if [ -n "$username" ];then
printf "\e[1;36m已向/etc/sudoers.d/${username}写入：\e[0m\n"
echo "${username} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"${username}"
sudo chmod 440 /etc/sudoers.d/"${username}"
fi

```

## 配置apt代理

```bash
printf "\e[1;36m设置apt代理\e[0m\n"
printf "\e[1;36m请输入HTTP/HTTPS代理地址（留空跳过），格式如 192.168.120.1:10808\e[0m\n："
read -r proxy
if [ -n "$proxy" ];then
printf "\e[1;36m已向/etc/apt/apt.conf.d/proxy.conf写入：\e[0m\n"
echo "Acquire::http::Proxy \"http://${proxy}\";" | sudo tee /etc/apt/apt.conf.d/proxy.conf
echo "Acquire::https::Proxy \"http://${proxy}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf
fi

```

## 配置时间同步

```bash
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

```

<!-- ## 开启ssh密钥登录

```bash
sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

``` -->

## 添加ssh公钥

**将下面的`<替换为你的公钥内容>`替换后再执行**
```bash
mkdir -p ~/.ssh
# EOF前的空行是必须的
cat <<EOF | tee -a ~/.ssh/authorized_keys
<替换为你的公钥内容>

EOF

```

## 配置github ssh config

1. 上传你自己的**密钥**文件到`~/.ssh/`
2. 修改变量
3. 放到终端中 执行

**修改`username`为你自己的用户名，修改`proxy`为你自己的代理服务器地址，修改`id_rsa`为你自己的密钥文件路径**

> 在终端执行
```bash
username=vge
proxy=192.168.120.1:10808
id_rsa=~/.ssh/id_rsa_github_gu
# 先修改上面的变量
mkdir -p /home/${username}/.ssh && chmod 700 /home/${username}/.ssh
cat <<EOF | tee -a /home/${username}/.ssh/config
Host github.com
  User git
  HostName github.com
  ProxyCommand nc -x ${proxy} %h %p
  IdentityFile ${id_rsa}
EOF

```
