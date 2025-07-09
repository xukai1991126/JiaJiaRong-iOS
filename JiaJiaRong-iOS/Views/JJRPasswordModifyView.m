//
//  JJRPasswordModifyView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRPasswordModifyView.h"
#import "JJRInputView.h"
#import "JJRButton.h"
#import "JJRUserManager.h"

@interface JJRPasswordModifyView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) UIButton *sendCaptchaButton;
@property (nonatomic, strong) UITextField *latestNewPasswordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger countdownSeconds;

@end

@implementation JJRPasswordModifyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 大标题 - 对应uni-app的"修改密码"
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"修改密码";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20]; // 40rpx ≈ 20pt
    self.titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.titleLabel];
    
    // 描述文字 - 对应uni-app的"由8-16位数字及字母组成"
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.text = @"由8-16位数字及字母组成";
    self.descLabel.font = [UIFont systemFontOfSize:14]; // 28rpx ≈ 14pt
    self.descLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.descLabel];
    
    // 手机号输入框 - 不可编辑
    self.mobileTextField = [[UITextField alloc] init];
    self.mobileTextField.text = [[JJRUserManager sharedManager] mobile];
    self.mobileTextField.font = [UIFont systemFontOfSize:14];
    self.mobileTextField.placeholder = [[JJRUserManager sharedManager] mobile].length ? nil : @"请输入手机号";
    self.mobileTextField.enabled = [[JJRUserManager sharedManager] mobile].length ? NO : YES; // 不可编辑
    self.mobileTextField.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.mobileTextField.layer.cornerRadius = 6;
    self.mobileTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.mobileTextField];
    
    // 验证码输入框
    self.captchaTextField = [[UITextField alloc] init];
    self.captchaTextField.placeholder = @"请输入验证码";
    self.captchaTextField.font = [UIFont systemFontOfSize:14];
    self.captchaTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.captchaTextField.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.captchaTextField.layer.cornerRadius = 6;
    self.captchaTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.captchaTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.captchaTextField];
    
    // 获取验证码按钮
    self.sendCaptchaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendCaptchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendCaptchaButton setTitleColor:[UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.sendCaptchaButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.sendCaptchaButton addTarget:self action:@selector(sendCaptchaButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendCaptchaButton];
    
    // 新密码输入框
    self.latestNewPasswordTextField = [[UITextField alloc] init];
    self.latestNewPasswordTextField.placeholder = @"请输入新密码";
    self.latestNewPasswordTextField.font = [UIFont systemFontOfSize:14];
    self.latestNewPasswordTextField.secureTextEntry = YES;
    self.latestNewPasswordTextField.backgroundColor =[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.latestNewPasswordTextField.layer.cornerRadius = 6;
    self.latestNewPasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.latestNewPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.latestNewPasswordTextField];
    
    // 确认密码输入框
    self.confirmPasswordTextField = [[UITextField alloc] init];
    self.confirmPasswordTextField.placeholder = @"请再次输入新密码";
    self.confirmPasswordTextField.font = [UIFont systemFontOfSize:14];
    self.confirmPasswordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.confirmPasswordTextField.layer.cornerRadius = 6;
    self.confirmPasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.confirmPasswordTextField];
    
    // 提交按钮 - 对应uni-app的"确认提交"
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:14]; // 28rpx ≈ 14pt
    self.submitButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"]; // #3B4FDE
    self.submitButton.layer.cornerRadius = 23;
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.submitButton];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 标题 - 距离顶部30rpx ≈ 15pt
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15); // 30rpx ≈ 15pt
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    // 描述文字 - 距离标题20rpx ≈ 10pt
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    // 手机号输入框
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(46);
    }];
    
    // 验证码输入框
    [self.captchaTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileTextField.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(46);
    }];
    
    // 获取验证码按钮
    [self.sendCaptchaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.captchaTextField);
        make.left.equalTo(self.captchaTextField.mas_right).offset(10);
        make.right.equalTo(self.titleLabel);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    // 新密码输入框
    [self.latestNewPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.captchaTextField.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.mobileTextField);
    }];
    
    // 确认密码输入框
    [self.confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.latestNewPasswordTextField.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.mobileTextField);
    }];
    
    // 提交按钮
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordTextField.mas_bottom).offset(10);
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(46);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

#pragma mark - Public Methods

- (void)setMobile:(NSString *)mobile {
    self.mobileTextField.text = mobile;
}

- (void)startCaptchaCountdown {
    self.countdownSeconds = 60;
    self.sendCaptchaButton.enabled = NO;
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                           target:self 
                                                         selector:@selector(updateCountdown) 
                                                         userInfo:nil 
                                                          repeats:YES];
}

#pragma mark - Private Methods

- (void)updateCountdown {
    self.countdownSeconds--;
    
    if (self.countdownSeconds <= 0) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        self.sendCaptchaButton.enabled = YES;
        [self.sendCaptchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        [self.sendCaptchaButton setTitle:[NSString stringWithFormat:@"%lds", (long)self.countdownSeconds] forState:UIControlStateNormal];
    }
}

- (void)sendCaptchaButtonTapped {
    if (self.sendCaptchaBlock) {
        self.sendCaptchaBlock(self.mobileTextField.text);
    }
}

- (void)submitButtonTapped {
    if (self.passwordUpdateBlock) {
        self.passwordUpdateBlock(
            self.mobileTextField.text,
            self.captchaTextField.text,
            self.latestNewPasswordTextField.text,
            self.confirmPasswordTextField.text
        );
    }
}

- (void)dealloc {
    if (self.countdownTimer) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

@end 
