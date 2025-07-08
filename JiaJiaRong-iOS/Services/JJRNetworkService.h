//
//  JJRNetworkService.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JJRAPIDefines.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRSuccessBlock)(NSDictionary *response);
typedef void(^JJRFailureBlock)(NSError *error);

@interface JJRNetworkService : NSObject

+ (instancetype)sharedInstance;

#pragma mark - 应用相关接口
// 获取应用渠道信息
- (void)getAppChannelWithAppId:(NSString *)appId 
                       client:(NSString *)client 
                     success:(JJRSuccessBlock)success 
                     failure:(JJRFailureBlock)failure;

// 获取应用信息
- (void)getAppInfoWithAppId:(NSString *)appId 
                        ios:(BOOL)ios 
                    success:(JJRSuccessBlock)success 
                    failure:(JJRFailureBlock)failure;

// 发送验证码
- (void)sendCaptchaWithType:(NSString *)captchaType 
                     mobile:(NSString *)mobile 
                        md5:(NSString *)md5 
                    success:(JJRSuccessBlock)success 
                    failure:(JJRFailureBlock)failure;

// 验证码登录
- (void)loginWithCaptcha:(NSString *)text 
                  mobile:(NSString *)mobile 
                     md5:(NSString *)md5 
                 success:(JJRSuccessBlock)success 
                 failure:(JJRFailureBlock)failure;

// 密码登录
- (void)loginWithPassword:(NSString *)password 
                   mobile:(NSString *)mobile 
                      md5:(NSString *)md5 
                  success:(JJRSuccessBlock)success 
                  failure:(JJRFailureBlock)failure;

#pragma mark - 用户信息相关接口
// 获取用户信息
- (void)getUserInfoWithSuccess:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure;

// 实名认证
- (void)realNameAuthWithParams:(NSDictionary *)params 
                      success:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure;

#pragma mark - 表单相关接口
// 获取表单字段
- (void)getFormFieldWithOsType:(NSString *)osType 
                      success:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure;

// 提交表单申请
- (void)submitFormApplyWithParams:(NSDictionary *)params 
                         success:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure;

// 获取热门城市
- (void)getHotCitiesWithSuccess:(JJRSuccessBlock)success 
                       failure:(JJRFailureBlock)failure;

#pragma mark - 身份证相关接口
// 身份证识别
- (void)recognizeIdCardWithImage:(UIImage *)image 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

// 身份证验证
- (void)verifyIdCardWithParams:(NSDictionary *)params 
                      success:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure;

// 身份证图片上传
- (void)uploadIdCardImage:(UIImage *)image 
                 success:(JJRSuccessBlock)success 
                 failure:(JJRFailureBlock)failure;

// 身份证人像面OCR识别
- (void)recognizeIdCardFaceWithImageUrl:(NSString *)imageUrl 
                               success:(JJRSuccessBlock)success 
                               failure:(JJRFailureBlock)failure;

// 身份证国徽面OCR识别
- (void)recognizeIdCardBackWithImageUrl:(NSString *)imageUrl 
                               success:(JJRSuccessBlock)success 
                               failure:(JJRFailureBlock)failure;

// 保存身份证信息
- (void)saveIdCardInfoWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

// 初始化人脸识别
- (void)initFaceVerifyWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

#pragma mark - 银行卡相关接口
// 获取银行卡列表
- (void)getBankCardListWithSuccess:(JJRSuccessBlock)success 
                          failure:(JJRFailureBlock)failure;

// 添加银行卡
- (void)addBankCardWithParams:(NSDictionary *)params 
                     success:(JJRSuccessBlock)success 
                     failure:(JJRFailureBlock)failure;

// 删除银行卡
- (void)deleteBankCardWithCardId:(NSString *)cardId 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

#pragma mark - 申请记录相关接口
// 获取申请记录
- (void)getApplyRecordWithSuccess:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure;

// 获取还款计划
- (void)getRepaymentPlanWithSuccess:(JJRSuccessBlock)success 
                           failure:(JJRFailureBlock)failure;

