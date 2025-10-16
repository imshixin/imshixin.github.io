printf "\e[1;36m请输入HTTP/HTTPS代理地址，格式如 192.168.120.1:10808，留空则跳过设置代理（确保能访问github）: \e[0m\n"
read -r proxy_input


if [ -n "$proxy_input" ]; then
        export http_proxy="http://$proxy_input"
        export https_proxy="http://$proxy_input"
fi
printf "\e[1;36m当前代理为: http_proxy=$http_proxy, https_proxy=$https_proxy\e[0m\n"
# 安装zsh和插件
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf  "\e[1;36m开始安装zsh curl git \e[0m\n"
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
sudo -E apt install -y zsh curl git
if [ -d ~/.oh-my-zsh ];then
  printf "\033[1;33m删除目录~/.oh-my-zsh\033[0m\n"
  rm -rf ~/.oh-my-zsh
fi
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf  "\e[1;36m开始安装oh-my-zsh \e[0m\n"
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
sh -c "$(curl -fsSL https://install.ohmyz.sh)" "" --unattended
printf  "\e[1;36m开始安装zsh-syntax-highlighting \e[0m\n"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
printf  "\e[1;36m开始安装zsh-autosuggestions \e[0m\n"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
printf  "\e[1;36m开始安装zsh-completions \e[0m\n"
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
printf  "\e[1;36m开始安装zsh-history-substring-search \e[0m\n"
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
printf  "\e[1;36m开始安装zsh-autocomplete \e[0m\n"
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
printf  "\e[1;36m安装zsh、oh-my-zsh及其插件完成! \e[0m\n"

if [ ! -f ~/.zshrc ];then
echo "找不到~/.zshrc文件，脚本退出"
exit 0
fi

printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf  "\e[1;36m是否需要安装powerlevel10k主题？（y/n）\e[0m"
read -r is_install_plk
if [ "$is_install_plk" = "y" ] || [ "$is_install_plk" = "Y" ];then

    printf  "\e[1;36m开始安装powerlevel10k主题\e[0m\n"
    git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    cur_theme=$(grep -E '^ZSH_THEME=' ~/.zshrc | cut -d = -f 2 | tr -d "'\"")
    printf  "\e[1;36m当前主题为：\033[1;32m$cur_theme\e[0m\n"
    printf  "\e[1;36m设置新主题为：\033[1;32mpowerlevel10k\e[0m\n"
    sed -i -E "s/^(ZSH_THEME=)[\"']?[^\"']*[\"']?/\1\"powerlevel10k\/powerlevel10k\"/" ~/.zshrc
else
    cur_theme=$(grep -E '^ZSH_THEME=' ~/.zshrc | cut -d = -f 2 | tr -d "'\"")
    printf  "\e[1;36m当前主题为：\033[1;32m$cur_theme\e[0m\n"
    printf  "\e[1;36m在这里查找和预览其他主题：https://github.com/ohmyzsh/ohmyzsh/wiki/Themes\e[0m\n"
    printf  "\e[1;36m输入新的主题名称或留空以跳过更改主题：\e[0m"
    read -r new_theme
    if [ -n "$new_theme" ];then
        printf  "\e[1;36m设置主题为：\e[1;32m$new_theme\e[0m\n"
        sed -i -E "s/^(ZSH_THEME=)[\"']?[^\"']*[\"']?/\1\"$new_theme\"/" ~/.zshrc
    fi
fi

# cp ~/.zshrc ~/.zshrc.bak
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf  "\e[1;36m更新配置文件：~/.zshrc \e[0m\n"

sed -i '/^plugins=(git)$/,/^source \$ZSH\/oh-my-zsh\.sh$/ {
    /^plugins=(git)$/ {
        r /dev/stdin
        d
    }
    /^source \$ZSH\/oh-my-zsh\.sh$/d
}' ~/.zshrc << 'EOF'
# 一定要覆盖原有的plugins配置
plugins=(
        git # git的aliases
        sudo # 双击esc切换sudo执行
        z # 输入模糊路径，使用z命令一键跳转到历史目录
        extract # 解压任意压缩包
        zsh-completions
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-history-substring-search
        # zsh-autocomplete # 这个插件有点花哨，可以不用
        )
#zsh-completions config before source onmyzsh
#下面这两行要在`source $ZSH/oh-my-zsh.sh`这之前添加上
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh
ZSH_THEME_TERM_TITLE_IDLE="%n@%m:%~"  # 修改终端窗口标题，空闲时显示：用户名@主机名:当前目录
ZSH_THEME_TERM_TAB_TITLE_IDLE="%n@%m:%~"  # 上面这个可能不生效，这个可能会生效

# zsh-history-substring-search的上下方向键键位绑定，可以绑定到其他键位
# 输入模糊指令后按方向上键搜索历史输入指令
# see as: https://github.com/zsh-users/zsh-history-substring-search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# 设置提示策略
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# zsh-autocomplete提示延迟一定时间
zstyle ':autocomplete:*' delay 0.5  # seconds (float)
# 开启通配符
setopt nonomatch
EOF

if ! grep -q "rosup(){" ~/.zshrc;then
printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf  "\e[1;96m是否添加ros2 humble的source脚本？（y/n，默认为y）\e[0m"
read -r is_install_ros
if [ "$is_install_ros" != "n" -a "$is_install_ros" != "N" ];then
sudo -E apt install -y python3-argcomplete
cat >> ~/.zshrc << EOF
rosup(){
        #pushd install > /dev/null
        source /opt/ros/humble/setup.zsh
        if [ \$? ]
        then
                result="[OK]"
        else
                result="[Failed]"
        fi
        printf "%-40s %-5s\n" "sourcing /opt/ros/humble/setup.zsh" "\$result"
        #popd > /dev/null
        #source local_setup
        if [ -e "install/local_setup.zsh" ]
        then
                pushd install > /dev/null
                source local_setup.zsh
                if [ \$? ]
                then
                        result="[OK]"
                else
                        result="[Failed]"
                fi
                printf "%-40s %-5s\n" "sourcing local_setup.zsh" "\$result"
                #if [ \$? ];then printf "%-40s %-5s\n" "sourcing local_setup.zsh" "[OK]";fi
                popd > /dev/null
        else
                echo "no install/local_setup.zsh found"
        fi
        # autocomplete for ros2 and colcon
        # need install python3-argcomplete by apt
        eval "\$(register-python-argcomplete3 ros2)"
        eval "\$(register-python-argcomplete3 colcon)"
}
EOF
fi
printf  "\e[1;96m已添加ros激活函数，在终端使用命令'rosup'激活ros2 humble环境和当前目录下的ros2环境 \e[0m\n"
fi


printf  "\e[1;36m--------------------------------------------------\e[0m\n"
printf  "\e[1;96m正在更改默认shell，请输入当前用户的密码 \e[0m\n"
chsh -s $(which zsh)
printf  "\e[1;92m全部安装完成，正在切换到zsh \e[0m\n"
exec zsh
