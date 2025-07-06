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
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface JJRPasswordModifyView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) JJRInputView *oldPasswordInput;
@property (nonatomic, strong) JJRInputView *latestNewPasswordInput;
@property (nonatomic, strong) JJRInputView *confirmPasswordInput;
@property (nonatomic, strong) JJRButton *submitButton;

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
    self.backgroundColor = [UIColor whiteColor];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 原密码输入框
    self.oldPasswordInput = [[JJRInputView alloc] init];
    self.oldPasswordInput.titleLabel.text = @"原密码";
    self.oldPasswordInput.textField.placeholder = @"请输入原密码";
    self.oldPasswordInput.textField.secureTextEntry = YES;
    [self.contentView addSubview:self.oldPasswordInput];
    
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
    [self.submitButton setTitle:@"确认修改" forState:UIControlStateNormal];
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
    
    [self.oldPasswordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(60);
    }];
    
    [self.latestNewPasswordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldPasswordInput.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.oldPasswordInput);
    }];
    
    [self.confirmPasswordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.latestNewPasswordInput.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.oldPasswordInput);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordInput.mas_bottom).offset(40);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)submitButtonTapped {
    if (self.modifyPasswordBlock) {
        self.modifyPasswordBlock(
            self.oldPasswordInput.textField.text,
            self.latestNewPasswordInput.textField.text,
            self.confirmPasswordInput.textField.text
        );
    }
}

@end 