#pragma mark - 验证码相关接口
// 发送验证码
- (void)sendCaptchaWithParams:(NSDictionary *)params 
                     success:(JJRSuccessBlock)success 
                     failure:(JJRFailureBlock)failure;

#pragma mark - 密码管理相关接口
// 初始化密码
- (void)initPasswordWithParams:(NSDictionary *)params 
                      success:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure;

// 修改密码
- (void)modifyPasswordWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

// 更新密码 (通过验证码)
- (void)updatePasswordWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

// 忘记密码
- (void)forgetPasswordWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

#pragma mark - 用户操作相关接口
// 退出登陆
- (void)logoutWithSuccess:(JJRSuccessBlock)success 
                 failure:(JJRFailureBlock)failure;

// 注销账号
- (void)cancelAccountWithSuccess:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

#pragma mark - 反馈相关接口
// 提交反馈
- (void)submitFeedbackWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

// 提交意见反馈
- (void)submitOpinionWithParams:(NSDictionary *)params 
                       success:(JJRSuccessBlock)success 
                       failure:(JJRFailureBlock)failure;

#pragma mark - 授权相关接口
// 获取授权机构数量
- (void)getAuthorityNumberWithSuccess:(JJRSuccessBlock)success 
                             failure:(JJRFailureBlock)failure;

// 获取授权协议内容
- (void)getAuthorizationAgreementWithAppId:(NSString *)appId 
                                    aupage:(NSNumber *)aupage 
                                   success:(JJRSuccessBlock)success 
                                   failure:(JJRFailureBlock)failure;

// 提交商户申请
- (void)submitMerchantApplyWithSuccess:(JJRSuccessBlock)success 
                              failure:(JJRFailureBlock)failure;

#pragma mark - 其他接口
// 获取关于我们
- (void)getAboutUsWithSuccess:(JJRSuccessBlock)success 
                     failure:(JJRFailureBlock)failure;

// 获取免责声明
- (void)getDisclaimerWithSuccess:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure;

// 获取安全手册
- (void)getSecurityManualWithSuccess:(JJRSuccessBlock)success 
                            failure:(JJRFailureBlock)failure;

// 获取版本信息
- (void)getVersionInfoWithSuccess:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure;

// 获取公告
- (void)getNoticeWithSuccess:(JJRSuccessBlock)success 
                    failure:(JJRFailureBlock)failure;

// 获取通知设置
- (void)getNotificationSettingsWithSuccess:(JJRSuccessBlock)success 
                                  failure:(JJRFailureBlock)failure;

// 设置通知
- (void)setNotificationWithParams:(NSDictionary *)params 
                         success:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure;

// 提交留言
- (void)submitMessageWithParams:(NSDictionary *)params 
                       success:(JJRSuccessBlock)success 
                       failure:(JJRFailureBlock)failure;

#pragma mark - 文件上传相关接口
// 上传图片
- (void)uploadImage:(UIImage *)image 
           success:(JJRSuccessBlock)success 
           failure:(JJRFailureBlock)failure;

// 上传文件
- (void)uploadFile:(NSData *)fileData 
          fileName:(NSString *)fileName 
          mimeType:(NSString *)mimeType 
          success:(JJRSuccessBlock)success 
          failure:(JJRFailureBlock)failure;

#pragma mark - 通用方法
// GET请求
- (void)GET:(NSString *)url 
     params:(NSDictionary * _Nullable)params
   success:(JJRSuccessBlock)success
   failure:(JJRFailureBlock)failure;

// POST请求
- (void)POST:(NSString *)url 
      params:(NSDictionary * _Nullable)params 
    success:(JJRSuccessBlock)success 
    failure:(JJRFailureBlock)failure;

#pragma mark - 工具方法
// 显示加载提示
+ (void)showLoading;

// 隐藏加载提示
+ (void)hideLoading;

// 显示Toast提示

// MD5加密
+ (NSString *)md5:(NSString *)input;

// 手机号加密
+ (NSString *)encryptMobile:(NSString *)mobile;

// 手机号MD5
+ (NSString *)encryptMobileMd5:(NSString *)mobile;
+ (void)showToast:(NSString *)message;

@end

NS_ASSUME_NONNULL_END 
