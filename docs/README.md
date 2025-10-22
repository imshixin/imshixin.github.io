
## 文档编写

使用标准Markdown语法编写文档，所有文档放置在`docs`目录下，图片资源放置到`docs/imgs`下。

添加新文档后需要在`index.md`和`_sidebar.md`中添加新文档的链接

## 特殊语法插件

### [docsify-plugin-flexible-alerts](https://github.com/fzankl/docsify-plugin-flexible-alerts)

语法：
```
> [!NOTE]
> An alert of type 'note' using global style 'callout'.
> [!TIP]
> An alert of type 'tip' using global style 'callout'.
> [!WARNING]
> An alert of type 'warning' using global style 'callout'.
> [!IMPORTANT]
> An alert of type 'important' using global style 'callout'.
> [!ATTENTION]
> An alert of type 'attention' using global style 'callout'.
```
效果：
> [!NOTE]
> An alert of type 'note' using global style 'callout'.

> [!TIP]
> An alert of type 'tip' using global style 'callout'.

> [!WARNING]
> An alert of type 'warning' using global style 'callout'.

> [!IMPORTANT]
> An alert of type 'important' using global style 'callout'.

> [!ATTENTION]
> An alert of type 'attention' using global style 'callout'.

### [docsify-tabs](https://jhildenbiddle.github.io/docsify-tabs/#/)

语法：
```
<!-- tabs:start -->
#### **English**

Hello!

#### **French**

Bonjour!

#### **Italian**

Ciao!

<!-- tabs:end -->
```
效果：
<!-- tabs:start -->

#### **English**

Hello!

#### **French**

Bonjour!

#### **Italian**

Ciao!

<!-- tabs:end -->



### [docsify-termynal](https://github.com/sxin0/docsify-termynal)

语法（把下面的`xxx`替换为`term`）：
````
```xxx
$ php -v
PHP 7.3.23 (cli) (built: Apr 20 2022 15:59:45)
$ pip install fastapi
>> 100%
# Choose an option (y/n)
$ y
// This is a comment
```
````
效果：

```term
$ php -v
PHP 7.3.23 (cli) (built: Apr 20 2022 15:59:45)
$ pip install fastapi
>> 100%
# Choose an option (y/n)
$ y
// This is a comment
```

### [docsify-terminal-block](https://github.com/dolanmiu/docsify-terminal-block)

语法：
````
```terminal
npm run start
$|npm run start
$|warning|npm run build
>|info|npm run start
  |...
>|error|npm run start
>|success|npm run start

warning|npm run build
```
````
效果：
```terminal
npm run start
$|npm run start
$|warning|npm run build
>|info|npm run start
  |...
>|error|npm run start
>|success|npm run start

warning|npm run build
```

## 其他无特殊语法插件：

- [docsify-copy-code](https://github.com/jperasmus/docsify-copy-code)
- [docsify-toc](https://github.com/mrpotatoes/docsify-toc)
- [docsify-updated](https://github.com/pfeak/docsify-updated)
