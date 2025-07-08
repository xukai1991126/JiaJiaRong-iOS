//
//  JJRToastTool.m
//  JiaJiaRong-iOS
//
//  Created by xk work's computer on 2025/7/8.
//

#import "JJRToastTool.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation JJRToastTool

+ (void)showToast:(NSString *)message inView:(UIView *)view {
    if (!view || !message.length) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

+ (void)showToastInKeWindow:(NSString *)message {
    if (!message.length) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

+ (void)showLoadingInView:(UIView *)view {
    if (!view) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"加载中...";
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideLoadingInView:(UIView *)view {
    if (!view) return;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)showSuccess:(NSString *)message inView:(UIView *)view {
    if (!view || !message.length) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    // 使用uni-app的成功图标
    UIImage *image = [UIImage imageNamed:@"hud_success"];
    if (!image) {
        // 如果图标不存在，创建一个简单的对勾图标
        image = [self createSuccessIcon];
    }
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

+ (void)showError:(NSString *)message inView:(UIView *)view {
    if (!view || !message.length) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    // 使用uni-app的错误图标
    UIImage *image = [UIImage imageNamed:@"hud_error"];
    if (!image) {
        // 如果图标不存在，创建一个简单的叉号图标
        image = [self createErrorIcon];
    }
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

+ (void)showWarning:(NSString *)message inView:(UIView *)view {
    if (!view || !message.length) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    // 使用uni-app的警告图标
    UIImage *image = [UIImage imageNamed:@"hud_warning"];
    if (!image) {
        // 如果图标不存在，创建一个简单的警告图标
        image = [self createWarningIcon];
    }
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

#pragma mark - Helper Methods for Icon Creation

+ (UIImage *)createSuccessIcon {
    CGSize size = CGSizeMake(37, 37); // 和uni-app图标差不多的尺寸
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绿色对勾
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    // 画对勾
    CGContextMoveToPoint(context, 10, 18);
    CGContextAddLineToPoint(context, 16, 24);
    CGContextAddLineToPoint(context, 27, 13);
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)createErrorIcon {
    CGSize size = CGSizeMake(37, 37); // 和uni-app图标差不多的尺寸
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 红色叉号
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // 画叉号
    CGContextMoveToPoint(context, 12, 12);
    CGContextAddLineToPoint(context, 25, 25);
    CGContextMoveToPoint(context, 25, 12);
    CGContextAddLineToPoint(context, 12, 25);
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)createWarningIcon {
    CGSize size = CGSizeMake(37, 37); // 和uni-app图标差不多的尺寸
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 橙色三角形
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    // 画三角形
    CGContextMoveToPoint(context, 18.5, 8);
    CGContextAddLineToPoint(context, 30, 28);
    CGContextAddLineToPoint(context, 7, 28);
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    // 画感叹号
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // 感叹号的竖线
    CGContextFillRect(context, CGRectMake(17, 14, 3, 8));
    
    // 感叹号的点
    CGContextFillEllipseInRect(context, CGRectMake(17, 24, 3, 3));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

