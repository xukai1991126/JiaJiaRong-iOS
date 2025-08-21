//
//  JJRNetworkService.m
//  JiaJiaRong-iOS
//
//  Created by json on 2025/7/5.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRNetworkService.h"
#import "JJRUserManager.h"
#import "LoginViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface JJRNetworkService ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSString *baseURL;

// 私有方法声明
- (void)addUniAppHeaders;
- (NSString *)generateRandomString:(NSInteger)length;
- (NSString *)getUserAgent;
- (NSString *)getSecret:(NSString *)timestamp;

@end

@implementation JJRNetworkService

+ (instancetype)sharedInstance {
    static JJRNetworkService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JJRNetworkService alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSessionManager];
    }
    return self;
}

- (void)setupSessionManager {
    self.baseURL = JJR_BASE_URL;
    
    self.sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 设置超时时间
    self.sessionManager.requestSerializer.timeoutInterval = 30.0;
    
    // 设置基础请求头
    [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

- (void)addUniAppHeaders {
    // 生成时间戳（6位随机字符串 + 当前时间戳）
    NSString *randomString = [self generateRandomString:6];
    long long timestamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *rStamp = [NSString stringWithFormat:@"%@%lld", randomString, timestamp];
    
    // 获取用户代理
    NSString *userAgent = [self getUserAgent];
    
    // 生成密钥
    NSString *secret = [self getSecret:rStamp];
    
    // 生成r-id
    NSString *rIdSource = [NSString stringWithFormat:@"%@%@%@", rStamp, userAgent, secret];
    NSString *rId = [self md5:rIdSource];
    
    // 调试日志
    NSLog(@"🔧 请求头生成详情:");
    NSLog(@"🔧 randomString: %@", randomString);
    NSLog(@"🔧 timestamp: %lld", timestamp);
    NSLog(@"🔧 rStamp: %@", rStamp);
    NSLog(@"🔧 userAgent: %@", userAgent);
    NSLog(@"🔧 secret: %@", secret);
    NSLog(@"🔧 rIdSource: %@", rIdSource);
    NSLog(@"🔧 rId: %@", rId);
    
    // 设置请求头（和uni-app保持一致，使用小写）
    [self.sessionManager.requestSerializer setValue:userAgent forHTTPHeaderField:@"user-agent"];
    [self.sessionManager.requestSerializer setValue:rId forHTTPHeaderField:@"r-id"];
    [self.sessionManager.requestSerializer setValue:rStamp forHTTPHeaderField:@"r-stamp"];
    
    // 移除AFNetworking自动添加的User-Agent，避免冲突
    [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"User-Agent"];
    
    // 添加token（如果存在）
    NSString *token = [[JJRUserManager sharedManager] getCurrentToken];
    if (token && token.length > 0) {
        [self.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        NSLog(@"🎯 添加Token到请求头: %@", token);
    } else {
        NSLog(@"⚠️ Token不存在，不添加到请求头");
    }
}

- (NSString *)generateRandomString:(NSInteger)length {
    NSString *characters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *result = [NSMutableString stringWithCapacity:length];
    
    for (NSInteger i = 0; i < length; i++) {
        NSInteger randomIndex = arc4random_uniform((uint32_t)characters.length);
        [result appendString:[characters substringWithRange:NSMakeRange(randomIndex, 1)]];
    }
    
    return result;
}

- (NSString *)getUserAgent {
    // 模拟uni-app的User-Agent格式
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *model = [[UIDevice currentDevice] model];
    
    // 将iOS版本号中的点号替换为下划线，符合标准格式
    NSString *versionForUA = [systemVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    
    // 生成标准的iOS User-Agent格式
    NSString *userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU %@ OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148", 
                          model, 
                          [model isEqualToString:@"iPhone"] ? @"iPhone" : @"OS",
                          versionForUA];
    
    NSLog(@"🔧 生成的User-Agent: %@", userAgent);
    return userAgent;
}

- (NSString *)getSecret:(NSString *)timestamp {
    NSArray *keywords = @[
        @[@"N", @"R", @"J", @"s", @"E", @"c", @"k", @"h", @"J", @"S"],
        @[@"I", @"N", @"J", @"c", @"Q", @"t", @"c", @"c", @"r", @"F"],
        @[@"C", @"r", @"H", @"y", @"D", @"U", @"E", @"p", @"Z", @"a"],
        @[@"P", @"j", @"Y", @"U", @"O", @"v", @"V", @"f", @"b", @"t"],
        @[@"N", @"H", @"d", @"k", @"T", @"R", @"g", @"d", @"m", @"x"]
    ];
    
    NSMutableString *result = [NSMutableString string];
    
    NSLog(@"🔧 Secret计算详情:");
    NSLog(@"🔧 timestamp: %@", timestamp);
    NSLog(@"🔧 timestamp.length: %ld", (long)timestamp.length);
    
    for (NSInteger i = 4; i >= 0; i--) {
        NSInteger pos = timestamp.length - i - 1;
        NSLog(@"🔧 i=%ld, pos=%ld", (long)i, (long)pos);
        
        if (pos >= 0 && pos < timestamp.length) {
            NSString *charSecret = [timestamp substringWithRange:NSMakeRange(pos, 1)];
            NSInteger index = [charSecret integerValue];
            NSLog(@"🔧 charSecret=%@, index=%ld", charSecret, (long)index);
            
            if (index >= 0 && index < 10 && i >= 0 && i < keywords.count) {
                NSArray *keywordArray = keywords[i];
                if (index < keywordArray.count) {
                    NSString *keyword = keywordArray[index];
                    [result appendString:keyword];
                    NSLog(@"🔧 添加keyword: %@", keyword);
                }
            }
        }
    }
    
    NSLog(@"🔧 最终secret: %@", result);
    return result;
}

#pragma mark - 应用相关接口

- (void)getAppChannelWithAppId:(NSString *)appId 
                       client:(NSString *)client 
                     success:(JJRSuccessBlock)success 
                     failure:(JJRFailureBlock)failure {
    
    // iOS对应apple渠道，cid为11
    NSDictionary *params = @{
        @"appId": appId ?: @"JJR",
        @"client": client ?: @"IOS",
        @"cid": @11,
        @"n": @"apple"
    };
    
    [self POST:JJR_APP_CHANNEL params:params success:success failure:failure];
}

- (void)getAppInfoWithAppId:(NSString *)appId 
                        ios:(BOOL)ios 
                    success:(JJRSuccessBlock)success 
                    failure:(JJRFailureBlock)failure {
    
    NSDictionary *params = @{
        @"appId": appId ?: @"JJR",
        @"ios": @(ios)
    };
    
    [self POST:JJR_APP_INFO params:params success:success failure:failure];
}

- (void)sendCaptchaWithType:(NSString *)captchaType 
                     mobile:(NSString *)mobile 
                        md5:(NSString *)md5 
                    success:(JJRSuccessBlock)success 
                    failure:(JJRFailureBlock)failure {
    
    NSDictionary *params = @{
        @"captchaType": captchaType ?: @"LOGIN",
        @"mobile": mobile ?: @"",
        @"md5": md5 ?: @""
    };
    
    [self POST:JJR_CAPTCHA_SEND params:params success:success failure:failure];
}

- (void)loginWithCaptcha:(NSString *)text 
                  mobile:(NSString *)mobile 
                     md5:(NSString *)md5 
                 success:(JJRSuccessBlock)success 
                 failure:(JJRFailureBlock)failure {
    
    NSDictionary *params = @{
        @"text": text ?: @"",
        @"mobile": mobile ?: @"",
        @"md5": md5 ?: @""
    };
    
    [self POST:JJR_CAPTCHA_LOGIN params:params success:success failure:failure];
}

- (void)loginWithPassword:(NSString *)password 
                   mobile:(NSString *)mobile 
                      md5:(NSString *)md5 
                  success:(JJRSuccessBlock)success 
                  failure:(JJRFailureBlock)failure {
    
    NSDictionary *params = @{
        @"text": password ?: @"",
        @"mobile": mobile ?: @"",
        @"md5": md5 ?: @""
    };
    
    [self POST:JJR_PWD_LOGIN params:params success:success failure:failure];
}

#pragma mark - 用户信息相关接口

- (void)getUserInfoWithSuccess:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure {
    [self POST:JJR_USER_INFO params:@{} success:success failure:failure];
}

- (void)realNameAuthWithParams:(NSDictionary *)params 
                      success:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure {
    [self POST:JJR_REAL_NAME_AUTH params:params success:success failure:failure];
}

#pragma mark - 表单相关接口

- (void)getFormFieldWithOsType:(NSString *)osType 
                      success:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@?ostype=%@", JJR_FORM_FIELD, osType ?: @"ios"];
    [self POST:url params:@{} success:success failure:failure];
}

- (void)submitFormApplyWithParams:(NSDictionary *)params 
                         success:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure {
    [self POST:JJR_FORM_APPLY params:params success:success failure:failure];
}

- (void)getHotCitiesWithSuccess:(JJRSuccessBlock)success 
                       failure:(JJRFailureBlock)failure {
    [self POST:JJR_FORM_CITY_HOT params:@{} success:success failure:failure];
}

#pragma mark - 身份证相关接口

- (void)recognizeIdCardWithImage:(UIImage *)image 
                         success:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure {
    
    // 每次请求前重新生成动态请求头
    [self addUniAppHeaders];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, JJR_IDCARD_RECOGNIZE];
    
    // 临时保存并移除Content-Type，让AFNetworking自动设置multipart
    NSString *originalContentType = [self.sessionManager.requestSerializer valueForHTTPHeaderField:@"Content-Type"];
    [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
    
    [self.sessionManager POST:fullURL 
                   parameters:nil
                      headers:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData 
                                    name:@"file" 
                                fileName:@"idcard.jpg" 
                                mimeType:@"image/jpeg"];
    } 
                      progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 恢复原始的Content-Type
        [self.sessionManager.requestSerializer setValue:originalContentType forHTTPHeaderField:@"Content-Type"];
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 恢复原始的Content-Type
        [self.sessionManager.requestSerializer setValue:originalContentType forHTTPHeaderField:@"Content-Type"];
        
        if (failure) {
            failure(error);
        }
    }];
}

