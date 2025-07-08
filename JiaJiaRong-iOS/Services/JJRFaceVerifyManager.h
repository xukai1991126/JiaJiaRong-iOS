//
//  JJRFaceVerifyManager.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JJRFaceVerifyResult) {
    JJRFaceVerifyResultSuccess = 1000,           // 认证成功
    JJRFaceVerifyResultSystemError = 1001,       // 系统错误
    JJRFaceVerifyResultUserCancel = 1003,        // 验证中断
    JJRFaceVerifyResultTimeError = 2003,         // 客户端设备时间错误
    JJRFaceVerifyResultFaceFailed = 2006,        // 刷脸失败
    JJRFaceVerifyResultOtherError = -1           // 其他错误
};

@class JJRFaceVerifyManager;

@protocol JJRFaceVerifyManagerDelegate <NSObject>

@optional
/**
 * 人脸识别完成回调
 * @param manager 管理器实例
 * @param result 识别结果
 * @param message 结果描述
 */
- (void)faceVerifyManager:(JJRFaceVerifyManager *)manager 
        didCompleteWithResult:(JJRFaceVerifyResult)result 
                      message:(NSString *)message;

/**
 * 人脸识别进度回调
 * @param manager 管理器实例
 * @param progress 进度 0.0-1.0
 * @param tip 提示信息
 */
- (void)faceVerifyManager:(JJRFaceVerifyManager *)manager 
             didProgress:(CGFloat)progress 
                     tip:(NSString *)tip;

@end

@interface JJRFaceVerifyManager : NSObject

@property (nonatomic, weak) id<JJRFaceVerifyManagerDelegate> delegate;
@property (nonatomic, weak) UIViewController *presentingViewController;

+ (instancetype)sharedManager;

/**
 * 初始化SDK
 */
- (void)initializeSDK;

/**
 * 获取设备信息
 * @return 设备meta信息
 */
- (NSDictionary *)getMetaInfo;

/**
 * 开始人脸识别
 * @param certifyId 服务器返回的认证ID
 * @param extParams 扩展参数
 */
- (void)startFaceVerifyWithCertifyId:(NSString *)certifyId 
                           extParams:(NSDictionary * _Nullable)extParams;

/**
 * 检查SDK是否可用
 * @return YES表示可用
 */
- (BOOL)isSDKAvailable;

/**
 * 获取SDK版本
 * @return 版本号
 */
- (NSString *)getSDKVersion;

@end

NS_ASSUME_NONNULL_END 