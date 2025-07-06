//
//  JJRInputView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJREnums.h"

NS_ASSUME_NONNULL_BEGIN
@class JJRInputView;
@protocol JJRInputViewDelegate <NSObject>

@optional
- (void)inputViewDidChange:(UITextField *)textField;
- (void)inputViewDidBeginEditing:(UITextField *)textField;
- (void)inputViewDidEndEditing:(UITextField *)textField;
- (BOOL)inputViewShouldReturn:(UITextField *)textField;
- (BOOL)inputViewShouldBeginEditing:(JJRInputView *)inputView;
- (BOOL)inputViewShouldEndEditing:(JJRInputView *)inputView;
- (BOOL)inputViewShouldClear:(JJRInputView *)inputView;
- (BOOL)inputView:(JJRInputView *)inputView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

@interface JJRInputView : UIView

@property (nonatomic, weak) id<JJRInputViewDelegate> delegate;
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *lineView;
@property (nonatomic, strong, readonly) UIButton *rightButton;

// 初始化方法
- (instancetype)initWithType:(JJRInputType)type;
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder type:(JJRInputType)type;

// 设置内容
- (void)setTitle:(NSString *)title;
- (void)setPlaceholder:(NSString *)placeholder;
- (void)setText:(NSString *)text;
- (NSString *)getText;

// 设置样式
- (void)setTitleColor:(UIColor *)color;
- (void)setTextColor:(UIColor *)color;
- (void)setPlaceholderColor:(UIColor *)color;
- (void)setLineColor:(UIColor *)color;
- (void)setBackgroundColor:(UIColor *)color;

// 设置验证
- (void)setMaxLength:(NSInteger)maxLength;
- (void)setRequired:(BOOL)required;
- (BOOL)isValid;

// 设置右侧按钮
- (void)setRightButtonTitle:(NSString *)title;
- (void)setRightButtonImage:(UIImage *)image;
- (void)setRightButtonAction:(void(^)(void))action;

// 设置输入限制
- (void)setInputType:(JJRInputType)type;

// 显示/隐藏密码
- (void)setSecureTextEntry:(BOOL)secure;

// 设置键盘类型
- (void)setKeyboardType:(UIKeyboardType)keyboardType;

// 设置返回键类型
- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType;

// 设置是否可编辑
- (void)setEnabled:(BOOL)enabled;

// 设置焦点
// 设置文本变化回调
- (void)setTextChangeBlock:(void(^)(NSString *text))block;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;

// 验证方法
- (BOOL)validatePhone;
- (BOOL)validateIDCard;
- (BOOL)validateBankCard;
- (BOOL)validateEmail;
- (BOOL)validateRequired;

@end

NS_ASSUME_NONNULL_END
