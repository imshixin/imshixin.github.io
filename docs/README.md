# 主页

## ssh配置

### 1. 生成密钥对

```sh
ssh-keygen -t rsa -f <文件保存位置> -C "<密钥的备注>"
```

假设要生成的密钥对文件名为`C:\User\yuy\.ssh\id_rsa_lubancat`（请确保目录已存在），其中`yuy`为你自己电脑的用户名


Windows下：
```bash
ssh-keygen -t rsa -f C:\User\yuy\.ssh\id_rsa_lubancat -C "一些备注"
```
Linux下：
```bash
ssh-keygen -t rsa -f ~/.ssh/id_rsa_lubancat -C "一些备注"
```

命令执行完成后会在指定的目录下生成`id_rsa_lubancat.pub`（公钥）和`id_rsa_lubancat`（私钥），私钥自己留着，公钥需要拷贝到远程服务器上

### 2. 将公钥`.pub`文件拷贝到需要登陆的服务器上

```sh
scp <公钥文件路径> <远程主机用户名>@<远程主机ip地址>:~/.ssh/authorized_keys
```

仍然以`id_rsa_lubancat`举例，远程主机的用户名为`cat`，地址为`192.168.120.3`

- 法1：使用`scp`拷贝


```sh
scp C:\User\yuy\.ssh\id_rsa_lubancat.pub cat@hostip:~/.ssh/authorized_keys
```

- 法2： 手动拷贝上去

登陆上远程主机，使用nano或vim打开文件`~/.ssh/authorized_keys`，将`id_rsa_lubancat.pub`中的内容拷贝进去，并**新建一个空行**（一定要有个空行）

### 3. 开启ssh密钥登陆

在远程主机中，使用你习惯的编辑器编辑`sshd_config`配置文件：`/etc/ssh/sshd_config`

找到这一行
```sh
#PubkeyAuthentication yes
```
改为（解除注释）
```sh
PubkeyAuthentication yes
```

修改后保存，**重启ssh服务**：`sudo systemctl restart sshd`

### 4. 本机ssh配置

打开`C:\User\<你的用户名>\.ssh\config`（不存在就新建）

```ssh_config
Host <远程主机别名>
  User <远程主机用户名>
  HostName <远程主机ip地址>
  IdentityFile <密钥文件路径>

```

举例：
```config
Host lbcat
  User cat
  HostName 192.168.120.3
  IdentityFile C:\User\yuy\.ssh\id_rsa_lubancat
  PreferredAuthentications publickey
```

### 5. 验证登录

使用上一步配置的远程主机别名连接ssh

```sh
ssh <远程主机别名>
```
