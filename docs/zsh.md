
# 设置代理
如果网络不好，建议设置代理，**代理地址改为自己的地址**
```sh
export http_proxy="http://192.168.120.1:10809"
export https_proxy="http://192.168.120.1:10809"
# 或者
PROXY="http://192.168.120.1:10809" export http_proxy="$PROXY" https_proxy="$PROXY"
```
***请注意，使用`sudo`命令时需要添加`-E`参数才能使用代理***
# zsh安装
`sudo apt install zsh`

# ohmyzsh安装

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

# ohmyzsh插件安装

1. zsh-syntax-highlighting
```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
2. zsh-autosuggestions
```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
3. zsh-completions
```sh
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
```


# zsh配置文件修改

## 安装power10k主题（可选）


```
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

## 修改配置

编辑`~/.zshrc`

```sh
# 前面没安装power10k的话这里就不要改成`powerlevel10k`
# 可以在这里查找所有主题名字：https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
#......中间省略多行
# 一定要覆盖原有的plugins配置
plugins=(git sudo z zsh-completions zsh-autosuggestions zsh-syntax-highlighting extract)
#zsh-completions config before source onmyzsh
#下面这一行要在`source $ZSH/oh-my-zsh.sh`这之前添加上
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh
```

# 终端字体安装
## 下载
1. 推荐（等宽字体）：Jetbrains Mono Nerd Font
[预览](https://www.programmingfonts.org/#jetbrainsmono)
[下载](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)
2. MesloLG Nerd Font
[预览](https://www.programmingfonts.org/#meslo)
[下载](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip)

## 字体安装

Windows下解压所有TIFF字体文件后全选右键安装即可
#TODO Linux下字体安装方法（网上自己搜）

## Vscode集成终端配置
在设置中搜索`终端 字体`，第一个选项就是终端的字体设置，输入`JetBrainsMono Nerd Font, MesloLGM Nerd Font, monospace`
> 逗号分割多个字体，会从第一个往后依次检索系统已安装的字体使用

或者直接在`settings.json`中添加
```json
"terminal.integrated.fontFamily": "JetBrainsMono Nerd Font, MesloLGM Nerd Font, monospace"

```
![Vscode集成终端配置](http://img.xinit.xyz/markdownPixPin_2025-06-16_11-00-02.png?image)

## Windows Terminal（终端）配置
在 设置 > 默认值 > 外观 下有字体设置

![Windows Terminal（终端）配置](http://img.xinit.xyz/markdownPixPin_2025-06-16_10-58-13.png)

输入`JetBrainsMono Nerd Font`或点击输入框后会显示系统所有已安装字体，选择JetBrainsMono Nerd Font即可

# ros 环境配置
> 添加到`~/.zshrc`最前面
>
> zsh对ROS需要安装额外的自动补全插件，使用`sudo apt install python3-argcomplete`安装

zsh的代码：
```bash
rosup(){
        #pushd install > /dev/null
        source /opt/ros/humble/setup.zsh
        if [ $? ]
        then
                result="[OK]"
        else
                result="[Failed]"
        fi
        printf "%-40s %-5s\n" "sourcing /opt/ros/humble/setup.zsh" "$result"
        #popd > /dev/null
        #source local_setup
        if [ -e "install/local_setup.zsh" ]
        then
                pushd install > /dev/null
                source local_setup.zsh
                if [ $? ]
                then
                        result="[OK]"
                else
                        result="[Failed]"
                fi
                printf "%-40s %-5s\n" "sourcing local_setup.zsh" "$result"
                #if [ $? ];then printf "%-40s %-5s\n" "sourcing local_setup.zsh" "[OK]";fi
                popd > /dev/null
        else
                echo "no install/local_setup.zsh found"
        fi
        # autocomplete for ros2 and colcon
        # need install python3-argcomplete by apt
        eval "$(register-python-argcomplete3 ros2)"
        eval "$(register-python-argcomplete3 colcon)"
}
# 自动source ros环境，目前不建议使用
# if [ -e "install/local_setup.zsh" ]
# then
#         read -k 1 "s?source local_setup.zsh( y /default n)? "
#         echo "\r"
#         if [ -n $s ]
#         then
#                 if [ $s == 'y' -o $s == 'Y' ]
#                 then
#                         rosup
#                 fi
#         fi
# fi
```

bash的代码:
```bash
rosup(){
        #pushd install > /dev/null
        source /opt/ros/humble/setup.bash
        if [ $? ]
        then
                result="[OK]"
        else
                result="[Failed]"
        fi
        printf "%-40s %-5s\n" "sourcing /opt/ros/humble/setup.bash" "$result"
        #popd > /dev/null
        #source local_setup
        if [ -e "install/local_setup.bash" ]
        then
                pushd install > /dev/null
                source local_setup.bash
                if [ $? ]
                then
                        result="[OK]"
                else
                        result="[Failed]"
                fi
                printf "%-40s %-5s\n" "sourcing local_setup.bash" "$result"
                #if [ $? ];then printf "%-40s %-5s\n" "sourcing local_setup.zsh" "[OK]";fi
                popd > /dev/null
        else
                echo "no install/local_setup.bash found"
        fi
}
# 自动source ros环境，不建议使用
# if [ -e "install/local_setup.bash" ]
# then
#         read -n 1 -p "source local_setup.bash( y /default n)? " s
#         echo "\r"
#         if [ -n $s ]
#         then
#                 if [ $s == 'y' -o $s == 'Y' ]
#                 then
#                         rosup
#                 fi
#         fi
# fi
```

# other

这些不用设置

MVS环境配置，放在最下面：
```zsh
alias temp1=sudo cat /sys/class/thermal/thermal_zone1/temp
alias temp0=sudo cat /sys/class/thermal/thermal_zone0/temp
alias vnc=tigervncserver -localhost no
export MVCAM_SDK_PATH=/opt/MVS

export MVCAM_COMMON_RUNENV=/opt/MVS/lib

export MVCAM_GENICAM_CLPROTOCOL=/opt/MVS/lib/CLProtocol

export ALLUSERSPROFILE=/opt/MVS/MVFG
export LD_LIBRARY_PATH=/opt/MVS/lib/aarch64:$LD_LIBRARY_PATH
```
