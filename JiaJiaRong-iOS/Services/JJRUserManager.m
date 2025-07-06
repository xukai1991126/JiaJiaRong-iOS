//
//  JJRUserManager.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/6.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRUserManager.h"

// 通知名称
NSString * const JJRUserLoginStatusChangedNotification = @"JJRUserLoginStatusChangedNotification";

// 存储键名
static NSString * const kUserInfoKey = @"JJRUserInfo";
static NSString * const kChannelTokenKey = @"token";
static NSString * const kUserTokenKey = @"userToken";
static NSString * const kMobileKey = @"mobile";

@interface JJRUserManager ()

// 移除isLoggedIn的私有属性，现在通过getter方法动态计算

@end

@implementation JJRUserManager

#pragma mark - 单例

+ (instancetype)sharedManager {
    static JJRUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JJRUserManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadFromLocal];
        // 初始化时检查登录状态
        NSLog(@"🎯 JJRUserManager初始化，当前登录状态: %@", self.isLoggedIn ? @"已登录" : @"未登录");
    }
    return self;
}

#pragma mark - 登录状态管理

- (BOOL)checkLoginStatus {
    // 从NSUserDefaults读取持久化数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *storedUserInfo = [defaults objectForKey:kUserInfoKey];
    NSString *storedUserToken = [defaults objectForKey:kUserTokenKey];
    
    // 判断登录状态：有用户信息或有用户token（基于持久化数据）
    BOOL loggedIn = (storedUserInfo != nil || (storedUserToken != nil && storedUserToken.length > 0));
    
    NSLog(@"🎯 检查登录状态: %@", loggedIn ? @"已登录" : @"未登录");
    NSLog(@"🎯 判断依据: storedUserInfo=%@, storedUserToken=%@", storedUserInfo ? @"有" : @"无", storedUserToken ? @"有" : @"无");
    
    return loggedIn;
}

- (BOOL)isLoggedIn {
    return [self checkLoginStatus];
}

- (void)updateLoginStatus {
    // 这个方法主要用于在数据变化后发送通知
    // 实际的登录状态检查由isLoggedIn getter方法处理
    NSLog(@"🎯 用户登录状态更新，当前状态: %@", self.isLoggedIn ? @"已登录" : @"未登录");
    
    // 发送登录状态变化通知（让监听者自行检查状态）
    [[NSNotificationCenter defaultCenter] postNotificationName:JJRUserLoginStatusChangedNotification 
                                                        object:nil 
                                                      userInfo:@{@"isLoggedIn": @(self.isLoggedIn)}];
}

#pragma mark - 登录相关

- (void)saveLoginInfo:(NSDictionary *)userInfo mobile:(NSString *)mobile {
    NSLog(@"🎯 保存登录信息: mobile=%@, userInfo=%@", mobile, userInfo);
    
    self.userInfo = userInfo;
    self.mobile = mobile;
    
    // 如果userInfo中包含tk字段，保存为用户token（服务端返回的是tk，不是token）
    if (userInfo[@"tk"]) {
        [self saveUserToken:userInfo[@"tk"]];
        NSLog(@"🎯 从userInfo中保存tk作为用户token: %@", userInfo[@"tk"]);
    }
    
    [self saveToLocal];
    [self updateLoginStatus];
}

- (void)logout {
    NSLog(@"🎯 用户登出");
    
    // 清除用户相关数据，但保留渠道token
    self.userInfo = nil;
    self.userToken = nil;
    self.mobile = nil;
    
    // 从本地存储中移除用户数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMobileKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateLoginStatus];
}

- (void)clearAllUserData {
    NSLog(@"🎯 清除所有用户数据");
    
    self.userInfo = nil;
    self.userToken = nil;
    self.token = nil;
    self.mobile = nil;
    
    // 清除所有本地存储
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kChannelTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMobileKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateLoginStatus];
}

#pragma mark - Token管理

- (void)saveChannelToken:(NSString *)token {
    NSLog(@"🎯 保存渠道Token: %@", token);
    self.token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kChannelTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateLoginStatus];
}

- (void)saveUserToken:(NSString *)userToken {
    NSLog(@"🎯 保存用户Token: %@", userToken);
    self.userToken = userToken;
    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:kUserTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateLoginStatus];
}

- (NSString *)getCurrentToken {
    // 优先使用用户token，其次使用渠道token
    if (self.userToken && self.userToken.length > 0) {
        return self.userToken;
    }
    return self.token;
}

#pragma mark - 用户信息管理

- (void)updateUserInfo:(NSDictionary *)userInfo {
    NSLog(@"🎯 更新用户信息: %@", userInfo);
    self.userInfo = userInfo;
    [self saveToLocal];
    [self updateLoginStatus];
}

- (id)getUserInfoForKey:(NSString *)key {
    return self.userInfo[key];
}

#pragma mark - 持久化

- (void)saveToLocal {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.userInfo) {
        [defaults setObject:self.userInfo forKey:kUserInfoKey];
    }
    
    if (self.token) {
        [defaults setObject:self.token forKey:kChannelTokenKey];
    }
    
    if (self.userToken) {
        [defaults setObject:self.userToken forKey:kUserTokenKey];
    }
    
    if (self.mobile) {
        [defaults setObject:self.mobile forKey:kMobileKey];
    }
    
    [defaults synchronize];
    NSLog(@"🎯 用户数据已保存到本地");
}

- (void)loadFromLocal {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.userInfo = [defaults objectForKey:kUserInfoKey];
    self.token = [defaults objectForKey:kChannelTokenKey];
    self.userToken = [defaults objectForKey:kUserTokenKey];
    self.mobile = [defaults objectForKey:kMobileKey];
    
    NSLog(@"🎯 从本地加载用户数据:");
    NSLog(@"🎯 - userInfo: %@", self.userInfo ? @"有" : @"无");
    NSLog(@"🎯 - token: %@", self.token ? @"有" : @"无");
    NSLog(@"🎯 - userToken: %@", self.userToken ? @"有" : @"无");
    NSLog(@"🎯 - mobile: %@", self.mobile ?: @"无");
}

#pragma mark - 调试信息

- (NSString *)description {
    return [NSString stringWithFormat:@"<JJRUserManager: isLoggedIn=%@, mobile=%@, hasUserInfo=%@, hasToken=%@>",
            self.isLoggedIn ? @"YES" : @"NO",
            self.mobile ?: @"nil",
            self.userInfo ? @"YES" : @"NO",
            [self getCurrentToken] ? @"YES" : @"NO"];
}

@end 