#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LaunchViewController.h"
#import "LoginViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"🎯 AppDelegate - didFinishLaunchingWithOptions called");
    
    // 初始化键盘管理
    [self setupKeyboardManager];
    
    // 设置根视图控制器
    [self setupRootViewController];
    
    NSLog(@"🎯 AppDelegate - setup completed");
    return YES;
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
    
    // 设置启动页面为根控制器
    LaunchViewController *launchVC = [[LaunchViewController alloc] init];
    self.window.rootViewController = launchVC;
    NSLog(@"🎯 LaunchViewController set as root view controller");
    
    [self.window makeKeyAndVisible];
    NSLog(@"🎯 Window made key and visible");
}

@end 