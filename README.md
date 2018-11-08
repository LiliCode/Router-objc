项目说明
======
> 一个简单的客户端Router。

安装方法
------
1. CocoaPods
```Ruby
pod 'Router', :git => 'https://github.com/LiliCode/Router-objc.git'
```
2. 手动安装，项目下载下来之后，将Router文件夹一起放入到你的工程中

Router链接规范
------
示例链接：
> app://user/detail?uid=1

链接构成解释：
> scheme://className/methodName?key=value
- scheme: 自定义协议，或其他标准协议名称，比如：http、https
- className: 需要访问的类名称或者接口类名称
- methodName: 接口类中的方法
- key value: 参数，和标准http链接一样

使用前准备
------
1. 新建一个 Target_ 开头的接口类文件
2. 定义类方法 + (id)action
3. 在方法的实现中做业务操作

代码示例：
```objc
@interface Target_user : NSObject

/// app://user/detail?uid=x&name=xxx
+ (id)detail:(NSDictionary *)parameter;
/// app://user/userCenter
+ (id)userCenter;

@end

@implementation Target_user

+ (id)detail:(NSDictionary *)parameter {
    // 在这里创建要调用的类并返回
    // 比如调用一个Controller, 就在这里创建一个Controller实例并返回
    User *u = [User new];
    u.uid = [parameter[@"uid"] integerValue];
    u.name = parameter[@"name"];
    
    return u;
}

+ (id)userCenter {
    return [User new];
}

@end
```
基于以上示例也可以直接访问一个类获取对象，原理同上。

Router使用方法
------
1. 使用前需要通过Scheme注册Connector
```objc
// 创建连接器
HTTPConnector *httpConnector = [[HTTPConnector alloc] init];
httpConnector.webControllerClass = [WebController class];    // 设置打开网页的控制器
NativeConnector *nativeConnector = [[NativeConnector alloc] init];
// 注册连接器
[[Router sharedRouter] registerConnector:httpConnector forScheme:@"http"];  // 注册http
[[Router sharedRouter] registerConnector:httpConnector forScheme:@"https"]; // 注册https
[[Router sharedRouter] registerConnector:nativeConnector forScheme:@"app"]; // 注册自定义链接Scheme, app 就是下文中自定义链接的URL中的Scheme
```
2. 使用宏定义进行路由查找
```objc
NSError *error = nil;   // 错误对象
User *u = _ROUTER(@"app://user/detail?name=Lili&uid=2", &error);
if (!error) {
    NSLog(@"user.uid = %lu; user.name=%@", u.uid, u.name);
}
```
3. 使用Router对象进行路由查找
```objc
NSError *error = nil;   // 错误对象
User *u = [[Router sharedRouter] openURL:[NSURL URLWithString:@"app://user/detail?name=Lili&uid=2"] error:error];
if (!error) {
    NSLog(@"user.uid = %lu; user.name=%@", u.uid, u.name);
}
```
4. 自定义Connector连接器（如果你觉得这里面提供的 HTTPConnector、NativeConnector 不符合你的要求，你也可以按照自己的业务需求自定义）

创建一个继承自NSObject的类，遵循 URLConnector 协议并实现协议中的方法
```objc
@interface TestConnector : NSObject<URLConnector>

@end
```
```objc
@implementation TestConnector

- (BOOL)willPerformURL:(NSURL *)URLObject {
    // 在这里做URL拦截处理，判断是否允许URL进行路由
    
    return YES;
}

- (id)performURL:(NSURL *)URLObject error:(NSError * _Nullable __autoreleasing *)error {
    // URL路由逻辑，可以参考 HTTPConnector、NativeConnector
    
    return nil;
}

@end
```
然后在使用这个自定义Connector之前先注册
```objc
TestConnector *connector = [[TestConnector alloc] init];
[[Router sharedRouter] registerConnector:connector forScheme:@"test"];
```