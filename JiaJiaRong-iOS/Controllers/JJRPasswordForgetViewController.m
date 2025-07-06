//
//  JJRPasswordForgetViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRPasswordForgetViewController.h"
#import <YYKit/YYKit.h>
#import "JJRPasswordForgetView.h"
#import "JJRNetworkService.h"
#import "JJRToast.h"
#import <Masonry/Masonry.h>

@interface JJRPasswordForgetViewController ()

@property (nonatomic, strong) JJRPasswordForgetView *passwordForgetView;

@end

@implementation JJRPasswordForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.passwordForgetView = [[JJRPasswordForgetView alloc] init];
    [self.view addSubview:self.passwordForgetView];
    
    __weak typeof(self) weakSelf = self;
    self.passwordForgetView.sendCodeBlock = ^(NSString *phone) {
        [weakSelf sendVerificationCode:phone];
    };
    
    self.passwordForgetView.resetPasswordBlock = ^(NSString *phone, NSString *code, NSString *newPassword, NSString *confirmPassword) {
        [weakSelf resetPassword:phone code:code newPassword:newPassword confirmPassword:confirmPassword];
    };
}

- (void)setupConstraints {
    [self.passwordForgetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)sendVerificationCode:(NSString *)phone {
    if (!phone || phone.length == 0) {
        [JJRToast showToast:@"请输入手机号"];
        return;
    }
    
    if (phone.length != 11) {
        [JJRToast showToast:@"请输入正确的手机号"];
        return;
    }
    
    [JJRNetworkService showLoading];
    
    NSDictionary *params = @{
        @"phone": phone,
        @"type": @"reset_password"
    };
    
    [[JJRNetworkService sharedInstance] sendCaptchaWithType:@"REPWD" mobile:[JJRNetworkService encryptMobile:phone] md5:[JJRNetworkService encryptMobileMd5:phone] success:^(id responseObject) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:@"验证码发送成功"];
        [self.passwordForgetView startCountdown];
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:error.localizedDescription];
    }];
}

- (void)resetPassword:(NSString *)phone 
                 code:(NSString *)code 
          newPassword:(NSString *)newPassword 
      confirmPassword:(NSString *)confirmPassword {
    
    if (!phone || phone.length == 0) {
        [JJRToast showToast:@"请输入手机号"];
        return;
    }
    
    if (!code || code.length == 0) {
        [JJRToast showToast:@"请输入验证码"];
        return;
    }
    
    if (!newPassword || newPassword.length == 0) {
        [JJRToast showToast:@"请输入新密码"];
        return;
    }
    
    if (newPassword.length < 6) {
        [JJRToast showToast:@"新密码长度不能少于6位"];
        return;
    }
    
    if (![newPassword isEqualToString:confirmPassword]) {
        [JJRToast showToast:@"两次输入的密码不一致"];
        return;
    }
    
    [JJRNetworkService showLoading];
    
    NSDictionary *params = @{
        @"phone": phone,
        @"code": code,
        @"newPassword": newPassword
    };
    
    [[JJRNetworkService sharedInstance] forgetPasswordWithParams:params success:^(id responseObject) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:@"密码重置成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:error.localizedDescription];
    }];
}

@end 
