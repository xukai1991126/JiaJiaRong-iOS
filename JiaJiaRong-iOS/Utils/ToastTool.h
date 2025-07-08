//
//  ToastTool.h
//  JiaJiaRong-iOS
//
//  Created by xk work's computer on 2025/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastTool : NSObject

/// 显示仅文字提示
+ (void)showToast:(NSString *)message inView:(UIView *)view;

+ (void)showToastInKeWindow:(NSString *)message;

/// 显示加载中（转圈）
+ (void)showLoadingInView:(UIView *)view;

/// 隐藏加载中
+ (void)hideLoadingInView:(UIView *)view;

/// 显示成功提示
+ (void)showSuccess:(NSString *)message inView:(UIView *)view;

/// 显示失败提示
+ (void)showError:(NSString *)message inView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
