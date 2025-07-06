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

#import <Masonry/Masonry.h>
@interface JJRPasswordModifyViewController ()

@property (nonatomic, strong) JJRPasswordModifyView *passwordModifyView;

@end

@implementation JJRPasswordModifyViewController

- (void)viewDidLoad {
    @weakify(self);
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.passwordModifyView = [[JJRPasswordModifyView alloc] init];
    [self.view addSubview:self.passwordModifyView];
    
    __weak typeof(self) weakSelf = self;
    self.passwordModifyView.modifyPasswordBlock = ^(NSString *oldPassword, NSString *newPassword, NSString *confirmPassword) {
        [weakSelf modifyPassword:oldPassword newPassword:newPassword confirmPassword:confirmPassword];
    };
}

- (void)setupConstraints {
    [self.passwordModifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)modifyPassword:(NSString *)oldPassword 
           newPassword:(NSString *)newPassword 
       confirmPassword:(NSString *)confirmPassword {
    
    if (!oldPassword || oldPassword.length == 0) {
        [JJRToast showToast:@"请输入原密码"];
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
        @"oldPassword": oldPassword,
        @"newPassword": newPassword
    };
    
    [[JJRNetworkService sharedInstance] modifyPasswordWithParams:params success:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:@"密码修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:error.localizedDescription];
    }];
}

@end
