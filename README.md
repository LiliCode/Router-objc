项目说明
======
> 一个简单的客户端Router。

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
1. 新建一个 Interface_ 开头的接口类文件
2. 定义类方法 + (id)action
3. 在方法的实现中做业务操作

代码示例：
```objc
@interface Interface_user : NSObject

/// app://user/detail?uid=x&name=xxx
+ (id)detail:(NSDictionary *)parameter;
/// app://user/userCenter
+ (id)userCenter;

@end

@implementation Interface_user

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
1. 使用宏定义进行Router
```objc
NSError *error = nil;   // 错误对象
User *u = _ROUTER(@"app://user/detail?name=Lili&uid=2", &error);
if (!error) {
    NSLog(@"user.uid = %lu; user.name=%@", u.uid, u.name);
}
```
2. 使用Router对象进行Router
```objc
NSError *error = nil;   // 错误对象
User *u = [[Router sharedRouter] openURL:[NSURL URLWithString:@"app://user/detail?name=Lili&uid=2"] error:error];
if (!error) {
    NSLog(@"user.uid = %lu; user.name=%@", u.uid, u.name);
}
```