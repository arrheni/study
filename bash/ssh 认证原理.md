# SSH 认证原理

## 中间人攻击

SSH 之所以能够保证安全，原因在于它采用了公钥加密。

整个过程是这样的：

1. 远程主机收到用户的登录请求，把自己的公钥发给用户。
2. 用户使用这个公钥，将登录密码加密后，发送回来。
3. 远程主机用自己的私钥，解密登录密码，如果密码正确，就同意用户登录。

这个过程本身是安全的，但是实施的时候存在一个风险：如果有人截获了登录请求，然后冒充远程主机，将伪造的公钥发给用户，那么用户很难辨别真伪。因为不像 https 协议，SSH 协议的公钥是没有证书中心（CA）公证的，也就是说，都是自己签发的。

可以设想，如果攻击者插在用户与远程主机之间（比如在公共的 wifi 区域），用伪造的公钥，获取用户的登录密码。再用这个密码登录远程主机，那么 SSH 的安全机制就荡然无存了。这种风险就是著名的中间人攻击。

SSH 协议是如何应对的呢？

# SSH 登录方式

SSH 登录方式主要分为两种：

* 用户名密码验证方式

![](//upload-images.jianshu.io/upload_images/7557373-5804a5657cdc65cd.png?imageMogr2/auto-orient/strip|imageView2/2/w/552/format/webp)

说明：

1. 当客户端发起 ssh 请求，服务器会把自己的公钥发送给用户（此时应是明码传送，反正公钥本来就是给大家使用的）；
2. 用户会根据服务器发来的公钥对密码进行加密；
3. 加密后的信息回传给服务器，服务器用自己的私钥解密，如果密码正确，则用户登录成功。

如果你是第一次登录对方主机，系统会出现下面的提示：

这段话的意思是，无法确认 host 主机的真实性，只知道它的公钥指纹，问你还想继续连接吗？

所谓"公钥指纹"，是指公钥长度较长（这里采用 RSA 算法，长达 1024位），很难比对，所以对其进行 MD5 计算，将它变成一个 128 位的指纹。上例中是  `98:2e:d7:e0:de:9f:ac:67:28:c2:42:2d:37:16:58:4d`，再进行比较，就容易多了。

很自然的一个问题就是，用户怎么知道远程主机的公钥指纹应该是多少？回答是没有好办法，远程主机必须在自己的网站上贴出公钥指纹，以便用户自行核对。

假定经过风险衡量以后，用户决定接受这个远程主机的公钥。

系统会出现一句提示，表示host主机已经得到认可。

然后，会要求输入密码。

如果密码正确，就可以登录了。

当远程主机的公钥被接受以后，它就会被保存在文件 `$HOME/.ssh/known_hosts`之中。下次再连接这台主机，系统就会认出它的公钥已经保存在本地了，从而跳过警告部分，直接提示输入密码。

每个 SSH 用户都有自己的 `known_hosts`文件，此外系统也有一个这样的文件，通常是 `/etc/ssh/ssh_known_hosts`，保存一些对所有用户都可信赖的远程主机的公钥。

* 基于密钥的登录方式

![](//upload-images.jianshu.io/upload_images/7557373-683ef370f94ff5cd.png?imageMogr2/auto-orient/strip|imageView2/2/w/780/format/webp)

说明：

1. 首先在客户端生成一对密钥（`ssh-keygen`）；
2. 并将客户端的公钥 `ssh-copy-id` 拷贝到服务端；
3. 当客户端再次发送一个连接请求，包括 ip、用户名；
4. 服务端得到客户端的请求后，会到 `authorized_keys` 中查找，如果有响应的 IP 和用户，就会随机生成一个字符串，例如：qwer；
5. 服务端将使用客户端拷贝过来的公钥进行加密，然后发送给客户端；
6. 得到服务端发来的消息后，客户端会使用私钥进行解密，然后将解密后的字符串发送给服务端；
7. 服务端接受到客户端发来的字符串后，跟之前的字符串进行对比，如果一致，就允许免密码登录。

所谓"公钥登录"，原理很简单，就是用户将自己的公钥储存在远程主机上。登录的时候，远程主机会向用户发送一段随机字符串，用户用自己的私钥加密后，再发回来。远程主机用事先储存的公钥进行解密，如果成功，就证明用户是可信的，直接允许登录 shell，不再要求密码。

这种方法要求用户必须提供自己的公钥。如果没有现成的，可以直接用 `ssh-keygen`生成一个：

运行上面的命令以后，系统会出现一系列提示，可以一路回车。其中有一个问题是，要不要对私钥设置口令（passphrase），如果担心私钥的安全，这里可以设置一个。

运行结束以后，在 `$HOME/.ssh/`目录下，会新生成两个文件：`id_rsa.pub`和 `id_rsa`。前者是你的公钥，后者是你的私钥。

这时再输入下面的命令，将公钥传送到远程主机 host 上面：

好了，从此你再登录，就不需要输入密码了。

# 证书登录的实际应用

1. 客户端生成证书：私钥和公钥，然后私钥放在客户端，妥当保存，一般为了安全，防止有黑客拷贝客户端的私钥，客户端在生成私钥时，会设置一个密码，以后每次登录 ssh 服务器时，客户端都要输入密码解开私钥（如果工作中，你使用了一个没有密码的私钥，有一天服务器被黑了，你是跳到黄河都洗不清）。
2. 服务器添加信用公钥：把客户端生成的公钥，上传到 ssh 服务器，添加到指定的文件中，这样，就完成 ssh 证书登录的配置了。

假设客户端想通过私钥要登录其他 ssh 服务器，同理，可以把公钥上传到其他 ssh 服务器。

* 真实的工作中：

员工生成好私钥和公钥（千万要记得设置私钥密码），然后把公钥发给运维人员，运维人员会登记你的公钥，为你开通一台或者多台服务器的权限，然后员工就可以通过一个私钥，登录他有权限的服务器做系统维护等工作，所以，员工是有责任保护他的私钥的。

作者：杰哥长得帅
链接：https://www.jianshu.com/p/d31de2601368
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