- (void)verifyIdCardWithParams:(NSDictionary *)params 
                      success:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure {
    [self POST:JJR_IDCARD_VERIFY params:params success:success failure:failure];
}

- (void)uploadIdCardImage:(UIImage *)image 
                 success:(JJRSuccessBlock)success 
                 failure:(JJRFailureBlock)failure {
    
    // 每次请求前重新生成动态请求头
    [self addUniAppHeaders];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, JJR_IDENTITY_UPLOAD];
    
    NSLog(@"📤 开始上传身份证图片");
    NSLog(@"📤 URL: %@", fullURL);
    NSLog(@"📤 图片尺寸: %.0f x %.0f", image.size.width, image.size.height);
    
    // 临时保存并移除Content-Type，让AFNetworking自动设置multipart
    NSString *originalContentType = [self.sessionManager.requestSerializer valueForHTTPHeaderField:@"Content-Type"];
    [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
    
    // 打印请求头
    NSDictionary *headers = self.sessionManager.requestSerializer.HTTPRequestHeaders;
    NSLog(@"📤 请求头: %@", headers);
    
    [self.sessionManager POST:fullURL 
                   parameters:nil
                      headers:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSLog(@"📤 图片数据大小: %.2f KB", imageData.length / 1024.0);
        
        [formData appendPartWithFileData:imageData 
                                    name:@"file" 
                                fileName:@"idcard.jpg" 
                                mimeType:@"image/jpeg"];
    } 
                      progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"✅ 身份证图片上传成功");
        NSLog(@"✅ 响应数据: %@", responseObject);
        
        // 恢复原始的Content-Type
        [self.sessionManager.requestSerializer setValue:originalContentType forHTTPHeaderField:@"Content-Type"];
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"❌ 身份证图片上传失败");
        NSLog(@"❌ 错误信息: %@", error.localizedDescription);
        
        // 恢复原始的Content-Type
        [self.sessionManager.requestSerializer setValue:originalContentType forHTTPHeaderField:@"Content-Type"];
        
        // 打印HTTP响应状态码
        if (task.response && [task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            NSLog(@"❌ HTTP状态码: %ld", (long)httpResponse.statusCode);
        }
        
        if (failure) {
            failure(error);
        }
    }];
}

