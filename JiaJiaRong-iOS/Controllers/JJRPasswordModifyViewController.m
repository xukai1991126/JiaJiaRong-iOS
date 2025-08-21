//
//  JJRPasswordModifyViewController.m
//  JiaJiaRong-iOS
//
//  Created by json on 2025/7/5.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRPasswordModifyViewController.h"
#import <YYKit/YYKit.h>
#import "JJRPasswordModifyView.h"
#import "JJRNetworkService.h"
#import "JJRUserManager.h"
#import "LoginViewController.h"

@interface JJRPasswordModifyViewController ()

@property (nonatomic, strong) JJRPasswordModifyView *passwordModifyView;

@end

@implementation JJRPasswordModifyViewController

- (BOOL)requiresLogin {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
    [self loadUserMobile];
}

- (void)setupUI {
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    
    self.passwordModifyView = [[JJRPasswordModifyView alloc] init];
    [self.view addSubview:self.passwordModifyView];
    
    __weak typeof(self) weakSelf = self;
    // 发送验证码回调
    self.passwordModifyView.sendCaptchaBlock = ^(NSString *mobile) {
        [weakSelf sendCaptcha:mobile];
    };
    
    // 更新密码回调
    self.passwordModifyView.passwordUpdateBlock = ^(NSString *mobile, NSString *captcha, NSString *newPassword, NSString *confirmPassword) {
        [weakSelf updatePassword:mobile captcha:captcha newPassword:newPassword confirmPassword:confirmPassword];
    };
}

- (void)setupConstraints {
    [self.passwordModifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadUserMobile {
    // 从用户信息中获取手机号
    NSDictionary *userInfo = [JJRUserManager sharedManager].userInfo;
    NSString *mobile = userInfo[@"mobile"];
    if (mobile && mobile.length > 0) {
        [self.passwordModifyView setMobile:mobile];
    }
}

#pragma mark - Private Methods

- (void)sendCaptcha:(NSString *)mobile {
    if (!mobile || mobile.length == 0) {
        [JJRToastTool showToast:@"请输入手机号" inView:self.view];
        return;
    }
    
    // 验证手机号格式
    NSString *mobileRegex = @"^1[3456789]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    if (![predicate evaluateWithObject:mobile]) {
        [JJRToastTool showToast:@"请输入正确格式手机号" inView:self.view];
        return;
    }
    
    [JJRNetworkService showLoading];
    
    // 加密手机号
    NSString *encryptedMobile = [JJRNetworkService encryptMobile:mobile];
    NSString *md5Mobile = [JJRNetworkService encryptMobileMd5:mobile];
    
    // 根据uni-app的逻辑，发送验证码参数
    NSDictionary *params = @{
        @"mobile": encryptedMobile,
        @"captchaType": @"REPWD",
        @"md5":md5Mobile
    };
    
    [[JJRNetworkService sharedInstance] sendCaptchaWithParams:params 
                                                      success:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [JJRToastTool showToast:@"验证码已发送" inView:self.view];
            [self.passwordModifyView startCaptchaCountdown];
        });
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorMessage = error.localizedDescription;
            if (!errorMessage || errorMessage.length == 0) {
                errorMessage = @"验证码发送失败，请重试";
            }
            [JJRToastTool showToast:errorMessage inView:self.view];
        });
    }];
}


- (void)updatePassword:(NSString *)mobile 
               captcha:(NSString *)captcha 
           newPassword:(NSString *)newPassword 
       confirmPassword:(NSString *)confirmPassword {
    
    // 参数验证
    if (!mobile || mobile.length != 11) {
        [JJRToastTool showToast:@"请填写正确的手机号" inView:self.view];
        return;
    }
    
    if (!captcha || captcha.length != 4) {
        [JJRToastTool showToast:@"请填写正确的验证码" inView:self.view];
        return;
    }
    
    if (!newPassword || newPassword.length == 0) {
        [JJRToastTool showToast:@"请填写正确的密码" inView:self.view];
        return;
    }
    
    // 密码格式验证：8-16位数字及字母组成
    if (newPassword.length < 8 || newPassword.length > 16) {
        [JJRToastTool showToast:@"密码长度必须为8-16位" inView:self.view];
        return;
    }
    
    // 检查密码是否包含数字和字母
    NSString *passwordRegex = @"^(?=.*\\d)(?=.*[a-zA-Z])[a-zA-Z\\d]{8,16}$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    if (![passwordPredicate evaluateWithObject:newPassword]) {
        [JJRToastTool showToast:@"密码必须由8-16位数字及字母组成" inView:self.view];
        return;
    }
    
    if (!confirmPassword || confirmPassword.length == 0) {
        [JJRToastTool showToast:@"请再次确认密码" inView:self.view];
        return;
    }
    
    if (![newPassword isEqualToString:confirmPassword]) {
        [JJRToastTool showToast:@"确认密码请和原密码保持一致" inView:self.view];
        return;
    }
    
    [JJRNetworkService showLoading];
    
    // 加密手机号
    NSString *encryptedMobile = [JJRNetworkService encryptMobile:mobile];
    NSString *md5Mobile = [JJRNetworkService encryptMobileMd5:mobile];
    
    // 根据uni-app的逻辑构建参数
    NSDictionary *params = @{
        @"mobile": encryptedMobile,
        @"captcha": captcha,
        @"pwd": newPassword,
        @"checkPwd": confirmPassword,
        @"md5": md5Mobile
    };
    
    [[JJRNetworkService sharedInstance] updatePasswordWithParams:params 
                                                         success:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [JJRToastTool showToastInKeWindow:@"修改成功"];
            // 修改成功后退出登录
            [self logoutAndBackToLogin];
        });
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorMessage = error.localizedDescription;
            if (!errorMessage || errorMessage.length == 0) {
                errorMessage = @"密码修改失败，请重试";
            }
            [JJRToastTool showToast:errorMessage inView:self.view];
        });
    }];
}

- (void)logoutAndBackToLogin {
    // 修改密码成功后，根据uni-app的逻辑退出登录并返回登录页面
    [[JJRNetworkService sharedInstance] logoutWithSuccess:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 清除用户信息
            [[JJRUserManager sharedManager] logout];
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            [self navigateToLogin];
            
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 即使退出登录失败，也要清除本地用户信息并跳转
            [[JJRUserManager sharedManager] logout];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

// 跳转到登录页面
- (void)navigateToLogin {
    // 获取当前应用的主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // iOS 13及以上版本的处理
    if (!keyWindow) {
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    keyWindow = windowScene.windows.firstObject;
                    break;
                }
            }
        }
    }
    
    if (keyWindow) {
        // 导入LoginViewController
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        navController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        // 设置为根视图控制器
        keyWindow.rootViewController = navController;
        [keyWindow makeKeyAndVisible];
        
        NSLog(@"🎯 已跳转到登录页面");
    } else {
        NSLog(@"⚠️ 无法获取主窗口，跳转登录页面失败");
    }
}


@end
