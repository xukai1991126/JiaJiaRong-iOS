#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "JJRUserManager.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AliyunFaceAuthFacade/AliyunFaceAuthFacade.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"🎯 AppDelegate - didFinishLaunchingWithOptions called");
    
    // 初始化阿里云人脸识别SDK（IPv6网络初始化）
    [self initializeAliyunFaceSDK];
    
    // 初始化键盘管理
    [self setupKeyboardManager];
    
    // 设置根视图控制器
    [self setupRootViewController];
    
    NSLog(@"🎯 AppDelegate - setup completed");
    return YES;
}

- (void)initializeAliyunFaceSDK {
    @try {
        // 使用IPv6初始化（推荐方式，符合苹果App Store要求）
        [AliyunFaceAuthFacade initIPv6];
        NSLog(@"🎯 阿里云人脸识别SDK初始化成功（IPv6）");
        NSLog(@"📱 SDK版本: %@", [AliyunFaceAuthFacade getVersion]);
    } @catch (NSException *exception) {
        NSLog(@"❌ 阿里云SDK初始化失败: %@", exception.description);
        
        // 降级到普通初始化
        @try {
            [AliyunFaceAuthFacade initSDK];
            NSLog(@"🎯 降级到普通初始化成功");
        } @catch (NSException *fallbackException) {
            NSLog(@"❌ 普通初始化也失败: %@", fallbackException.description);
        }
    }
}

- (void)setupKeyboardManager {
    NSLog(@"🎯 AppDelegate - setupKeyboardManager called");
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
}

- (void)setupRootViewController {
    NSLog(@"🎯 AppDelegate - setupRootViewController called");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"🎯 Window created with frame: %@", NSStringFromCGRect(self.window.frame));
    [self checkLoginStatusAndSetRootViewController];
    [self.window makeKeyAndVisible];
    NSLog(@"🎯 Window made key and visible");
}

- (void)checkLoginStatusAndSetRootViewController {
    NSLog(@"🎯 AppDelegate - checkLoginStatusAndSetRootViewController called");
    
    // 使用用户管理器检查登录状态
    JJRUserManager *userManager = [JJRUserManager sharedManager];
    NSLog(@"🎯 UserManager状态: %@", userManager);
    
    // 直接检查NSUserDefaults中的值
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *storedUserInfo = [defaults objectForKey:@"JJRUserInfo"];
    NSString *storedUserToken = [defaults objectForKey:@"userToken"];
    NSString *storedChannelToken = [defaults objectForKey:@"token"];
    NSString *storedMobile = [defaults objectForKey:@"mobile"];
    
    NSLog(@"🎯 === 缓存状态检查 ===");
    NSLog(@"🎯 NSUserDefaults中的值:");
    NSLog(@"🎯 - JJRUserInfo: %@", storedUserInfo ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - userToken: %@", storedUserToken ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - channelToken: %@", storedChannelToken ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - mobile: %@", storedMobile ?: @"❌ 无数据");
    
    NSLog(@"🎯 UserManager的属性值:");
    NSLog(@"🎯 - userInfo: %@", userManager.userInfo ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - channelToken: %@", userManager.token ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - mobile: %@", userManager.mobile ?: @"❌ 无数据");
    
    BOOL isLoggedIn = userManager.isLoggedIn;
    NSLog(@"🎯 === 最终登录状态: %@ ===", isLoggedIn ? @"✅ 已登录" : @"❌ 未登录");
    
    if (isLoggedIn) {
        // 已登录，跳转到主页面
        NSLog(@"🎯 User is logged in, navigating to main");
        [self navigateToMain];
    } else {
        // 未登录，跳转到登录页面
        NSLog(@"🎯 User is not logged in, navigating to login");
        [self navigateToLogin];
    }
}

- (void)navigateToMain {
    NSLog(@"🎯 AppDelegate - navigateToMain called");
    MainTabBarController *mainVC = [[MainTabBarController alloc] init];
    self.window.rootViewController = mainVC;
    
    [UIView transitionWithView:self.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

- (void)navigateToLogin {
    NSLog(@"🎯 AppDelegate - navigateToLogin called");
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    // 直接设置根视图控制器，不使用动画
    self.window.rootViewController = navController;
    NSLog(@"🎯 LoginViewController set as root view controller");
}

@end
