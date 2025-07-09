//
//  JJRBaseViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseViewController.h"
#import "JJRUserManager.h"
#import "LoginViewController.h"

@interface JJRBaseViewController ()

@end

@implementation JJRBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requiresLogin = YES; // 默认需要登录
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置自定义返回按钮
    [self setupCustomBackButton];
    
    // 监听登录状态变化
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(loginStatusChanged:) 
                                                 name:JJRUserLoginStatusChangedNotification 
                                               object:nil];
}

- (void)setupCustomBackButton {
    // 只有在导航栈中有多个页面时才显示返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        // 创建自定义返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"go_back"] forState:UIControlStateNormal];
        backButton.tintColor = [UIColor blackColor];
        [backButton addTarget:self action:@selector(customBackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置按钮大小
        backButton.frame = CGRectMake(0, 0, 30, 30);
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        // 创建UIBarButtonItem
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
        
        // 隐藏系统默认的返回按钮
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)customBackButtonTapped {
    // 自定义返回逻辑
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 检查登录状态
    [self checkLoginStatus];
    
    // 如果需要登录验证，检查登录状态
    if (self.requiresLogin && ![self checkLoginStatus]) {
        [self navigateToLogin];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 登录验证

- (BOOL)checkLoginStatus {
    BOOL isLoggedIn = [JJRUserManager sharedManager].isLoggedIn;
    NSLog(@"🎯 %@ - 检查登录状态: %@", NSStringFromClass([self class]), isLoggedIn ? @"已登录" : @"未登录");
    return isLoggedIn;
}

- (void)navigateToLogin {
    NSLog(@"🎯 %@ - 跳转到登录页面", NSStringFromClass([self class]));
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    // 设置为全屏模态
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - 通知处理

- (void)loginStatusChanged:(NSNotification *)notification {
    BOOL isLoggedIn = [notification.userInfo[@"isLoggedIn"] boolValue];
    NSLog(@"🎯 %@ - 收到登录状态变化通知: %@", NSStringFromClass([self class]), isLoggedIn ? @"已登录" : @"未登录");
    
    if (self.requiresLogin && !isLoggedIn) {
        // 如果需要登录但用户已登出，跳转到登录页面
        [self navigateToLogin];
    }
}

@end 
