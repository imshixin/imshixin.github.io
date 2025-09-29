# 新Ubuntu系统配置


## 关闭sudo密码

**修改`username`为你linux服务器的用户名**

```bash
username=vge
echo "${username} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"${username}"
sudo chmod 440 /etc/sudoers.d/"${username}"

```

## 配置apt代理

**修改`proxy`为你自己的代理服务器地址**
```bash
proxy=192.168.120.1:10808
echo "Acquire::http::Proxy \"http://${proxy}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf
echo "Acquire::https::Proxy \"http://${proxy}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf

```

## 配置时间同步

**修改`ntphost`为你自己的ntp服务器地址，多个用空格隔开**
```bash
ntphost="192.168.120.11 192.168.120.12"
sudo sed -i 's/^NTP=/# &/;  s/^RootDistanceMaxSec=/# &/' /etc/systemd/timesyncd.conf
sudo sed -i "s/\[Time\]/\[Time\]\nNTP=${ntphost}\nRootDistanceMaxSec=100y/" /etc/systemd/timesyncd.conf
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd
timedatectl timesync-status

```

## 开启ssh密钥登录
```bash
sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

```

## 添加ssh公钥

**修改`username`为你自己的用户名**
```bash
username=vge
mkdir -p /home/${username}/.ssh
# EOF前的空行是必须的
cat <<EOF | tee -a /home/${username}/.ssh/authorized_keys
<你的公钥内容>

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
