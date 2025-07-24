# Windows开启NTP服务器

参考：https://www.cnblogs.com/pipci/p/14672772.html

1. 编辑注册表

    新建文件`ntp.reg`，输入
    ```
    Windows Registry Editor Version 5.00

    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer]
    "Enabled"=dword:00000001

    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config]
    "AnnounceFlags"=dword:00000005
    ```
    保存后左键双击执行此文件导入注册表

2. 开启ntp服务自启动

    <kbd>Win</kbd>+<kbd>R</kbd>弹出运行窗口输入`services.msc`，点击确定，找到`Windows Time`服务并启动此服务，右键此服务->属性，启动类型设置为`自动`

3. 重启服务

    打开命令行，执行`net stop w32time`和`net start w32time`

4. 验证

    打开命令行，执行`w32tm /stripchart /computer:127.0.0.1`，有正常时间回显说明开启成功

5. 关闭防火墙

    - 打开高级防火墙设置：打开控制面板--->系统和安全--->windows防火墙--->高级设置（或<kbd>Win</kbd>+<kbd>R</kbd>弹出运行窗口输入`wf.msc`，点击确定）

    - 新建规则：（左边栏）入站规则--->（右边栏）新建规则---> 端口 ---下一步----UDP----特定本地端口：123，其他保持默认，名称输入ntp后保存

