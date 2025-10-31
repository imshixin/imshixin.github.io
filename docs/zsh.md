# zsh和oh-my-zsh的安装与配置

> [!TIP]
> 新增了一键安装脚本：
> `sh -c "$(curl -fsSL https://d.xinit.xyz/scripts/zsh.sh)"`
>
> 或：`sh -c "$(wget -qO- https://d.xinit.xyz/scripts/zsh.sh)"`

## 安装

<!-- 一键全装

使用圆括号将命令合并为一个命令，避免多个历史记录

(
printf "请输入 HTTP/HTTPS 代理地址（格式如 192.168.120.1:8080，回车跳过）: "
read -r proxy_input

if [ -n "$proxy_input" ]; then
        export http_proxy="http://$proxy_input"
        export https_proxy="http://$proxy_input"
        echo "已设置代理: http_proxy=$http_proxy, https_proxy=$https_proxy"
else
    echo "跳过设置代理"
fi
# 安装zsh和插件
sudo apt install zsh curl git
[ -d ~/.oh-my-zsh ] && rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
echo -e "\e[1;37;42m install zsh and oh-my-zsh plugins ok! \e[0m"
echo -e "\e[1;37;42m changing default shell \e[0m"
echo -e "\e[1;37;42m please enter your password: \e[0m"
chsh -s $(which zsh)
) -->


**安装zsh：**

> *使用`sudo`命令安装zsh时需要添加`-E`参数代理才能生效*

```sh
sudo apt install zsh curl git
```

**安装ohmyzsh：**

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**安装ohmyzsh插件：**

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
4. zsh-history-substring-search：提供历史命令的模糊搜索
```sh
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```
5. zsh-autocomplete：提供自动提示和补全，相比zsh-autosuggestions功能更强大更复杂（可选）
```sh
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
```
6. 安装power10k主题（可选）
```sh
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

## zsh配置文件修改


编辑文件`~/.zshrc`

- 找到`ZSH_THEME=...`，修改为你自己喜欢的[主题名](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)，例如
```sh
# 在这里查找和预览其他主题：https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="candy"
```
如果安装了powerlevel10k，则设置为
```sh
ZSH_THEME="powerlevel10k/powerlevel10k"
```

- 往下翻找到`plugins=...`，配置zsh插件，将原有的
    ```sh
    plugins=(git)

    source $ZSH/oh-my-zsh.sh
    ```
    替换为
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

    # 设置提示策略包含completion
    export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

    # 设置zsh-autocomplete提示延迟一定时间
    zstyle ':autocomplete:*' delay 0.5  # seconds (float)
    # 开启通配符传递
    setopt nonomatch
    ```

> [!IMPORTANT]
> 请检查`~/.bashrc`文件末尾，如果有用export导出一些环境变量，记得把这些命令也拷贝到`~/.zshrc`中，
> 例如jetson系统中的bashrc定义的cuda的环境变量，不拷贝到zshrc中就无法使用cuda


## zsh的 ros 环境配置

> [!NOTE]
> 下面的代码按需添加到`~/.zshrc`的最后面
>
> zsh的ROS命令提示需要安装额外的自动补全插件，使用`sudo apt install python3-argcomplete`安装


zsh的source函数代码（使用方法为在终端输入`rosup`）：
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

