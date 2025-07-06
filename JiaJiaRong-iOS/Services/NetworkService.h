#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JJRAPIDefines.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(NSDictionary *response);
typedef void(^FailureBlock)(NSError *error);

@interface NetworkService : NSObject

+ (instancetype)sharedInstance;

// GET请求
- (void)GET:(NSString *)url 
     params:(NSDictionary *)params 
   success:(SuccessBlock)success 
   failure:(FailureBlock)failure;

// POST请求
- (void)POST:(NSString *)url 
      params:(NSDictionary *)params 
    success:(SuccessBlock)success 
    failure:(FailureBlock)failure;

// 上传图片
- (void)uploadImage:(UIImage *)image 
           success:(SuccessBlock)success 
           failure:(FailureBlock)failure;

// 显示加载提示
+ (void)showLoading;

// 隐藏加载提示
+ (void)hideLoading;

// 显示Toast提示
+ (void)showToast:(NSString *)message;

@end

NS_ASSUME_NONNULL_END 
