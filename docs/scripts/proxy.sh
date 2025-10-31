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
    port=$(echo "$input" | awk -F: '{print (NF>1?$2:"")}') # 获取端口号
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
