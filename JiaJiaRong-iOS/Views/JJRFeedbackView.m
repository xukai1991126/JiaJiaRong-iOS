//
//  JJRFeedbackView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRFeedbackView.h"
#import "JJRInputView.h"
#import "JJRButton.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface JJRFeedbackView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) JJRInputView *contactInput;
@property (nonatomic, strong) JJRButton *submitButton;

@end

@implementation JJRFeedbackView

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
    
    // 反馈内容标签
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = @"反馈内容";
    self.contentLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:self.contentLabel];
    
    // 反馈内容输入框
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.font = [UIFont systemFontOfSize:16];
    self.contentTextView.textColor = [UIColor colorWithHexString:@"#333333"];
    self.contentTextView.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    self.contentTextView.layer.borderWidth = 1.0;
    self.contentTextView.layer.cornerRadius = 8.0;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);
    [self.contentView addSubview:self.contentTextView];
    
    // 联系方式标签
    self.contactLabel = [[UILabel alloc] init];
    self.contactLabel.text = @"联系方式（选填）";
    self.contactLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.contactLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:self.contactLabel];
    
    // 联系方式输入框
    self.contactInput = [[JJRInputView alloc] init];
    self.contactInput.titleLabel.text = @"";
    self.contactInput.textField.placeholder = @"请输入手机号或邮箱";
    [self.contentView addSubview:self.contactInput];
    
    // 提交按钮
    self.submitButton = [[JJRButton alloc] init];
    [self.submitButton setTitle:@"提交反馈" forState:UIControlStateNormal];
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
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(24);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(120);
    }];
    
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(24);
    }];
    
    [self.contactInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(60);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactInput.mas_bottom).offset(40);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)submitButtonTapped {
    if (self.submitFeedbackBlock) {
        self.submitFeedbackBlock(self.contentTextView.text, self.contactInput.textField.text);
    }
}

@end 