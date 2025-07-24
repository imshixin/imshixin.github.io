# 新系统配置

> [!Note]
> 注意修改命令开头的变量

## 关闭sudo密码

```sh
username=vge
echo "${username} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"${username}"
sudo chmod 440 /etc/sudoers.d/"${username}"
```

## 配置apt代理

```sh
proxy=192.168.120.1:10808
echo "Acquire::http::Proxy \"http://${proxy}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf
echo "Acquire::https::Proxy \"http://${proxy}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf

```

## 配置时间同步
```sh
ntphost=192.168.120.1
sudo sed -i 's/^NTP=/# &/;  s/^RootDistanceMaxSec=/# &/' /etc/systemd/timesyncd.conf
sudo sed -i "s/\[Time\]/\[Time\]\nNTP=${ntphost}\nRootDistanceMaxSec=100y/" /etc/systemd/timesyncd.conf
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd
timedatectl timesync-status
```

## 开启ssh密钥登录
```sh
sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

## 添加ssh公钥

这个公钥为jetsu_gu.pub，可以替换为你自己的公钥
```sh
username=vge
mkdir -p /home/${username}/.ssh
# EOF前的空行是必须的
cat <<EOF | tee -a /home/${username}/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCe1BLcCbm4jgOfz4iyrWqW6ICCva3JeYMQzUY0lWQ5fo82oDwfpvZvW4KTr6jUNQuHcm9Lcnv8a+g9Pg/wp45L+SP5n0n0g/iJIz14kJY8/szHb3EyHr5uuCuC0Cc7QV/nCKA7ntuIhMVXRRHSsy6T/G4Z4hOxGS7rUW7oY/GGxIhSb37lEan/8xxyYgvNZgDYHTriKxZPYdTXNOTvgl1QdYoZV88FGGWQiZRPzS4b+YX07VFO3YqQVIX9VRIabGUMRIBbeg9CzZAR79LPJRO0zHAe4qwwb4HGoU8G4eYG6O+ec3UG8vvaslqk/MsfI9f3wieDcXZv6H85M1+3c+ohvabPwDvGzmhjqjazoW3eqPOy2WjRxH9Ck2sdNR9V3uLSloZs6OR9hhmaL5T0Py1zTrGIq8gtfUgmtJqJh97Wan5JP98n6hC1m6ebBMUjyhaLQKfc+oCuZJ/jAdEvZfXGJJU7n83mVZzaYfHZDKjd3uQ5PesJfyiQxI1YzBQFWh0= imshixin@163.com

EOF
```

## 配置github ssh config

请上传你自己的密钥文件到`~/.ssh/`或其他路径，并相应修改下面的`~/.ssh/id_rsa_github_gu`为你自己的文件路径

请修改为你自己的代理服务器地址
```sh
username=vge
proxy=192.168.120.1:10808
mkdir -p /home/${username}/.ssh && chmod 700 /home/${username}/.ssh
cat <<EOF | tee -a /home/${username}/.ssh/config
Host github.com
  User git
  HostName github.com
  ProxyCommand nc -x ${proxy} %h %p
  IdentityFile ~/.ssh/id_rsa_github_gu
EOF
```
