# ssh配置
 通过配置ssh以实现免密自动登录和github的ssh登录
## 1. 生成密钥对

```bash
ssh-keygen -t rsa -f <密钥对保存位置> -C "<密钥的备注>"
```

例如，要生成的密钥对文件为`C:\User\yuy\.ssh\id_rsa_lubancat`（确保目录已存在）


Windows下：
```bash
ssh-keygen -t rsa -f C:\User\yuy\.ssh\id_rsa_lubancat -C "一些备注"
```
Linux下：
```bash
ssh-keygen -t rsa -f ~/.ssh/id_rsa_lubancat -C "一些备注"
```

命令执行完成后会在指定的目录下生成`id_rsa_lubancat.pub`（公钥）和`id_rsa_lubancat`（私钥），私钥自己留着，公钥需要拷贝到远程服务器上

## 2. 拷贝公钥到远程主机上


将本机的公钥拷贝到远程主机上的`~/.ssh/authorized_keys`中（没有就新建）：
```sh
scp <公钥文件路径> <远程主机用户名>@<远程主机ip地址>:~/.ssh/authorized_keys
```
也可以手动复制公钥内容到文件`~/.ssh/authorized_keys`中，如使用nano或vim打开文件`~/.ssh/authorized_keys`，将公钥文件（`.pub`文件）中的内容拷贝进去，并**新建一个空行**（文件最后一定要有一行空行）

> 如果是在远程主机上生成密钥对，则将密钥（不带`.pub`的同名文件）文件复制到本机的`~/.ssh/`目录下，
>
> 若在Windows上手动复制远程主机的密钥文本内容到本机`~/.ssh/`下，一定要确保换行符为`LF`而不是Windows的`CRLF`，且最后有一行空行

## 3. 远程主机开启ssh密钥登陆

在远程主机中，编辑配置文件：`/etc/ssh/sshd_config`

找到这一行（使用`vim`时可以输入`/Pubkey`来进行查找）
```sh
#PubkeyAuthentication yes
```
改为（解除注释）
```sh
PubkeyAuthentication yes
```

修改后保存，**重启ssh服务**：`sudo systemctl restart sshd`

## 4. 本机ssh配置

打开`C:\User\<你的用户名>\.ssh\config`（不存在就新建）

```ssh_config
Host <远程主机别名>
  User <远程主机用户名>
  HostName <远程主机ip地址>
  IdentityFile <密钥文件路径>

```

举例：将主机`cat@192.168.120.3`配置别名`lbcat`并设置密钥登录
```config
Host lbcat
  User cat
  HostName 192.168.120.3
  IdentityFile C:\User\yuy\.ssh\id_rsa_lubancat
  PreferredAuthentications publickey
```

## 5. 验证登录

使用上一步配置的远程主机别名连接ssh

```sh
ssh <远程主机别名>
```

## (可选) github配置
配置ssh密钥后才可以使用ssh仓库进行push pull（例如`git clone git@github.com:imshixin/imshixin.git`）
### 全局github配置

配置`~/.ssh/config`:
```yaml
Host github.com
  User git
  HostName github.com
  IdentityFile <你的密钥文件路径>
```
例如，先根据上述步骤生成一个密钥对，假设密钥路径为`C:\User\yuy\.ssh\id_rsa_github`

复制公钥`id_rsa_github.pub`的所有内容，打开网页[github ssh and gpg keys](https://github.com/settings/keys)
点击`New SSH Key`, 输入名字和公钥并保存（github上的公钥名字可以随意设定方便区分不同公钥）

配置`C:\User\yuy\.ssh\config`（**注意密钥路径是否正确**）:
```yaml
Host github.com
  User git
  HostName github.com
  IdentityFile C:\User\yuy\.ssh\id_rsa_github
```

测试能否正确连接上github

```sh
PS D:\Documents\docsify> ssh -T git@github.com
Hi imshixin! You've successfully authenticated, but GitHub does not provide shell access.
```
能够正确识别到用户名且显示`successfully authenticated`说明配置正确
