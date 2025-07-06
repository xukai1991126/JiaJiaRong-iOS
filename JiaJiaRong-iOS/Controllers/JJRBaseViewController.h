//
//  JJRBaseViewController.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/6.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRBaseViewController : UIViewController

// 是否需要登录验证（默认YES）
@property (nonatomic, assign) BOOL requiresLogin;

// 检查登录状态
- (BOOL)checkLoginStatus;

// 跳转到登录页面
- (void)navigateToLogin;

@end

NS_ASSUME_NONNULL_END 