- (void)recognizeIdCardFaceWithImageUrl:(NSString *)imageUrl 
                               success:(JJRSuccessBlock)success 
                               failure:(JJRFailureBlock)failure {
    
    NSDictionary *params = @{@"url": imageUrl ?: @""};
    [self POST:JJR_IDENTITY_IDCARD_FACE params:params success:success failure:failure];
}

- (void)recognizeIdCardBackWithImageUrl:(NSString *)imageUrl 
                               success:(JJRSuccessBlock)success 
                               failure:(JJRFailureBlock)failure {
    
    NSDictionary *params = @{@"url": imageUrl ?: @""};
    [self POST:JJR_IDENTITY_IDCARD_BACK params:params success:success failure:failure];
}

- (void)saveIdCardInfoWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure {
    [self POST:JJR_IDENTITY_SAVE params:params success:success failure:failure];
}



#pragma mark - 银行卡相关接口

- (void)getBankCardListWithSuccess:(JJRSuccessBlock)success 
                          failure:(JJRFailureBlock)failure {
    [self POST:JJR_BANK_CARD_LIST params:@{} success:success failure:failure];
}

- (void)addBankCardWithParams:(NSDictionary *)params 
                     success:(JJRSuccessBlock)success 
                     failure:(JJRFailureBlock)failure {
    [self POST:JJR_BANK_CARD_ADD params:params success:success failure:failure];
}