快捷开启代理的脚本，放到`.zshrc`最后面：
```bash
export PROXY_CONF="${HOME}/.proxyrc"
pon(){
  # 加载配置
  # default_ip
  # default_port
  if [ -e "$PROXY_CONF" ];then
    source $PROXY_CONF
    printf "\e[36m直接回车使用默认代理 ${default_ip}:${default_port}
或输入代理(格式如 \e[7m11\e[0;36m、\e[7m120.11\e[0;36m、\e[7m168.120.11\e[0;36m、\e[7m192.168.120.11\e[0;36m，可加上端口号:10808\e[0;36m)\e[0m\n:"
  else
    printf "\e[36m输入代理地址(格式如 \e[7m192.168.120.11:10808\e[0;36m)\e[0m\n:"
  fi
  read -r input
  if [ -z "$input" ]; then
    if ! echo "${default_ip}:${default_port}" | grep -Eq "^[0-9]{1,3}(\.[0-9]{1,3}){0,3}(:[0-9]{1,5})?$" ; then
      printf "\e[36m无效的默认值，请检查文件${PROXY_CONF}: \e[7m${default_ip}:${default_port}\e[0m\n"
      return 1
    fi
    #使用默认配置
    export http_proxy="http://${default_ip}:${default_port}"
    export https_proxy="http://${default_ip}:${default_port}"
    printf "\e[36m已设置http/https代理地址: \e[7mhttp://${default_ip}:${default_port}\e[0m\n"
  else
    if ! echo $input | grep -Eq "^[0-9]{1,3}(\.[0-9]{1,3}){0,3}(:[0-9]{1,5})?$" ; then
      printf "\e[36m不合规的输入：\e[7m$input\e[0m\n"
      return 1
    fi
    #input=192.168.120.11:10808
    if [ -z "${default_ip}" ];then
      default_ip=192.168.120.11
    fi
    ip=$(echo "$input" | awk -F: '{print $1}') # 移除端口号
    ip=$(echo "$ip" | sed -E -e "s/^[[:blank:]]*//" -e "s/[[:blank:]]*$//") # trim
    echo "ip=${ip}"
    port=$(echo "$input" | awk -F: '{print (NF>1?$2:"")}') # 获取端口号
    echo "port=${port}"
    dot_count=$(echo $ip | tr -cd "." | wc -m) # 获取ip中.的数量
    case $dot_count in
      0 ) ip=$(echo $default_ip | sed -E "s/(\.[0-9]+){1}$/\.${ip}/")
      ;;
      1 ) ip=$(echo $default_ip | sed -E "s/(\.[0-9]+){2}$/\.${ip}/")
      ;;
      2 ) ip=$(echo $default_ip | sed -E "s/(\.[0-9]+){3}$/\.${ip}/")
      ;;
      3 ) #skip
      ;;
    esac
    if [ -z "${port}" ];then
      port=${default_port}
    fi
    export http_proxy="http://${ip}:${port}"
    export https_proxy="http://${ip}:${port}"
    printf "\e[36m已设置http/https代理地址：\e[7mhttp://${ip}:${port}\e[0m\n"
    #保存配置
    echo "default_ip=${ip}\ndefault_port=${port}" > ${PROXY_CONF}
  fi
}

pof(){
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
  printf  "\e[36m已关闭代理\e[0m\n"
}

```

打开终端时自动激活ros环境的脚本，**暂不推荐使用**，使用powerlevel10k主题时有兼容问题
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

## 终端字体设置

### 字体安装

1. **推荐（等宽字体）：Jetbrains Mono Nerd Font**

    [预览](https://www.programmingfonts.org/#jetbrainsmono)
    [下载](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)

    ![Jetbrains Mono Nerd Font](imgs/docsify20250710232741447.png)
2. MesloLG Nerd Font

    [预览](https://www.programmingfonts.org/#meslo)
    [下载](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip)

<!-- tabs:start -->
#### **Windows**
解压所有ttf字体文件，全选**ttf文件**，右键安装

#### **Linux**

1. 解压所有ttf文件
```bash
unzip -d JetBrainsMono JetBrainsMono.zip
```
2. 创建目录
```bash
sudo mkdir -p /usr/share/fonts/JetBrainsMonoNF
```
3. 将所有ttf文件拷贝到`/usr/share/fonts/JetBrainsMonoNF`目录下（需要使用root权限）

4. 刷新字体缓存
```bash
sudo fc-cache -fv
```

> [!NOTE]
> 一键下载安装JetBrainsMono命令：
> ```bash
> wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip -O > JetBrainsMono.zip
> unzip -d JetBrainsMono JetBrainsMono.zip
> sudo mkdir -p /usr/share/fonts/JetBrainsMonoNF
> sudo cp JetBrainsMono/*.ttf /usr/share/fonts/JetBrainsMonoNF/
> # 刷新字体缓存
> sudo fc-cache -fv
> # 检查是否安装上字体文件
> fc-list | grep JetBrains
> ```

<!-- tabs:end -->

### Vscode集成终端字体配置

在vscode设置中搜索`Font Family`，找到设置项`Terminal>Integrated: Font Family`（仅终端）或`Editor: Font Family`（全局）

在最前面添加`JetBrainsMono Nerd Font, `（不要漏了逗号）
> 字体列表按优先级排列。如果第一个字体不可用，将自动尝试下一个，最后的 monospace是通用字体族名称，用于确保兼容性。

<!-- 或者直接在`settings.json`中添加
```json
"terminal.integrated.fontFamily": "JetBrainsMono Nerd Font, MesloLGM Nerd Font, monospace"

``` -->
![Vscode集成终端配置](imgs/markdownPixPin_2025-06-16_11-00-02.png?image)

### Windows Terminal（终端）配置
在 设置 > 默认值 > 外观 下有字体设置

![Windows Terminal（终端）配置](imgs/markdownPixPin_2025-06-16_10-58-13.png)

输入`JetBrainsMono Nerd Font`或点击输入框后会显示系统所有已安装字体，选择JetBrainsMono Nerd Font即可

