# 签名算法

- 对所有API请求参数（包括公共参数和业务参数，但除去sign参数和byte[]类型的参数），根据参数名称的[ASCII](http://www.asciima.com/)码表的顺序排序。如：foo=1, bar=2, foo_bar=3, foobar=4排序后的顺序是bar=2, foo=1, foo_bar=3, foobar=4。


- 将排序好的参数名和参数值拼装在一起，根据上面的示例得到的结果为：bar2foo1foo_bar3foobar4。
- 把拼装好的字符串采用utf-8编码，使用签名算法对编码后的字节流进行摘要。如果使用MD5算法，则需要在拼装的字符串前后加上app的secret后，再进行摘要，如：md5(secret+bar2foo1foo_bar3foobar4+secret)；

app_key : 17f233b067464215b47ae45eea9e9fe8

app_security: NhycYKdy7J0QqDXw

# 调用示例

以 taobao.data.wifidevice.list 调用为例，具体步骤如下：

**1. 设置参数值**

公共参数：

- method = "taobao.data.wifidevice.list"
- app_key = "17f233b067464215b47ae45eea9e9fe8"
- ts = "1494671916"

业务参数：

- orderNo = 100000209
- productInfo = "[{"test":1}]"

**2. 按ASCII顺序排序**

- app_key = "17f233b067464215b47ae45eea9e9fe8"
- orderNo = 100000209
- method = "taobao.data.wifidevice.list"
- app_secret = NhycYKdy7J0QqDXw
- ts = "1494671916"
- productInfo = "[{"test":1}]"

**3. 拼接参数名与参数值**

~~~
NhycYKdy7J0QqDXwapp_key17f233b067464215b47ae45eea9e9fe8app_secretNhycYKdy7J0QqDXwmethodtaobao.data.wifidevice.listorderNo100000209productInfo[{"test":1}]ts1494671916NhycYKdy7J0QqDXw
~~~

**4. 生成签名**

~~~
077646973bc192c3292f5e85a4ea2ab8
~~~

签名示例：

~~~shell
curl -X POST 'http://localhost:10985/testsign' \
-H 'Content-Type:application/x-www-form-urlencoded;charset=utf-8' \
-d 'app_key=17f233b067464215b47ae45eea9e9fe8' \
-d 'method=taobao.data.wifidevice.list' \
-d 'sign=077646973bc192c3292f5e85a4ea2ab8' \
-d 'ts=1494671916' \
-d 'orderNo=100000209' \
-d 'productInfo=[{"test":1}]'
~~~

~~~json
{"status":200, "message":"OK"}
~~~