- (void)deleteBankCardWithCardId:(NSString *)cardId 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure {
    
    NSDictionary *params = @{@"cardId": cardId ?: @""};
    [self POST:JJR_BANK_CARD_DELETE params:params success:success failure:failure];
}

#pragma mark - 申请记录相关接口

- (void)getApplyRecordWithSuccess:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure {
    [self POST:JJR_APPLY_RECORD params:@{} success:success failure:failure];
}

- (void)getRepaymentPlanWithSuccess:(JJRSuccessBlock)success 
                           failure:(JJRFailureBlock)failure {
    [self POST:JJR_REPAYMENT_PLAN params:@{} success:success failure:failure];
}

// 获取还款计划（带贷款编号）
- (void)getRepaymentPlanWithLoanNo:(NSString *)loanNo 
                           success:(JJRSuccessBlock)success 
                           failure:(JJRFailureBlock)failure {
    NSDictionary *params = @{
        @"loanNo": loanNo ?: @""
    };
    [self POST:JJR_REPAYMENT_PLAN params:params success:success failure:failure];
}

#pragma mark - 密码管理相关接口

- (void)initPasswordWithParams:(NSDictionary *)params 
                      success:(JJRSuccessBlock)success 
                      failure:(JJRFailureBlock)failure {
    [self POST:JJR_PASSWORD_INIT params:params success:success failure:failure];
}

- (void)modifyPasswordWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure {
//    [self POST:JJR_PASSWORD_MODIFY params:params success:success failure:failure];
}

- (void)updatePasswordWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure {
    [self POST:JJR_PASSWORD_UPDATE params:params success:success failure:failure];
}

- (void)forgetPasswordWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure {
    [self POST:JJR_PASSWORD_FORGET params:params success:success failure:failure];
}

#pragma mark - 验证码相关接口

- (void)sendCaptchaWithParams:(NSDictionary *)params 
                     success:(JJRSuccessBlock)success 
                     failure:(JJRFailureBlock)failure {
    [self POST:JJR_CAPTCHA_SEND params:params success:success failure:failure];
}

#pragma mark - 用户操作相关接口

- (void)logoutWithSuccess:(JJRSuccessBlock)success 
                 failure:(JJRFailureBlock)failure {
    [self POST:JJR_TOKEN_LOGOUT params:@{} success:success failure:failure];
}

