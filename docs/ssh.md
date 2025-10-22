
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
$|info| ssh-keygen -t rsa -f ~/.ssh/id_rsa_lubancat_test -C "一些备注"
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/cat/.ssh/id_rsa_lubancat_test
Your public key has been saved in /home/cat/.ssh/id_rsa_lubancat_test.pub
The key fingerprint is:
SHA256:DUVgIZkNSTnEguNJpaG5p/GlXqQSA/G4j2IOMKP/1tc 一些备注
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
$|info| ls ~/.ssh/id_rsa_lubancat_test*
/home/cat/.ssh/id_rsa_lubancat_test  /home/cat/.ssh/id_rsa_lubancat_test.pub
```
在`~/.ssh/`目录下生成了文件`id_rsa_lubancat_test`（密钥）和`id_rsa_lubancat_test.pub`（公钥）。
## 2. 拷贝公钥到远程主机

将生成的公钥文件内容追加到远程主机的`~/.ssh/authorized_keys`文件中（没有则手动创建）

如果本机为Linux，或着windows上打开git bash终端，则可以使用命令
```
ssh-copy-id [-i [identity_file]] [user@]machine
```

例如：`ssh-copy-id -i C:\User\yuy\.ssh\id_rsa_lubancat.pub cat@192.168.120.3`

也可以手动复制公钥内容到远程主机的文件`~/.ssh/authorized_keys`中,
`authorized_keys`**文件末尾需保留空行**，否则最后一条密钥可能失效。

还可以使用scp拷贝公钥到远程主机中，不过不建议直接覆盖authorized_keys，而是先上传文件，再用`cat`命令将公钥内容追加到authorized_keys中

<!-- > [!NOTE]
> 如果是在远程主机上生成密钥对，则将密钥（不带`.pub`的同名文件）文件复制到本机的`~/.ssh/`或`C:\Users\<用户名>\.ssh\`目录下，
>
> 若在Windows上手动复制远程主机的密钥文本内容到本机`C:\Users\<用户名>\.ssh\`下，一定要确保换行符为`LF`而不是Windows的`CRLF` -->

## 3. 本机ssh配置

打开文件`C:\User\<你的用户名>\.ssh\config`或`~/.ssh/config`（不存在则新建），添加内容：

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
  PreferredAuthentications publickey,password
```
> [!NOTE]- 更多配置
> 关于更多配置项，请参考[文档](https://linux.die.net/man/5/ssh_config)

## 4. 验证登录

使用上一步配置的远程主机别名连接ssh

```sh
ssh <远程主机别名>
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
