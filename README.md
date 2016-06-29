#简介
在这个小代码库是基于[AFNetworking](https://github.com/AFNetworking/AFNetworking) 只上的封装，要求iOS7或以上。
```
1. 可以全局设置错误码对应的错误消息（很方便的更改服务器返回的错误信息，一个地方设置，全局使用）;
2. 可以全局设置错误码对应的执行代码块，比如服务器返回401错误码，可以弹出登录框，或者自动做登录操作。
```
#安装
- <strong>用pod安装</strong><br>
pod 'SSNetwork', :git => 'https://github.com/sususu/SSNetwork.git'
- <strong>直接安装</strong><br>
直接下载源码，拖进项目即可

#使用
###服务器数据结构
默认服务器返回的数据结构是<br>
```javascript
{code:'integer', msg:'string', data:'object'}
```
如果服务器返回的不是这样子，需要进行转换<br>
继承SSResponse，实现协议的两个方法
```objective-c
@protocol SSResponseInterface <NSObject>
@required
+ (SSResponse *) responseWithObject:(id)object;
+ (SSResponse *) responseWithError:(NSError *)error;
@end
```
在这两个方法内把服务器返回的数据，转化成上面需要的结构。<br>
然后将你自己所写的类，注册到SSRequest中
```objective-c
[SSRequest registerResponseClass:[MResponse class]];
```
###配置网络请求
1、配置API接口的基本路径：<br>
```objective-c
[SSRequestConfig setApiBasePath:@"http://192.168.1.10:8088/"];
```
2、设置API传值的方式（*如果不是Restful API，一般不需要配置下面这个*）：<br>
```objective-c
[SSRequestConfig setContentType:@"application/json"];
```
3、改变服务器返回消息：<br>
```objective-c
[[SSErrorCodeManager shared] setMsg:@"如果response中的code等于0的时候，response的msg会替换成这个" forCode:0];
```
4、在返回某个特定code时，执行一段代码块
```objective-c
[[SSErrorCodeManager shared] setHandler:^BOOL(SSResponse *response) {
NSLog(@"返回code等于0时，会执行这个代码啊");
//如果返回YES，则之前的请求，会重新执行一次。
return NO;
} forCode:0];
```
###创建一个HTTP请求
```objective-c
SSRequest *request = [SSRequest requestWithUrl:@"/api/channel/list"];
```
发送请求<br>
```objective-c
[request sendWithCallback:^(SSResponse *response) {
NSLog(@"请求成功之后，返回了啊:%@", response.msg);
}];
```