- (void)cancelAccountWithSuccess:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure {
    [self POST:JJR_USERINFO_CANCEL params:@{} success:success failure:failure];
}

#pragma mark - 反馈相关接口

- (void)submitFeedbackWithParams:(NSDictionary *)params 
                        success:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure {
    [self POST:JJR_FEEDBACK_SUBMIT params:params success:success failure:failure];
}

- (void)submitOpinionWithParams:(NSDictionary *)params 
                       success:(JJRSuccessBlock)success 
                       failure:(JJRFailureBlock)failure {
    [self POST:JJR_OPINION_SUBMIT params:params success:success failure:failure];
}

#pragma mark - 其他接口

- (void)getAboutUsWithSuccess:(JJRSuccessBlock)success 
                     failure:(JJRFailureBlock)failure {
    [self POST:JJR_ABOUT_US params:@{} success:success failure:failure];
}

- (void)getDisclaimerWithSuccess:(JJRSuccessBlock)success 
                        failure:(JJRFailureBlock)failure {
    [self POST:JJR_DISCLAIMER params:@{} success:success failure:failure];
}

- (void)getSecurityManualWithSuccess:(JJRSuccessBlock)success 
                            failure:(JJRFailureBlock)failure {
    [self POST:JJR_SECURITY_MANUAL params:@{} success:success failure:failure];
}

- (void)getVersionInfoWithSuccess:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure {
    [self POST:JJR_VERSION_INFO params:@{} success:success failure:failure];
}

- (void)getNoticeWithSuccess:(JJRSuccessBlock)success 
                    failure:(JJRFailureBlock)failure {
    [self POST:JJR_NOTICE params:@{} success:success failure:failure];
}

- (void)getNotificationSettingsWithSuccess:(JJRSuccessBlock)success 
                                  failure:(JJRFailureBlock)failure {
    [self POST:JJR_NOTIFICATION_SETTINGS params:@{} success:success failure:failure];
}

- (void)setNotificationWithParams:(NSDictionary *)params 
                         success:(JJRSuccessBlock)success 
                         failure:(JJRFailureBlock)failure {
    [self POST:JJR_NOTIFICATION_SET params:params success:success failure:failure];
}

- (void)submitMessageWithParams:(NSDictionary *)params 
                       success:(JJRSuccessBlock)success 
                       failure:(JJRFailureBlock)failure {
    [self POST:JJR_MESSAGE_SUBMIT params:params success:success failure:failure];
}

#pragma mark - 文件上传相关接口

- (void)uploadImage:(UIImage *)image 
           success:(JJRSuccessBlock)success 
           failure:(JJRFailureBlock)failure {
    
    // 每次请求前重新生成动态请求头
    [self addUniAppHeaders];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, JJR_UPLOAD_IMAGE];
    
    // 临时保存并移除Content-Type，让AFNetworking自动设置multipart
    NSString *originalContentType = [self.sessionManager.requestSerializer valueForHTTPHeaderField:@"Content-Type"];
    [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
    
    [self.sessionManager POST:fullURL 
                   parameters:nil
                      headers:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData 
                                    name:@"file" 
                                fileName:@"image.jpg" 
                                mimeType:@"image/jpeg"];
    } 
                      progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 恢复原始的Content-Type
        [self.sessionManager.requestSerializer setValue:originalContentType forHTTPHeaderField:@"Content-Type"];
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 恢复原始的Content-Type
        [self.sessionManager.requestSerializer setValue:originalContentType forHTTPHeaderField:@"Content-Type"];
        
        if (failure) {
            failure(error);
        }
    }];
}

