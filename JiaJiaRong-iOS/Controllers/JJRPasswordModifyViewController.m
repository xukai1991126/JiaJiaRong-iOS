//
//  JJRPasswordModifyViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRPasswordModifyViewController.h"
#import <YYKit/YYKit.h>
#import "JJRPasswordModifyView.h"
#import "JJRNetworkService.h"
#import "JJRToast.h"
#import "JJRUserManager.h"
#import "ToastTool.h"
#import "LoginViewController.h"
#import <Masonry/Masonry.h>

@interface JJRPasswordModifyViewController ()

@property (nonatomic, strong) JJRPasswordModifyView *passwordModifyView;

@end

@implementation JJRPasswordModifyViewController

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
        [ToastTool showToast:@"请输入手机号" inView:self.view];
        return;
    }
    
    // 验证手机号格式
    NSString *mobileRegex = @"^1[3456789]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    if (![predicate evaluateWithObject:mobile]) {
        [ToastTool showToast:@"请输入正确格式手机号" inView:self.view];
        return;
    }
    
    [JJRNetworkService showLoading];
    
    // 根据uni-app的逻辑，发送验证码参数
    NSDictionary *params = @{
        @"mobile": mobile,
        @"captchaType": @"REPWD"
    };
    
    [[JJRNetworkService sharedInstance] sendCaptchaWithParams:params 
                                                      success:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ToastTool showToast:@"验证码已发送" inView:self.view];
            [self.passwordModifyView startCaptchaCountdown];
        });
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ToastTool showToast:@"验证码发送失败，请重试" inView:self.view];
        });
    }];
}

- (void)updatePassword:(NSString *)mobile 
               captcha:(NSString *)captcha 
           newPassword:(NSString *)newPassword 
       confirmPassword:(NSString *)confirmPassword {
    
    // 参数验证
    if (!mobile || mobile.length != 11) {
        [ToastTool showToast:@"请填写正确的手机号" inView:self.view];
        return;
    }
    
    if (!captcha || captcha.length != 4) {
        [ToastTool showToast:@"请填写正确的验证码" inView:self.view];
        return;
    }
    
    if (!newPassword || newPassword.length == 0) {
        [ToastTool showToast:@"请填写正确的密码" inView:self.view];
        return;
    }
    
    if (!confirmPassword || confirmPassword.length == 0) {
        [ToastTool showToast:@"请再次确认密码" inView:self.view];
        return;
    }
    
    if (![newPassword isEqualToString:confirmPassword]) {
        [ToastTool showToast:@"确认密码请和原密码保持一致" inView:self.view];
        return;
    }
    
    [JJRNetworkService showLoading];
    
    // 根据uni-app的逻辑构建参数
    NSDictionary *params = @{
        @"mobile": mobile,
        @"captcha": captcha,
        @"pwd": newPassword,
        @"checkPwd": confirmPassword
    };
    
    [[JJRNetworkService sharedInstance] updatePasswordWithParams:params 
                                                         success:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ToastTool showToastInKeWindow:@"修改成功"];
            // 修改成功后退出登录
            [self logoutAndBackToLogin];
        });
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ToastTool showToast:@"密码修改失败，请重试" inView:self.view];
        });
    }];
}

- (void)logoutAndBackToLogin {
    // 修改密码成功后，根据uni-app的逻辑退出登录并返回登录页面
    [[JJRNetworkService sharedInstance] logoutWithSuccess:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 清除用户信息
            [[JJRUserManager sharedManager] logout];
            
            // 跳转到登录页面
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            // 获取当前应用的 window
            UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
            UIWindow *window = windowScene.windows.firstObject;
            
            [UIView transitionWithView:window
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                window.rootViewController = navController;
            } completion:nil];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 即使退出登录失败，也要清除本地用户信息并跳转
            [[JJRUserManager sharedManager] logout];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

@end
