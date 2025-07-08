//
//  JJRBankCardAddView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBankCardAddView.h"
#import "JJRInputView.h"
#import "JJRButton.h"

@interface JJRBankCardAddView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) JJRInputView *cardNumberInput;
@property (nonatomic, strong) JJRInputView *cardHolderInput;
@property (nonatomic, strong) JJRInputView *idNumberInput;
@property (nonatomic, strong) JJRInputView *phoneInput;
@property (nonatomic, strong) JJRButton *submitButton;

@end

@implementation JJRBankCardAddView

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
    
    // 银行卡号输入框
    self.cardNumberInput = [[JJRInputView alloc] init];
    self.cardNumberInput.titleLabel.text = @"银行卡号";
    self.cardNumberInput.textField.placeholder = @"请输入银行卡号";
    self.cardNumberInput.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.cardNumberInput];
    
    // 持卡人姓名输入框
    self.cardHolderInput = [[JJRInputView alloc] init];
    self.cardHolderInput.titleLabel.text = @"持卡人";
    self.cardHolderInput.textField.placeholder = @"请输入持卡人姓名";
    [self.contentView addSubview:self.cardHolderInput];
    
    // 身份证号输入框
    self.idNumberInput = [[JJRInputView alloc] init];
    self.idNumberInput.titleLabel.text = @"身份证号";
    self.idNumberInput.textField.placeholder = @"请输入身份证号";
    self.idNumberInput.textField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.contentView addSubview:self.idNumberInput];
    
    // 手机号输入框
    self.phoneInput = [[JJRInputView alloc] init];
    self.phoneInput.titleLabel.text = @"手机号";
    self.phoneInput.textField.placeholder = @"请输入手机号";
    self.phoneInput.textField.keyboardType = UIKeyboardTypePhonePad;
    [self.contentView addSubview:self.phoneInput];
    
    // 提交按钮
    self.submitButton = [[JJRButton alloc] init];
    [self.submitButton setTitle:@"添加银行卡" forState:UIControlStateNormal];
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
    
    [self.cardNumberInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(60);
    }];
    
    [self.cardHolderInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardNumberInput.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.cardNumberInput);
    }];
    
    [self.idNumberInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardHolderInput.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.cardNumberInput);
    }];
    
    [self.phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idNumberInput.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.cardNumberInput);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneInput.mas_bottom).offset(40);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)submitButtonTapped {
    if (self.addBankCardBlock) {
        self.addBankCardBlock(
            self.cardNumberInput.textField.text,
            self.cardHolderInput.textField.text,
            self.idNumberInput.textField.text,
            self.phoneInput.textField.text
        );
    }
}

@end 