- (void)uploadFile:(NSData *)fileData 
          fileName:(NSString *)fileName 
          mimeType:(NSString *)mimeType 
          success:(JJRSuccessBlock)success 
          failure:(JJRFailureBlock)failure {
    
    // 每次请求前重新生成动态请求头
    [self addUniAppHeaders];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, JJR_UPLOAD_FILE];
    
    // 临时保存并移除Content-Type，让AFNetworking自动设置multipart
    NSString *originalContentType = [self.sessionManager.requestSerializer valueForHTTPHeaderField:@"Content-Type"];
    [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
    
    [self.sessionManager POST:fullURL 
                   parameters:nil
                      headers:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData 
                                    name:@"file" 
                                fileName:fileName 
                                mimeType:mimeType];
    } 
                      progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 恢复原始的Content-Type
        [self.sessionManager.requestSerializer setValue:originalContentType forHTTPHeaderField:@"Content-Type"];
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 恢复原始的Content-Type
        [self.sessionManager.requestSerializer setValue:originalContentType forHTTPHeaderField:@"Content-Type"];
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 通用方法

- (void)GET:(NSString *)url 
     params:( NSDictionary * _Nullable )params
   success:(JJRSuccessBlock)success
   failure:(JJRFailureBlock)failure {
    
    // 每次请求前重新生成动态请求头
    [self addUniAppHeaders];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, url];
    
    // 详细的请求日志
    NSLog(@"📡 GET请求详情:");
    NSLog(@"📡 URL: %@", fullURL);
    
    // 格式化输出请求参数，支持中文显示
    if (params) {
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramsString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
        NSLog(@"📡 请求参数: %@", paramsString);
    } else {
        NSLog(@"📡 请求参数: 无");
    }
    
    // 格式化输出请求头，支持中文显示
    NSDictionary *headers = self.sessionManager.requestSerializer.HTTPRequestHeaders;
    if (headers) {
        NSData *headersData = [NSJSONSerialization dataWithJSONObject:headers options:NSJSONWritingPrettyPrinted error:nil];
        NSString *headersString = [[NSString alloc] initWithData:headersData encoding:NSUTF8StringEncoding];
        NSLog(@"📡 请求头: %@", headersString);
    } else {
        NSLog(@"📡 请求头: 无");
    }
    
    [self.sessionManager GET:fullURL 
                  parameters:params
                      headers:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"✅ GET请求成功: %@", fullURL);
        
        // 格式化输出响应数据，支持中文显示
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"✅ 响应数据: %@", jsonString);
        
        // 检查token失效
        if ([self checkTokenInvalid:responseObject]) {
            return; // 如果token失效，不继续执行success回调
        }
        
        // 检查响应码（和uni-app保持一致，只有code == 0才算成功）
        NSNumber *code = responseObject[@"code"];
        if (!code || [code integerValue] != 0) {
            // 如果code不是0，表示失败
            NSDictionary *error = responseObject[@"err"];
            NSString *errorMsg = error[@"msg"] ?: @"请求失败";
            
            NSLog(@"❌ 请求失败: code=%@, msg=%@", code, errorMsg);
            
            NSError *requestError = [NSError errorWithDomain:@"JJRNetworkError" 
                                                        code:[code integerValue] 
                                                    userInfo:@{NSLocalizedDescriptionKey: errorMsg}];
            if (failure) {
                failure(requestError);
            }
            return;
        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"❌ GET请求失败: %@", fullURL);
        NSLog(@"❌ 错误信息: %@", error.localizedDescription);
        
        // 如果有响应数据，也格式化显示
        if (task.response && [task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            NSLog(@"❌ HTTP状态码: %ld", (long)httpResponse.statusCode);
        }
        
        if (failure) {
            failure(error);
        }
    }];
}

