//
//  JJRToast.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRToast : NSObject

/**
 * 显示 Toast 提示（类似 uni.showToast）
 * @param title 提示信息
 */
+ (void)showToast:(NSString *)title;

/**
 * 显示 Toast 提示（带图标和时长）
 * @param title 提示信息
 * @param icon 图标类型 ("none", "success", "error", "warning")
 * @param duration 显示时长（秒）
 */
+ (void)showToast:(NSString *)title 
             icon:(NSString * _Nullable)icon 
         duration:(NSTimeInterval)duration;

/**
 * 显示成功 Toast
 * @param title 提示信息
 */
+ (void)showSuccess:(NSString *)title;

/**
 * 显示错误 Toast
 * @param title 提示信息
 */
+ (void)showError:(NSString *)title;

/**
 * 显示警告 Toast
 * @param title 提示信息
 */
+ (void)showWarning:(NSString *)title;

/**
 * 隐藏当前显示的 Toast
 */
+ (void)hideToast;

@end

NS_ASSUME_NONNULL_END 