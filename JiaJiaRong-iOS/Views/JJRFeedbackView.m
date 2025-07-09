//
//  JJRFeedbackView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRFeedbackView.h"
#import <objc/runtime.h>

@interface JJRFeedbackView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *submitButton;

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
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"我们期待您的反馈";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16]; // 32rpx -> 16pt
    self.titleLabel.textColor = [UIColor colorWithRed:0.102 green:0.102 blue:0.102 alpha:1.0]; // #1A1A1A
    [self addSubview:self.titleLabel];
    
    // 描述
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.text = @"请详细描述您的问题或建议，我们将及时跟进解决。";
    self.descLabel.font = [UIFont systemFontOfSize:13]; // 26rpx -> 13pt
    self.descLabel.textColor = [UIColor colorWithRed:0.102 green:0.102 blue:0.102 alpha:1.0]; // #1A1A1A
    self.descLabel.numberOfLines = 0;
    [self addSubview:self.descLabel];
    
    // 输入框
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = [UIColor colorWithRed:0.102 green:0.102 blue:0.102 alpha:1.0]; // #1A1A1A
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.borderColor = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1.0].CGColor; // #E5E5E5
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 4.0;
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // 添加placeholder
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = @"请输入内容";
    placeholderLabel.font = [UIFont systemFontOfSize:15];
    placeholderLabel.textColor = [UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1.0]; // #B3B3B3
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.userInteractionEnabled = NO;
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textView addSubview:placeholderLabel];
    
    // 设置placeholder约束
    [NSLayoutConstraint activateConstraints:@[
        [placeholderLabel.topAnchor constraintEqualToAnchor:self.textView.topAnchor constant:10],
        [placeholderLabel.leadingAnchor constraintEqualToAnchor:self.textView.leadingAnchor constant:15],
        [placeholderLabel.trailingAnchor constraintEqualToAnchor:self.textView.trailingAnchor constant:-15],
    ]];
    
    // 监听textView变化来控制placeholder显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
    
    // 保存placeholder的引用
    objc_setAssociatedObject(self.textView, @"placeholderLabel", placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:self.textView];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    self.submitButton.backgroundColor =[UIColor colorWithHexString:@"#FF772C"]; // 使用正确的蓝色
    self.submitButton.layer.cornerRadius = 23.0;
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(15); // 30rpx -> 15pt
        make.left.equalTo(self).offset(15); // 30rpx -> 15pt
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10); // 20rpx -> 10pt
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(100); // 与uni-app一致
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-15); // 30rpx -> 15pt
        make.left.equalTo(self).offset(20); // 32rpx -> 16pt
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(46); // 98rpx -> 49pt
    }];
}

- (void)textViewDidChange:(NSNotification *)notification {
    UITextView *textView = notification.object;
    UILabel *placeholderLabel = objc_getAssociatedObject(textView, @"placeholderLabel");
    placeholderLabel.hidden = textView.text.length > 0;
}

- (void)submitButtonTapped {
    if (self.submitFeedbackBlock) {
        self.submitFeedbackBlock(self.textView.text);
    }
}

- (void)clearContent {
    self.textView.text = @"";
    UILabel *placeholderLabel = objc_getAssociatedObject(self.textView, @"placeholderLabel");
    placeholderLabel.hidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end 