- (void)POST:(NSString *)url 
      params:(NSDictionary * _Nullable)params 
    success:(JJRSuccessBlock)success 
    failure:(JJRFailureBlock)failure {
    
    // 每次请求前重新生成动态请求头
    [self addUniAppHeaders];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, url];
    
    // 详细的请求日志
    NSLog(@"📡 POST请求详情:");
    NSLog(@"📡 URL: %@", fullURL);
    
    // 格式化输出请求参数，支持中文显示
    if (params) {
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramsString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
        NSLog(@"📡 请求参数: %@", paramsString);
    } else {
        NSLog(@"📡 请求参数: 无");
    }
    
    // 格式化输出请求头，支持中文显示
    NSDictionary *headers = self.sessionManager.requestSerializer.HTTPRequestHeaders;
    if (headers) {
        NSData *headersData = [NSJSONSerialization dataWithJSONObject:headers options:NSJSONWritingPrettyPrinted error:nil];
        NSString *headersString = [[NSString alloc] initWithData:headersData encoding:NSUTF8StringEncoding];
        NSLog(@"📡 请求头: %@", headersString);
    } else {
        NSLog(@"📡 请求头: 无");
    }
    
    [self.sessionManager POST:fullURL 
                   parameters:params
                      headers:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"✅ POST请求成功: %@", fullURL);
        
        // 格式化输出响应数据，支持中文显示
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"✅ 响应数据: %@", jsonString);
        
        // 检查token失效
        if ([self checkTokenInvalid:responseObject]) {
            return; // 如果token失效，不继续执行success回调
        }
        
        // 检查响应码（和uni-app保持一致，只有code == 0才算成功）
        NSNumber *code = responseObject[@"code"];
        if (!code || [code integerValue] != 0) {
            // 如果code不是0，表示失败
            NSDictionary *error = responseObject[@"err"];
            NSString *errorMsg = error[@"msg"] ?: @"请求失败";
            
            NSLog(@"❌ 请求失败: code=%@, msg=%@", code, errorMsg);
            
            NSError *requestError = [NSError errorWithDomain:@"JJRNetworkError" 
                                                        code:[code integerValue] 
                                                    userInfo:@{NSLocalizedDescriptionKey: errorMsg}];
            if (failure) {
                failure(requestError);
            }
            return;
        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"❌ POST请求失败: %@", fullURL);
        NSLog(@"❌ 错误信息: %@", error.localizedDescription);
        
        // 如果有响应数据，也格式化显示
        if (task.response && [task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            NSLog(@"❌ HTTP状态码: %ld", (long)httpResponse.statusCode);
        }
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 授权相关接口

- (void)getAuthorityNumberWithSuccess:(JJRSuccessBlock)success 
                             failure:(JJRFailureBlock)failure {
    [self POST:@"/app/form/authority/num" params:@{} success:success failure:failure];
}

- (void)getAuthorizationAgreementWithAppId:(NSString *)appId 
                                    aupage:(NSNumber *)aupage 
                                   success:(JJRSuccessBlock)success 
                                   failure:(JJRFailureBlock)failure {
    NSDictionary *params = @{
        @"appId": appId ?: @"JJR",
        @"aupage": aupage ?: @1
    };
    [self GET:@"/app/agreement/authorization" params:params success:success failure:failure];
}

- (void)submitMerchantApplyWithSuccess:(JJRSuccessBlock)success 
                              failure:(JJRFailureBlock)failure {
    [self POST:@"/app/form/merchant/apply" params:@{} success:success failure:failure];
}

#pragma mark - Token失效处理

// 检查token是否失效
- (BOOL)checkTokenInvalid:(NSDictionary *)response {
    if (!response) return NO;
    
    // 检查是否为token失效错误
    NSNumber *code = response[@"code"];
    NSDictionary *error = response[@"err"];
    
    if (code && [code integerValue] == -1 && error) {
        NSString *errorCode = error[@"code"];
        NSString *errorMsg = error[@"msg"];
        
        if ([errorCode isEqualToString:@"LoginUser.Invalid"]) {
            NSLog(@"🚨 检测到token失效: %@", errorMsg);
            [self handleTokenInvalid:errorMsg];
            return YES;
        }
    }
    
    return NO;
}

// 获取当前显示的视图控制器
- (UIViewController *)getCurrentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // iOS 13及以上版本的处理
    if (!keyWindow) {
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    keyWindow = windowScene.windows.firstObject;
                    break;
                }
            }
        }
    }
    
    UIViewController *rootVC = keyWindow.rootViewController;
    return [self findCurrentViewController:rootVC];
}

- (UIViewController *)findCurrentViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self findCurrentViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)vc;
        return [self findCurrentViewController:navVC.topViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)vc;
        return [self findCurrentViewController:tabVC.selectedViewController];
    } else {
        return vc;
    }
}

