
配置ssh config以实现远程主机免密登录和github的ssh验证

建议在本机生成密钥对再将公钥拷贝到远程主机
## 1. 在本地主机生成密钥对
命令：
```bash
ssh-keygen -t rsa [-f <密钥对文件路径>] [-C "<密钥的备注>"]
```
`-f`和`-C`为可选参数，密钥对文件路径包含密钥文件名，Windows推荐保存到`C:\User\<用户名>\.ssh\<密钥名>`, Linux推荐保存到`~/.ssh/<密钥名>`

例如，要生成的密钥对文件路径为`~/.ssh/id_rsa_lubancat_test`
```terminal
$|success| ssh-keygen -t rsa -f ~/.ssh/id_rsa_lubancat_test -C "这是张三的登录密钥"
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/cat/.ssh/id_rsa_lubancat_test
Your public key has been saved in /home/cat/.ssh/id_rsa_lubancat_test.pub
The key fingerprint is:
SHA256:DUVgIZkNSTnEguNJpaG5p/GlXqQSA/G4j2IOMKP/1tc 这是张三的登录密钥
The key's randomart image is:
+---[RSA 3072]----+
|. .o.+=B++o      |
| *+o. Bo..       |
|=ooo . ..        |
|.oo      o       |
|X . o   S .      |
|o% =             |
|B.= ..   .       |
|=+ .. . . E      |
| .oo.  .         |
+----[SHA256]-----+
$|success| ls ~/.ssh/id_rsa_lubancat_test*
/home/cat/.ssh/id_rsa_lubancat_test  /home/cat/.ssh/id_rsa_lubancat_test.pub
```
在`~/.ssh/`目录下生成了文件`id_rsa_lubancat_test`（密钥）和`id_rsa_lubancat_test.pub`（公钥）。
## 2. 拷贝公钥到远程主机

将生成的`.pub`公钥文件内容追加到远程主机的`~/.ssh/authorized_keys`文件中（没有则手动创建）

如果本机为Linux，或着在windows上打开git bash，则可以使用此命令一键完成配置：
```
ssh-copy-id [-i path/to/you/pub_key.pub] [user@]machine
```
其中`-i path/to/you/pub_key.pub`为可选参数，用于指定要使用的的公钥文件，默认情况下会使用`~/.ssh/id_rsa.pub`

例如：`ssh-copy-id -i C:\User\yuy\.ssh\id_rsa_lubancat_test.pub cat@192.168.120.3`

也可以手动复制公钥内容到远程主机的文件`~/.ssh/authorized_keys`中,
`authorized_keys`**文件末尾需保留空行（此文件必须以换行符结尾，且所有换行符必须是Linux的而不是windows的），否则最后一条密钥可能失效**。

> [!WARNING]
> 注意：authorized_keys文件必须满足以下要求，否则公钥配置可能无法生效：
>
> - ​文件末尾必须有一个空行​​（即最后一行是空的）
>
> - ​换行符必须是 Linux 格式（LF，`\n`）​​，而不是 Windows 格式（CR+LF, `\r\n`）

另外，还可以使用scp拷贝到远程主机中，不过不建议直接覆盖authorized_keys，而是先上传文件，再用`cat`命令将公钥内容追加到authorized_keys中

追加公钥后，远程主机的authorized_keys就会有自己的公钥了：
```terminal
$|success| cat ~/id_rsa_lubancat_test.pub >> ~/.ssh/authorized_keys
$|success| cat ~/.ssh/authorized_keys
......  # 其他人的公钥
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCXPCaRLVsI1t9VVf......jIqEIPEKhzohS5LO7nGh8jzeSuNu8= 这是张三的登录密钥
        # 这是额外的换行
```

<!-- > [!NOTE]
> 如果是在远程主机上生成密钥对，则将密钥（不带`.pub`的同名文件）文件复制到本机的`~/.ssh/`或`C:\Users\<用户名>\.ssh\`目录下，
>
> 若在Windows上手动复制远程主机的密钥文本内容到本机`C:\Users\<用户名>\.ssh\`下，一定要确保换行符为`LF`而不是Windows的`CRLF` -->


## 3. 本机配置SSH连接别名，一键登录远程服务器​

> [!TIP]
> 配置完公钥后，你可以直接使用ssh命令免密登录了：
> ```bash
> ssh -i path/to/your/private_key username@remote_address
> ```
> 其中，`-i`参数指定了身份验证密钥，如果前面配置正确则会直接登录到远程主机


打开文件`C:\User\<你的用户名>\.ssh\config`或`~/.ssh/config`（不存在则新建），添加内容：
```config
Host <远程主机别名>
  User <远程主机用户名>
  HostName <远程主机ip地址>
  IdentityFile <密钥文件路径>

```
关于更多配置项，请参考[ssh_config文档](https://linux.die.net/man/5/ssh_config)，
在Linux下里`~/.ssh/config`的文件权限建议为`600`

例如：将主机`cat@192.168.120.3`配置别名`lbcat`并设置密钥登录
```config
Host lbcat  # 远程主机别名
  User cat  # 要登录的用户名
  HostName 192.168.120.3  # 远程主机地址，可以为ip地址或域名
  IdentityFile C:\User\yuy\.ssh\id_rsa_lubancat_test  # 认证密钥文件
  PreferredAuthentications publickey,password  # 可选，当密钥认证失败时可使用密码登录
```

## 4. 验证登录

使用上一步配置的远程主机别名连接ssh

```sh
ssh <远程主机别名>
```
如果报错：
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions for 'id_rsa_xxx' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
```
说明你的密钥文件权限过大，需要移除对其他人的读写权限：
```bash
chmod 600 ~/.ssh/id_rsa_xxx
```

## github的ssh配置

配置ssh密钥后才可以对ssh私有仓库进行clone push pull（例如`git clone git@github.com:imshixin/imshixin.git`）

步骤：

1. 生成密钥对
2. 复制刚生成的公钥内容，打开网页[github ssh and gpg keys](https://github.com/settings/keys)，
点击`New SSH Key`, 输入名字和公钥并保存（github上的公钥名字可以随意设定方便区分不同公钥）
3. 在本机的~/.ssh/config添加配置
  ```yaml
  Host github.com
      User git
      HostName github.com
      IdentityFile <你的密钥文件路径>
  ```
4. 使用`ssh -T git@github.com`测试能否正确连接上github
```term
$ ssh -T git@github.com
Hi imshixin! You've successfully authenticated, but GitHub does not provide shell access.
```
能够正确识别到用户名且显示`successfully authenticated`说明配置正确
