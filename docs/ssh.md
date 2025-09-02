# ssh配置
 通过配置ssh以实现免密自动登录和github的ssh登录

 如果有多台本地主机需要连接到同一个远程主机，推荐在远程主机生成密钥对，然后将密钥拷贝到所有本地主机上
## 1. 生成密钥对
```bash
ssh-keygen -t rsa -f <密钥对文件路径> -C "<密钥的备注>"
```
密钥对文件路径包含密钥文件名，Windows推荐保存到`C:\User\<用户名>\.ssh\<密钥名>`, Linux推荐保存到`~/.ssh/<密钥名>`

命令执行完成后会在指定的目录下生成`<密钥文件名>.pub`（公钥）和`<密钥文件名>`（私钥），私钥应保存到本地主机，公钥应保存到远程主机

例如要生成的密钥对文件路径为`~\.ssh\id_rsa_lubancat`（确保目录已存在）
```bash
ssh-keygen -t rsa -f ~/.ssh/id_rsa_lubancat -C "一些备注"
```

## 2. 拷贝公钥到远程主机上

可以使用将本机的公钥拷贝到远程主机上的`~/.ssh/authorized_keys`中：
```sh
scp <公钥文件路径> <远程主机用户名>@<远程主机ip地址>:~/.ssh/authorized_keys
```
例如`scp C:\User\yuy\.ssh\id_rsa_lubancat cat@192.168.120.3:~/.ssh/authorized_keys`

也可以手动复制公钥内容到文件`~/.ssh/authorized_keys`中，
复制的同时**在文件最后新建一个空行**（确保最后一定要有一行空行）

> 如果是在远程主机上生成密钥对，则将密钥（不带`.pub`的同名文件）文件复制到本机的`~/.ssh/`或`C:\Users\<用户名>\.ssh\`目录下，
>
> 若在Windows上手动复制远程主机的密钥文本内容到本机`C:\Users\<用户名>\.ssh\`下，一定要确保换行符为`LF`而不是Windows的`CRLF`

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

打开文件`C:\User\<你的用户名>\.ssh\config`（不存在就新建）

```ssh_config
Host <远程主机别名>
  User <远程主机用户名>
  HostName <远程主机ip地址>
  IdentityFile <密钥文件路径>

```

例如：将主机`cat@192.168.120.3`配置别名`lbcat`并设置密钥登录
```config
Host lbcat
  User cat
  HostName 192.168.120.3
  IdentityFile C:\User\yuy\.ssh\id_rsa_lubancat
  PreferredAuthentications publickey
```
> 关于更多配置项，请参考[文档](https://linux.die.net/man/5/ssh_config)

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

使用`ssh -T git@github.com`测试能否正确连接上github

```terminal
$|info|ssh -T git@github.com
Hi imshixin! You've successfully authenticated, but GitHub does not provide shell access.
```
能够正确识别到用户名且显示`successfully authenticated`说明配置正确
