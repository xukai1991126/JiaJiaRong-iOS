//
//  JJRButton.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJREnums.h"

NS_ASSUME_NONNULL_BEGIN



@interface JJRButton : UIButton

// 初始化方法
- (instancetype)initWithType:(JJRButtonType)type;
- (instancetype)initWithType:(JJRButtonType)type size:(JJRButtonSize)size;
- (instancetype)initWithTitle:(NSString *)title type:(JJRButtonType)type;

// 设置按钮类型
- (void)setJjrButtonType:(JJRButtonType)jjrButtonType;
- (void)setButtonSize:(JJRButtonSize)size;

// 设置内容
- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)title image:(UIImage *)image;

// 设置样式
- (void)setCornerRadius:(CGFloat)radius;
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color;
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

// 设置加载状态
- (void)setLoading:(BOOL)loading;
- (void)setLoading:(BOOL)loading title:(NSString *)title;

// 设置禁用状态
- (void)setEnabled:(BOOL)enabled;

// 设置点击事件
- (void)setClickAction:(void(^)(JJRButton *button))action;

// 设置渐变背景
- (void)setGradientColors:(NSArray<UIColor *> *)colors direction:(JJRGradientDirection)direction;

// 设置圆角位置
- (void)setCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners;

// 设置点击效果
- (void)setClickEffect:(BOOL)enabled;

// 设置倒计时
- (void)startCountdown:(NSInteger)seconds title:(NSString *)title;

// 停止倒计时
- (void)stopCountdown;

@end

NS_ASSUME_NONNULL_END 
