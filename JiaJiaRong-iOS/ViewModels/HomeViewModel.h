//
//  HomeViewModel.h
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewModel : JJRBaseViewModel

// 主要数据
@property (nonatomic, strong, readonly) NSString *maxAmount;
@property (nonatomic, strong, readonly) NSString *maxPeriod;
@property (nonatomic, strong, readonly) NSString *rateInfo;
@property (nonatomic, strong, readonly) NSString *combinedInfo;
@property (nonatomic, strong, readonly) NSString *loginButtonTitle;
@property (nonatomic, assign, readonly) BOOL showProtocolCheckbox;

// 特色数据
@property (nonatomic, strong, readonly) NSArray *featureData;

// 用户证明数据
@property (nonatomic, strong, readonly) NSArray *testimonialData;

// 协议相关
@property (nonatomic, assign) BOOL protocolChecked;

// 初始化数据
- (void)loadInitialData;

// 获取用户信息
- (void)fetchUserInfo;

// 更新登录按钮标题
- (void)updateLoginButtonTitle;

// 根据登录状态更新按钮标题
- (void)updateLoginButtonTitleWithLoginStatus:(BOOL)isLoggedIn;

@end

NS_ASSUME_NONNULL_END 
