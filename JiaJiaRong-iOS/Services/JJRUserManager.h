//
//  JJRUserManager.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/6.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRUserManager : NSObject

// 单例方法
+ (instancetype)sharedManager;

// 登录状态
@property (nonatomic, assign, readonly) BOOL isLoggedIn;

// 用户信息
@property (nonatomic, strong, nullable) NSDictionary *userInfo;

// Token管理
@property (nonatomic, strong, nullable) NSString *token;
@property (nonatomic, strong, nullable) NSString *userToken; // 用户登录token

// 手机号
@property (nonatomic, strong, nullable) NSString *mobile;

#pragma mark - 登录相关
// 检查登录状态（从持久化存储中读取）
- (BOOL)checkLoginStatus;

// 保存登录信息
- (void)saveLoginInfo:(NSDictionary *)userInfo mobile:(NSString *)mobile;

// 登出
- (void)logout;

// 清除所有用户数据
- (void)clearAllUserData;

#pragma mark - Token管理
// 保存应用渠道token
- (void)saveChannelToken:(NSString *)token;

// 保存用户登录token
- (void)saveUserToken:(NSString *)userToken;

// 获取当前有效的token（优先使用用户token，其次使用渠道token）
- (NSString * _Nullable)getCurrentToken;

#pragma mark - 用户信息管理
// 更新用户信息
- (void)updateUserInfo:(NSDictionary *)userInfo;

// 获取用户信息字段
- (id _Nullable)getUserInfoForKey:(NSString *)key;

#pragma mark - 持久化
// 保存到本地
- (void)saveToLocal;

// 从本地加载
- (void)loadFromLocal;

#pragma mark - 通知
// 登录状态改变通知
extern NSString * const JJRUserLoginStatusChangedNotification;

@end

NS_ASSUME_NONNULL_END 