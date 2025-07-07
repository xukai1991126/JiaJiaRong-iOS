#import "NetworkService.h"
#import "JJRUserManager.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface NetworkService ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSString *baseURL;

@end

@implementation NetworkService

+ (instancetype)sharedInstance {
    static NetworkService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkService alloc] init];
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
    self.baseURL = JJR_BASE_URL; // 使用统一的API地址
    
    self.sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 设置超时时间
    self.sessionManager.requestSerializer.timeoutInterval = 30.0;
    
    // 设置请求头
    [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 添加token到请求头（使用JJRUserManager获取）
    NSString *token = [[JJRUserManager sharedManager] getCurrentToken];
    if (token) {
        [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
        NSLog(@"🎯 NetworkService - 添加Token到请求头: %@", token);
    } else {
        NSLog(@"🎯 NetworkService - Token不存在，不添加到请求头");
    }
}

#pragma mark - Public Methods

- (void)GET:(NSString *)url 
     params:(NSDictionary *)params 
   success:(SuccessBlock)success 
   failure:(FailureBlock)failure {
    
    // 记录请求开始时间
    NSDate *startTime = [NSDate date];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, url];
    
    // 详细的请求日志
    NSLog(@"📡 NetworkService GET请求详情:");
    NSLog(@"📡 URL: %@", fullURL);
    NSLog(@"📡 请求时间: %@", [self formatDate:startTime]);
    
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
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 计算请求耗时
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
        
        NSLog(@"✅ NetworkService GET请求成功: %@", fullURL);
        NSLog(@"✅ 请求耗时: %.3f 秒", duration);
        
        // 格式化输出响应数据，支持中文显示
        if (responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"✅ 响应数据: %@", jsonString);
        } else {
            NSLog(@"✅ 响应数据: 无");
        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 计算请求耗时
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
        
        NSLog(@"❌ NetworkService GET请求失败: %@", fullURL);
        NSLog(@"❌ 请求耗时: %.3f 秒", duration);
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
      params:(NSDictionary *)params 
    success:(SuccessBlock)success 
    failure:(FailureBlock)failure {
    
    // 记录请求开始时间
    NSDate *startTime = [NSDate date];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, url];
    
    // 详细的请求日志
    NSLog(@"📡 NetworkService POST请求详情:");
    NSLog(@"📡 URL: %@", fullURL);
    NSLog(@"📡 请求时间: %@", [self formatDate:startTime]);
    
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
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 计算请求耗时
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
        
        NSLog(@"✅ NetworkService POST请求成功: %@", fullURL);
        NSLog(@"✅ 请求耗时: %.3f 秒", duration);
        
        // 格式化输出响应数据，支持中文显示
        if (responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"✅ 响应数据: %@", jsonString);
        } else {
            NSLog(@"✅ 响应数据: 无");
        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 计算请求耗时
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
        
        NSLog(@"❌ NetworkService POST请求失败: %@", fullURL);
        NSLog(@"❌ 请求耗时: %.3f 秒", duration);
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

- (void)uploadImage:(UIImage *)image 
           success:(SuccessBlock)success 
           failure:(FailureBlock)failure {
    
    // 记录请求开始时间
    NSDate *startTime = [NSDate date];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@/app/upload/image", self.baseURL];
    
    // 详细的上传日志
    NSLog(@"📡 NetworkService 图片上传请求详情:");
    NSLog(@"📡 URL: %@", fullURL);
    NSLog(@"📡 请求时间: %@", [self formatDate:startTime]);
    NSLog(@"📡 文件类型: 图片 (image/jpeg)");
    NSLog(@"📡 压缩质量: 0.8");
    
    // 格式化输出请求头，支持中文显示
    NSDictionary *headers = self.sessionManager.requestSerializer.HTTPRequestHeaders;
    if (headers) {
        NSData *headersData = [NSJSONSerialization dataWithJSONObject:headers options:NSJSONWritingPrettyPrinted error:nil];
        NSString *headersString = [[NSString alloc] initWithData:headersData encoding:NSUTF8StringEncoding];
        NSLog(@"📡 请求头: %@", headersString);
    } else {
        NSLog(@"📡 请求头: 无");
    }
    
    [self.sessionManager POST:fullURL parameters:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSLog(@"📡 图片数据大小: %.2f KB", imageData.length / 1024.0);
        
        [formData appendPartWithFileData:imageData 
                                    name:@"file" 
                                fileName:@"image.jpg" 
                                mimeType:@"image/jpeg"];
    } progress:nil 
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 计算请求耗时
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
        
        NSLog(@"✅ NetworkService 图片上传成功: %@", fullURL);
        NSLog(@"✅ 请求耗时: %.3f 秒", duration);
        
        // 格式化输出响应数据，支持中文显示
        if (responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"✅ 响应数据: %@", jsonString);
        } else {
            NSLog(@"✅ 响应数据: 无");
        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 计算请求耗时
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
        
        NSLog(@"❌ NetworkService 图片上传失败: %@", fullURL);
        NSLog(@"❌ 请求耗时: %.3f 秒", duration);
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

#pragma mark - Helper Methods

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

// 格式化日期
- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    return [formatter stringFromDate:date];
}

@end 
