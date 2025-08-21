//
//  JJRUserManager.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/7/6.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRUserManager.h"

// 通知名称
NSString * const JJRUserLoginStatusChangedNotification = @"JJRUserLoginStatusChangedNotification";

// 存储键名 - 和uni-app保持一致
static NSString * const kUserInfoKey = @"JJRUserInfo";
static NSString * const kTokenKey = @"token";  // 和uni-app一致，只有一个token
static NSString * const kMobileKey = @"mobile";

@interface JJRUserManager ()

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
    
    // 判断登录状态：有用户信息就认为已登录（和uni-app逻辑一致）
    BOOL loggedIn = (storedUserInfo != nil);
    
    NSLog(@"🎯 检查登录状态: %@", loggedIn ? @"已登录" : @"未登录");
    NSLog(@"🎯 判断依据: storedUserInfo=%@", storedUserInfo ? @"有" : @"无");
    
    return loggedIn;
}

- (BOOL)isLoggedIn {
    return [self checkLoginStatus];
}

- (void)updateLoginStatus {
    // 这个方法主要用于在数据变化后发送通知
    NSLog(@"🎯 用户登录状态更新，当前状态: %@", self.isLoggedIn ? @"已登录" : @"未登录");
    
    // 发送登录状态变化通知
    [[NSNotificationCenter defaultCenter] postNotificationName:JJRUserLoginStatusChangedNotification 
                                                        object:nil 
                                                      userInfo:@{@"isLoggedIn": @(self.isLoggedIn)}];
}

#pragma mark - 登录相关

- (void)saveLoginInfo:(NSDictionary *)userInfo mobile:(NSString *)mobile {
    NSLog(@"🎯 保存登录信息: mobile=%@, userInfo=%@", mobile, userInfo);
    
    self.userInfo = userInfo;
    self.mobile = mobile;
    
    // 和uni-app保持一致：登录成功后不更新token，继续使用原有的token
    // uni-app中登录后只保存userInfo和mobile，不操作token
    
    [self saveToLocal];
    [self updateLoginStatus];
}

- (void)logout {
    NSLog(@"🎯 用户登出");
    
    // 清除用户相关数据，但保留token（和uni-app逻辑一致）
    self.userInfo = nil;
    self.mobile = nil;
    
    // 从本地存储中移除用户数据，但保留token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMobileKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateLoginStatus];
}

- (void)clearAllUserData {
    NSLog(@"🎯 清除所有用户数据");
    
    self.userInfo = nil;
    self.token = nil;
    self.mobile = nil;
    
    // 清除所有本地存储
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMobileKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 同时清除NSUserDefaults中的用户数据
    [self clearUserDataFromDefaults];
    
    [self updateLoginStatus];
}

#pragma mark - Token管理

- (void)saveToken:(NSString *)token {
    NSLog(@"🎯 保存Token: %@", token);
    self.token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCurrentToken {
    // 和uni-app保持一致，直接返回token
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
        [defaults setObject:self.token forKey:kTokenKey];
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
    self.token = [defaults objectForKey:kTokenKey];
    self.mobile = [defaults objectForKey:kMobileKey];
    
    NSLog(@"🎯 从本地加载用户数据:");
    NSLog(@"🎯 - userInfo: %@", self.userInfo ? @"有" : @"无");
    NSLog(@"🎯 - token: %@", self.token ? @"有" : @"无");
    NSLog(@"🎯 - mobile: %@", self.mobile ?: @"无");
}

#pragma mark - 用户数据存储（NSUserDefaults）

- (void)saveUserDataToDefaults:(NSDictionary *)userData {
    // 获取当前用户token
    NSString *token = [self getCurrentToken];
    if (!token || token.length == 0) {
        token = @"default_user"; // 如果没有token，使用默认key
    }
    
    // 使用token作为key保存用户数据
    NSString *userDataKey = [NSString stringWithFormat:@"user_data_%@", token];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:userDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"💾 保存用户数据到NSUserDefaults: key=%@, data=%@", userDataKey, userData);
}

- (NSDictionary *)getUserDataFromDefaults {
    // 获取当前用户token
    NSString *token = [self getCurrentToken];
    if (!token || token.length == 0) {
        token = @"default_user"; // 如果没有token，使用默认key
    }
    
    // 使用token作为key读取用户数据
    NSString *userDataKey = [NSString stringWithFormat:@"user_data_%@", token];
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:userDataKey];
    
    NSLog(@"📖 从NSUserDefaults读取用户数据: key=%@, data=%@", userDataKey, userData);
    return userData;
}

- (void)clearUserDataFromDefaults {
    // 获取当前用户token
    NSString *token = [self getCurrentToken];
    if (!token || token.length == 0) {
        token = @"default_user"; // 如果没有token，使用默认key
    }
    
    // 使用token作为key清除用户数据
    NSString *userDataKey = [NSString stringWithFormat:@"user_data_%@", token];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"🗑️ 从NSUserDefaults清除用户数据: key=%@", userDataKey);
}

//完成实名认证
- (BOOL)realFinish {
    NSDictionary *userData = [[JJRUserManager sharedManager] getUserDataFromDefaults];
    NSString *realName = userData[@"realName"];
    return realName.length;
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
