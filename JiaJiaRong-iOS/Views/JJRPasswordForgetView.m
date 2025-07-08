//
//  JJRPasswordForgetView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRPasswordForgetView.h"
#import "JJRInputView.h"
#import "JJRButton.h"

@interface JJRPasswordForgetView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) JJRInputView *phoneInput;
@property (nonatomic, strong) JJRInputView *codeInput;
@property (nonatomic, strong) JJRInputView *latestNewPasswordInput;
@property (nonatomic, strong) JJRInputView *confirmPasswordInput;
@property (nonatomic, strong) JJRButton *sendCodeButton;
@property (nonatomic, strong) JJRButton *submitButton;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger countdownSeconds;

@end

@implementation JJRPasswordForgetView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 手机号输入框
    self.phoneInput = [[JJRInputView alloc] init];
    self.phoneInput.titleLabel.text = @"手机号";
    self.phoneInput.textField.placeholder = @"请输入手机号";
    self.phoneInput.textField.keyboardType = UIKeyboardTypePhonePad;
    [self.contentView addSubview:self.phoneInput];
    
    // 验证码输入框
    self.codeInput = [[JJRInputView alloc] init];
    self.codeInput.titleLabel.text = @"验证码";
    self.codeInput.textField.placeholder = @"请输入验证码";
    self.codeInput.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.codeInput];
    
    // 发送验证码按钮
    self.sendCodeButton = [[JJRButton alloc] init];
    [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendCodeButton addTarget:self action:@selector(sendCodeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendCodeButton];
    
    // 新密码输入框
    self.latestNewPasswordInput = [[JJRInputView alloc] init];
    self.latestNewPasswordInput.titleLabel.text = @"新密码";
    self.latestNewPasswordInput.textField.placeholder = @"请输入新密码（至少6位）";
    self.latestNewPasswordInput.textField.secureTextEntry = YES;
    [self.contentView addSubview:self.latestNewPasswordInput];
    
    // 确认密码输入框
    self.confirmPasswordInput = [[JJRInputView alloc] init];
    self.confirmPasswordInput.titleLabel.text = @"确认密码";
    self.confirmPasswordInput.textField.placeholder = @"请再次输入新密码";
    self.confirmPasswordInput.textField.secureTextEntry = YES;
    [self.contentView addSubview:self.confirmPasswordInput];
    
    // 提交按钮
    self.submitButton = [[JJRButton alloc] init];
    [self.submitButton setTitle:@"重置密码" forState:UIControlStateNormal];
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
    
    [self.phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(60);
    }];
    
    [self.codeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneInput.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(60);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeInput);
        make.left.equalTo(self.codeInput.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.mas_equalTo(120);
        make.height.equalTo(self.codeInput);
    }];
    
    [self.latestNewPasswordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeInput.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(60);
    }];
    
    [self.confirmPasswordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.latestNewPasswordInput.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.latestNewPasswordInput);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordInput.mas_bottom).offset(40);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)sendCodeButtonTapped {
    if (self.sendCodeBlock) {
        self.sendCodeBlock(self.phoneInput.textField.text);
    }
}

- (void)submitButtonTapped {
    if (self.resetPasswordBlock) {
        self.resetPasswordBlock(
            self.phoneInput.textField.text,
            self.codeInput.textField.text,
            self.latestNewPasswordInput.textField.text,
            self.confirmPasswordInput.textField.text
        );
    }
}

- (void)startCountdown {
    self.countdownSeconds = 60;
    self.sendCodeButton.enabled = NO;
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

- (void)updateCountdown {
    self.countdownSeconds--;
    
    if (self.countdownSeconds <= 0) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        self.sendCodeButton.enabled = YES;
        [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    } else {
        [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%lds", (long)self.countdownSeconds] forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    if (self.countdownTimer) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

@end 
