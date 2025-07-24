username=vge
# ntp主机地址，请确保能用
host="192.168.120.1 192.168.120.6"
proxy_host="192.168.120.1:10808"

# 去除sudo密码
echo "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$username"
sudo chmod 440 /etc/sudoers.d/"$username"

# 同步时间
sudo sed -i 's/^NTP=/# &/;  s/^RootDistanceMaxSec=/# &/' /etc/systemd/timesyncd.conf
sudo sed -i "s/\[Time\]/\[Time\]\nNTP=${host:-192.168.120.1}\nRootDistanceMaxSec=100y/" /etc/systemd/timesyncd.conf
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd
timedatectl timesync-status
# 或手动设置, 修改为当前时间
# sudo timedatectl set-time "2025-07-24 12:58:00"

# 配置apt代理, 设置为自己的代理地址
echo "Acquire::http::Proxy \"http://${proxy_host:-192.168.120.1:10808}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf
echo "Acquire::https::Proxy \"http://${proxy_host:-192.168.120.1:10808}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf

# 允许ssh密钥登录
sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# 添加ssh公钥
user_home="/home/${username:-vge}"
mkdir -p ${user_home}/.ssh
# 这个公钥为jetsu_gu.pub， EOF前的空行是必须的
cat <<EOF | tee -a ${user_home}/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCe1BLcCbm4jgOfz4iyrWqW6ICCva3JeYMQzUY0lWQ5fo82oDwfpvZvW4KTr6jUNQuHcm9Lcnv8a+g9Pg/wp45L+SP5n0n0g/iJIz14kJY8/szHb3EyHr5uuCuC0Cc7QV/nCKA7ntuIhMVXRRHSsy6T/G4Z4hOxGS7rUW7oY/GGxIhSb37lEan/8xxyYgvNZgDYHTriKxZPYdTXNOTvgl1QdYoZV88FGGWQiZRPzS4b+YX07VFO3YqQVIX9VRIabGUMRIBbeg9CzZAR79LPJRO0zHAe4qwwb4HGoU8G4eYG6O+ec3UG8vvaslqk/MsfI9f3wieDcXZv6H85M1+3c+ohvabPwDvGzmhjqjazoW3eqPOy2WjRxH9Ck2sdNR9V3uLSloZs6OR9hhmaL5T0Py1zTrGIq8gtfUgmtJqJh97Wan5JP98n6hC1m6ebBMUjyhaLQKfc+oCuZJ/jAdEvZfXGJJU7n83mVZzaYfHZDKjd3uQ5PesJfyiQxI1YzBQFWh0= imshixin@163.com

EOF

# 配置ssh config for github
user_home="/home/${username:-vge}"
proxy_host=${proxy_host:-"192.168.120.1:10808"}
mkdir -p ${user_home}/.ssh && chmod 700 ${user_home}/.ssh
cat <<EOF | tee -a ${user_home}/.ssh/config
Host github.com
  User git
  HostName github.com
  ProxyCommand nc -x ${proxy_host} %h %p
  IdentityFile ~/.ssh/id_rsa_github_gu
EOF


# 安装zsh
sudo apt install -y zsh
export http_proxy="http://${proxy_host:-192.168.120.1:10808}" https_proxy="http://${proxy_host:-192.168.120.1:10808}"
# 跳过确认，直接安装
echo "y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "vge" | chsh -s $(which zsh)
exec zsh
export http_proxy="http://${proxy_host:-192.168.120.1:10808}" https_proxy="http://${proxy_host:-192.168.120.1:10808}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
# 后面的内容建议手动添加
# mv ~/.zshrc ~/.zshrc_bak
# cat <<EOF | tee ~/.zshrc
# # 前面没安装power10k的话这里就不要设置成`powerlevel10k`
# # 可以在这里查找和预览其他主题：https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
# #......中间省略多行
# # 一定要覆盖原有的plugins配置
# plugins=(
#         git # git的aliases
#         sudo # 双击esc切换sudo执行
#         z # 输入模糊路径，使用z命令一键跳转到历史目录
#         extract # 解压任意压缩包
#         zsh-completions
#         zsh-autosuggestions
#         zsh-syntax-highlighting
#         zsh-history-substring-search
#         zsh-autosuggestions # 这个插件有点花哨，可以不用
#         )
# #zsh-completions config before source onmyzsh
# #下面这两行要在`source $ZSH/oh-my-zsh.sh`这之前添加上
# fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
# autoload -U compinit && compinit
# source $ZSH/oh-my-zsh.sh
# # zsh-history-substring-search的上下方向键键位绑定，可以绑定到其他键位
# # see: https://github.com/zsh-users/zsh-history-substring-search
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down
# # 设置提示策略
# export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# # zsh-autocomplete提示延迟一定时间
# zstyle ':autocomplete:*' delay 0.5  # seconds (float)
# EOF


# 安装ros
sudo apt install -y software-properties-common
sudo add-apt-repository universe
sudo apt update && sudo apt install curl -y
export http_proxy="http://${proxy_host:-192.168.120.1:10808}" https_proxy="http://${proxy_host:-192.168.120.1:10808}"
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" # If using Ubuntu derivates use $UBUNTU_CODENAME
sudo dpkg -i /tmp/ros2-apt-source.deb
sudo apt update
sudo apt install -y ros-humble-desktop ros-dev-tools

setopt nonomatch # if use zsh
# 安装flash3d依赖
sudo apt install -y ros-humble-ament-lint-*
sudo apt install -y ros-humble-ament-cmake-*
sudo apt install -y ros-humble-image-transport* # for plugins
sudo apt install -y ros-humble-ffmpeg-image-transport* # for ffmpeg topic
sudo apt install -y ros-humble-rviz-imu-plugin
sudo apt install -y ros-humble-nmea-msgs
sudo apt install -y ros-humble-nmea-navsat-driver
sudo apt install -y python3-pip

sudo apt install -y libaravis-dev # for cameras
sudo apt install -y nlohmann-json3-dev # for json
sudo apt install -y libgpiod-dev gpiod # for GPIO
sudo apt install -y gdbserver # for debug
export http_proxy="http://${proxy_host:-192.168.120.1:10808}" https_proxy="http://${proxy_host:-192.168.120.1:10808}"
sudo -E pip3 install transforms3d
wget https://www.hikrobotics.com/cn2/source/support/software/MVS_STD_GML_V2.1.2_231116.zip
unzip MVS_STD_GML_V2.1.2_231116.zip -d MVS
sudo dpkg -i MVS/MVS-2.1.2_$(uname -m)_20231116.deb
rm -rf MVS
rm MVS_STD_GML_V2.1.2_231116.zip

# 安装pixi
export http_proxy="http://${proxy_host:-192.168.120.1:10808}" https_proxy="http://${proxy_host:-192.168.120.1:10808}"
curl -fsSL https://pixi.sh/install.sh | sh

# 安装git-lfs
sudo apt install git-lfs