// 处理token失效
- (void)handleTokenInvalid:(NSString *)message {
    NSLog(@"🚨 处理token失效，清除用户数据并跳转到登录页");
    
    // 主线程执行UI相关操作
    dispatch_async(dispatch_get_main_queue(), ^{
        // 检查当前是否已经在登录页面，避免重复跳转
        UIViewController *currentVC = [self getCurrentViewController];
        if ([currentVC isKindOfClass:NSClassFromString(@"LoginViewController")]) {
            NSLog(@"🚨 当前已在登录页面，不重复跳转");
            return;
        }
        
        // 显示提示信息
        [JJRNetworkService showToast:message ?: @"登录信息已失效"];
        
        // 清除用户数据
        [[JJRUserManager sharedManager] logout];
        
        // 延迟跳转到登录页面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self navigateToLogin];
        });
    });
}

// 跳转到登录页面
- (void)navigateToLogin {
    // 获取当前应用的主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // iOS 13及以上版本的处理
    if (!keyWindow) {
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    keyWindow = windowScene.windows.firstObject;
                    break;
                }
            }
        }
    }
    
    if (keyWindow) {
        // 导入LoginViewController
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        navController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        // 设置为根视图控制器
        keyWindow.rootViewController = navController;
        [keyWindow makeKeyAndVisible];
        
        NSLog(@"🎯 已跳转到登录页面");
    } else {
        NSLog(@"⚠️ 无法获取主窗口，跳转登录页面失败");
    }
}

#pragma mark - 工具方法

+ (void)showLoading {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = @"加载中...";
}

+ (void)hideLoading {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:window animated:YES];
}

+ (void)showToast:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

#pragma mark - 工具方法

// MD5加密
- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

// MD5加密
+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

// 手机号加密 - 使用AES加密，和uni-app保持一致
+ (NSString *)encryptMobile:(NSString *)mobile {
    if (!mobile || mobile.length == 0) return @"";
    
    // 获取token
    NSString *token = [[JJRUserManager sharedManager] getCurrentToken];
    if (!token || token.length < 16) {
        NSLog(@"⚠️ Token不存在或长度不够，使用简单MD5加密");
        return [self md5:mobile];
    }
    
    // 获取token的后16位作为key
    NSString *keyString = [token substringFromIndex:token.length - 16];
    
    // 计算mobile的MD5值，取前16位作为IV
    NSString *mobileMd5 = [self md5:mobile];
    NSString *ivString = [mobileMd5 substringToIndex:16];
    
    // 使用AES-128-CBC加密
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [ivString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *mobileData = [mobile dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *encryptedData = [NSMutableData dataWithLength:mobileData.length + kCCBlockSizeAES128];
    size_t encryptedLength = 0;
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt,
                                   kCCAlgorithmAES128,
                                   kCCOptionPKCS7Padding,
                                   keyData.bytes,
                                   keyData.length,
                                   ivData.bytes,
                                   mobileData.bytes,
                                   mobileData.length,
                                   encryptedData.mutableBytes,
                                   encryptedData.length,
                                   &encryptedLength);
    
    if (result == kCCSuccess) {
        encryptedData.length = encryptedLength;
        // 转换为Base64
        NSString *base64String = [encryptedData base64EncodedStringWithOptions:0];
        // 将Base64转换为十六进制
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
        return [self dataToHexString:base64Data];
    } else {
        NSLog(@"⚠️ AES加密失败，使用简单MD5加密");
        return [self md5:mobile];
    }
}

// 手机号MD5
+ (NSString *)encryptMobileMd5:(NSString *)mobile {
    if (!mobile || mobile.length == 0) return @"";
    return [self md5:mobile];
}

// 数据转十六进制字符串
+ (NSString *)dataToHexString:(NSData *)data {
    if (!data) return @"";
    
    NSMutableString *hexString = [NSMutableString stringWithCapacity:data.length * 2];
    const unsigned char *bytes = data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        [hexString appendFormat:@"%02x", bytes[i]];
    }
    return hexString;
}

@end 
