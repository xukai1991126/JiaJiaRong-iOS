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
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, url];
    

    [self.sessionManager GET:fullURL 
                  parameters:params
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)POST:(NSString *)url 
      params:(NSDictionary *)params 
    success:(SuccessBlock)success 
    failure:(FailureBlock)failure {
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, url];
    
    [self.sessionManager POST:fullURL 
                   parameters:params
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)uploadImage:(UIImage *)image 
           success:(SuccessBlock)success 
           failure:(FailureBlock)failure {
    
    NSString *fullURL = [NSString stringWithFormat:@"%@/app/upload/image", self.baseURL];
    
    
    [self.sessionManager POST:fullURL parameters:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData 
                                    name:@"file" 
                                fileName:@"image.jpg" 
                                mimeType:@"image/jpeg"];
    } progress:nil 
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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

@end 
