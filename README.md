# Touch-ID
iOS Touch ID 指纹解锁

![Touch ID](https://upload-images.jianshu.io/upload_images/728237-385a81acdca1005c.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


>最近公司的 APP 涉及到指纹识别这块，之前没有研究过，现在简单总结下...

###1.基本知识点
````
1.需要导入 #import <LocalAuthentication/LocalAuthentication.h>

2.注意到这两个方法
//是否可以用 Touch ID
- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError * __autoreleasing *)error;

//用Touch ID后，返回的结果，是否成功
- (void)evaluatePolicy:(LAPolicy)policy
localizedReason:(NSString *)localizedReason
reply:(void(^)(BOOL success, NSError * __nullable error))reply;

3.LAError.h（错误的类型）

typedef NS_ENUM(NSInteger, LAError)
{
LAErrorAuthenticationFailed,    // 验证信息出错，就是说你指纹不对
LAErrorUserCancel               // 用户取消了验证
LAErrorUserFallback             // 用户点击了手动输入密码的按钮，所以被取消了
LAErrorSystemCancel             // 被系统取消，就是说你现在进入别的应用了，不在刚刚那个页面，所以没法验证
LAErrorPasscodeNotSet           // 用户没有设置TouchID
LAErrorTouchIDNotAvailable      // 用户设备不支持TouchID
LAErrorTouchIDNotEnrolled       // 用户没有设置手指指纹
LAErrorTouchIDLockout           // 用户错误次数太多，现在被锁住了
LAErrorAppCancel                // 在验证中被其他app中断
LAErrorInvalidContext           // 请求验证出错
} NS_ENUM_AVAILABLE(10_10, 8_0);

4.LAContext 属性

@property (nonatomic, nullable, copy) NSString *localizedFallbackTitle;
@property (nonatomic, nullable, copy) NSString *localizedCancelTitle NS_AVAILABLE(10_12, 10_0);
@property (nonatomic, nullable) NSNumber *maxBiometryFailures NS_DEPRECATED_IOS(8_3, 9_0) __WATCHOS_UNAVAILABLE __TVOS_UNAVAILABLE;
@property (nonatomic, nullable, readonly) NSData *evaluatedPolicyDomainState NS_AVAILABLE(10_11, 9_0) __WATCHOS_UNAVAILABLE __TVOS_UNAVAILABLE;
@property (nonatomic) NSTimeInterval touchIDAuthenticationAllowableReuseDuration NS_AVAILABLE(10_12, 9_0) __WATCHOS_UNAVAILABLE __TVOS_UNAVAILABLE;
@property (nonatomic, copy) NSString *localizedReason API_AVAILABLE(macos(10.13), ios(11.0)) API_UNAVAILABLE(watchos, tvos);


localizedFallbackTitle可以设置验证TouchID时弹出Alert的输入密码按钮的标题
localizedCancelTitle可以设置验证TouchID时弹出Alert的取消按钮的标题(iOS10才有)
maxBiometryFailures 最大指纹尝试错误次数。 这个属性我们可以看到他后面写了NS_DEPRECATED_IOS(8_3, 9_0)，说明这个属性在iOS 8.3被引入，在iOS 9.0被废弃，所以如果系统版本高于9.0是无法使用的。
evalueatedPolicyDomainState这个跟可以检测你的指纹数据库的变化,增加或者删除指纹这个属性会做出相应的反应
touchIDAuthenticationAllowableReuseDuration这个属性应该是类似于支付宝的指纹开启应用，如果你打开他解锁之后，按Home键返回桌面，再次进入支付宝是不需要录入指纹的。因为这个属性可以设置一个时间间隔，在时间间隔内是不需要再次录入。默认是0秒，最长可以设置5分钟。

5.支持机型判断

从设备和系统判断是否是支持TouchID

1.是否是iOS8.0以上的系统
2.是否是5s以上的设备支持

````

###2.代码
````
if([NSString judueIPhonePlatformSupportTouchID]){

LAContext *la = [[LAContext alloc] init];
la.localizedCancelTitle = @"cancel.."; // 自定义 左边 title
la.localizedFallbackTitle = @"fallTitle.."; // 自定义 右边 title

NSError *error;

if([la canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){

[la evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"手机指纹验证..." reply:^(BOOL success, NSError * _Nullable error) {

if(success){

NSLog(@"验证 Success");

}else{
switch (error.code)
{

case LAErrorUserCancel:
//认证被用户取消.例如点击了 cancel 按钮.
NSLog(@"密码取消");
break;

case LAErrorAuthenticationFailed:
// 此处会自动消失，然后下一次弹出的时候，又需要验证数字
// 认证没有成功,因为用户没有成功的提供一个有效的认证资格
NSLog(@"连输三次后，密码失败");
break;

case LAErrorPasscodeNotSet:
// 认证不能开始,因为此台设备没有设置密码.
NSLog(@"密码没有设置");
break;

case LAErrorSystemCancel:
//认证被系统取消了(例如其他的应用程序到前台了)
NSLog(@"系统取消了验证");
break;

case LAErrorUserFallback:
//当输入觉的会有问题的时候输入
NSLog(@"登陆");
break;
case LAErrorTouchIDNotAvailable:
//认证不能开始,因为 touch id 在此台设备尚是无效的.
NSLog(@"touch ID 无效");

default:
NSLog(@"您不能访问私有内容");
break;
}
}
}];

}else{

switch (error.code) {
case LAErrorTouchIDNotEnrolled:
NSLog(@"您还没有进行指纹输入，请指纹设定后打开");
break;
case  LAErrorTouchIDNotAvailable:
NSLog(@"您的设备不支持指纹输入，请切换为数字键盘");
break;
case LAErrorPasscodeNotSet:
NSLog(@"您还没有设置密码输入");
break;
default:
break;
}
}
}

````
完成这篇功能总结，指纹解锁实现起来还是很简单的，苹果都已经封装好了，简单实现几个方法就好。

##[代码](https://github.com/QiuRongGUi/Touch-ID#touch-id)

