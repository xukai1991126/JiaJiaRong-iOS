//
//  JJRFaceVerifyManager.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRFaceVerifyManager.h"

// 导入阿里云SDK头文件
#import <AliyunFaceAuthFacade/AliyunFaceAuthFacade.h>
#import <DTFUtility/ZIMResponse.h>

@interface JJRFaceVerifyManager ()

@property (nonatomic, assign) BOOL isSDKInitialized;

@end

@implementation JJRFaceVerifyManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static JJRFaceVerifyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JJRFaceVerifyManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSDKInitialized = NO;
    }
    return self;
}

#pragma mark - Public Methods

- (void)initializeSDK {
    @try {
        // SDK已经在AppDelegate中初始化（IPv6），这里只需要验证状态
        NSString *version = [AliyunFaceAuthFacade getVersion];
        if (version && version.length > 0) {
            self.isSDKInitialized = YES;
            NSLog(@"🎯 阿里云人脸识别SDK已在AppDelegate中初始化");
            NSLog(@"📱 SDK版本: %@", version);
        } else {
            // 如果AppDelegate初始化失败，这里进行备用初始化
            NSLog(@"⚠️ AppDelegate初始化可能失败，进行备用初始化");
            [AliyunFaceAuthFacade initIPv6];
            self.isSDKInitialized = YES;
            NSLog(@"🎯 备用初始化成功（IPv6）");
        }
    } @catch (NSException *exception) {
        NSLog(@"❌ SDK状态检查失败: %@", exception.description);
        self.isSDKInitialized = NO;
        
        // 最后尝试普通初始化
        @try {
            [AliyunFaceAuthFacade initSDK];
            self.isSDKInitialized = YES;
            NSLog(@"🎯 最终降级到普通初始化成功");
        } @catch (NSException *fallbackException) {
            NSLog(@"❌ 所有初始化方式都失败: %@", fallbackException.description);
            self.isSDKInitialized = NO;
        }
    }
}

- (NSDictionary *)getMetaInfo {
    if (!self.isSDKInitialized) {
        NSLog(@"⚠️ SDK未初始化，请先调用initializeSDK");
        return @{};
    }
    
    @try {
        NSDictionary *metaInfo = [AliyunFaceAuthFacade getMetaInfo];
        NSLog(@"📋 获取设备信息: %@", metaInfo);
        
        if (metaInfo) {
            return metaInfo;
        }
        
        return @{};
    } @catch (NSException *exception) {
        NSLog(@"❌ 获取设备信息失败: %@", exception.description);
        return @{};
    }
}

- (void)startFaceVerifyWithCertifyId:(NSString *)certifyId 
                           extParams:(NSDictionary *)extParams {
    if (!self.isSDKInitialized) {
        NSLog(@"⚠️ SDK未初始化，请先调用initializeSDK");
        [self notifyDelegateWithResult:JJRFaceVerifyResultSystemError message:@"SDK未初始化"];
        return;
    }
    
    if (!certifyId || certifyId.length == 0) {
        NSLog(@"❌ certifyId不能为空");
        [self notifyDelegateWithResult:JJRFaceVerifyResultSystemError message:@"certifyId不能为空"];
        return;
    }
    
    NSLog(@"🚀 开始人脸识别");
    NSLog(@"🔑 certifyId: %@", certifyId);
    NSLog(@"📦 extParams: %@", extParams);
    
    // 确保在主线程调用
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            [AliyunFaceAuthFacade verifyWith:certifyId 
                                   extParams:extParams 
                                onCompletion:^(ZIMResponse *response) {
                [self handleFaceVerifyResponse:response];
            }];
        } @catch (NSException *exception) {
            NSLog(@"❌ 启动人脸识别失败: %@", exception.description);
            [self notifyDelegateWithResult:JJRFaceVerifyResultSystemError 
                                   message:@"启动人脸识别失败"];
        }
    });
}

- (BOOL)isSDKAvailable {
    return self.isSDKInitialized;
}

- (NSString *)getSDKVersion {
    @try {
        return [AliyunFaceAuthFacade getVersion] ?: @"未知版本";
    } @catch (NSException *exception) {
        NSLog(@"❌ 获取SDK版本失败: %@", exception.description);
        return @"未知版本";
    }
}

#pragma mark - Private Methods

- (void)handleFaceVerifyResponse:(ZIMResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!response) {
            NSLog(@"❌ 人脸识别响应为空");
            [self notifyDelegateWithResult:JJRFaceVerifyResultSystemError message:@"系统错误"];
            return;
        }
        
        NSLog(@"📥 人脸识别结果: %@", response);
        
        // 解析响应结果
        JJRFaceVerifyResult result = [self parseVerifyResult:response];
        NSString *message = [self getMessageForResult:result response:response];
        
        [self notifyDelegateWithResult:result message:message];
    });
}

- (JJRFaceVerifyResult)parseVerifyResult:(ZIMResponse *)response {
    if (!response) {
        return JJRFaceVerifyResultSystemError;
    }
    
    // 根据阿里云SDK的返回码判断结果（直接比较枚举值）
    switch (response.code) {
        case 1000:  // 刷脸成功
            return JJRFaceVerifyResultSuccess;
        case 1001:  // 系统错误
            return JJRFaceVerifyResultSystemError;
        case 1003:  // 验证中断
            return JJRFaceVerifyResultUserCancel;
        case 2003:  // 客户端设备时间错误
            return JJRFaceVerifyResultTimeError;
        case 2006:  // 刷脸失败
            return JJRFaceVerifyResultFaceFailed;
        default:
            return JJRFaceVerifyResultOtherError;
    }
}

- (NSString *)getMessageForResult:(JJRFaceVerifyResult)result response:(ZIMResponse *)response {
    switch (result) {
        case JJRFaceVerifyResultSuccess:
            return @"人脸识别成功";
        case JJRFaceVerifyResultSystemError:
            return @"系统错误，请重试";
        case JJRFaceVerifyResultUserCancel:
            return @"用户取消验证";
        case JJRFaceVerifyResultTimeError:
            return @"设备时间错误";
        case JJRFaceVerifyResultFaceFailed:
            return @"人脸识别失败";
        case JJRFaceVerifyResultOtherError:
        default:
            // 使用ZIMResponse的retMessageSub属性
            return response.retMessageSub ?: @"未知错误";
    }
}

- (void)notifyDelegateWithResult:(JJRFaceVerifyResult)result message:(NSString *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceVerifyManager:didCompleteWithResult:message:)]) {
        [self.delegate faceVerifyManager:self didCompleteWithResult:result message:message];
    }
}

@end 
