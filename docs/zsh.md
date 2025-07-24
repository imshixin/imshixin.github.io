# zsh和oh-my-zsh的安装与配置

> [!NOTE]
> 如果网络不好，建议设置代理，**代理地址改为自己的地址**
> ```sh
> export http_proxy="http://192.168.120.1:10808" https_proxy="http://192.168.120.1:10808"
> ```
> ***使用`sudo`命令时需要添加`-E`参数代理才能生效***

## 安装

> 一键全装
> ```
> sudo apt install zsh
> sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
> git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
> git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
> git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
> git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
> git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
> ```

安装zsh

```sh
sudo apt install zsh
```

安装ohmyzsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

安装ohmyzsh插件

1. zsh-syntax-highlighting：提供语法高亮和命令检查
```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
2. zsh-autosuggestions：提供历史命令和tab补全的提示
```sh
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
3. zsh-completions：提供额外的tab补全
```sh
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
```
4. zsh-history-substring-search：提供历史命令的模糊搜索（可选）
```sh
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```
5. zsh-autocomplete：提供自动提示和补全，相比zsh-autosuggestions功能更强大更复杂（可选）
```sh
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
```



安装power10k主题（可选）

```sh
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

## zsh配置文件修改


编辑`~/.zshrc`

- 找到`ZSH_THEME`，修改为你自己喜欢的一个主题
```sh
# 安装了power10k的话可以按如下设置
# 或者在这里查找和预览其他主题：https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
```

- 往下找到`plugins`，配置zsh插件，将原有的`plugins=...`和`source $ZSH/oh-my-zsh.sh`这两行替换为

    ```sh
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
            zsh-autosuggestions # 这个插件有点花哨，可以不用
            )
    #zsh-completions config before source onmyzsh
    #下面这两行要在`source $ZSH/oh-my-zsh.sh`这之前添加上
    fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
    autoload -U compinit && compinit

    source $ZSH/oh-my-zsh.sh

    # zsh-history-substring-search的上下方向键键位绑定，可以绑定到其他键位
    # see as: https://github.com/zsh-users/zsh-history-substring-search
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down

    # 设置提示策略
    export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

    # zsh-autocomplete提示延迟一定时间
    zstyle ':autocomplete:*' delay 0.5  # seconds (float)
    # 开启通配符
    setopt nonomatch
    ```

## 终端字体设置

### 字体安装

1. **推荐（等宽字体）：Jetbrains Mono Nerd Font**

    [预览](https://www.programmingfonts.org/#jetbrainsmono)
    [下载](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)

    <!-- ![Jetbrains Mono Nerd Font](https://img.xinit.xyz/docsify20250710232741447.png) -->
2. MesloLG Nerd Font

    [预览](https://www.programmingfonts.org/#meslo)
    [下载](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip)

#### Windows
Windows下解压所有ttf字体文件后全选`ttf文件`右键安装即可

#### Linux

将你需要的字体文件拷贝到系统目录,
也可以将压缩包内的所有ttf文件拷贝过来
```bash
sudo cp JetBrainsMonoNerdFont-Regular.ttf /usr/share/fonts
# 刷新字体缓存
sudo fc-cache -fv
# 检查是否安装上字体文件
fc-list
```

### Vscode集成终端配置
在设置中搜索`终端 字体`，第一个选项就是终端的字体设置，输入`JetBrainsMono Nerd Font, MesloLGM Nerd Font, monospace`
> 逗号分割多个字体，会从第一个往后依次检索系统已安装的字体使用

或者直接在`settings.json`中添加
```json
"terminal.integrated.fontFamily": "JetBrainsMono Nerd Font, MesloLGM Nerd Font, monospace"

```
<!-- ![Vscode集成终端配置](http://img.xinit.xyz/markdownPixPin_2025-06-16_11-00-02.png?image) -->

### Windows Terminal（终端）配置
在 设置 > 默认值 > 外观 下有字体设置

<!-- ![Windows Terminal（终端）配置](http://img.xinit.xyz/markdownPixPin_2025-06-16_10-58-13.png) -->

输入`JetBrainsMono Nerd Font`或点击输入框后会显示系统所有已安装字体，选择JetBrainsMono Nerd Font即可

## .zshrc中的ros 环境配置

> 添加到`~/.zshrc`最后面
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
```

自动激活ros环境，有兼容问题不推荐使用
```sh
# 自动source ros环境，目前不建议使用
if [ -e "install/local_setup.zsh" ]
then
        read -k 1 "s?source local_setup.zsh( y /default n)? "
        echo "\r"
        if [ -n $s ]
        then
                if [ $s == 'y' -o $s == 'Y' ]
                then
                        rosup
                fi
        fi
fi
```

如果需要在bash中使用（如root用户），将这些代码粘贴到`~/.bashrc`:
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

## other

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
