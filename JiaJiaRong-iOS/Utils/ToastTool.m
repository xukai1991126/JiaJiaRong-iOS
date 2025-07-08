//
//  ToastTool.m
//  JiaJiaRong-iOS
//
//  Created by xk work's computer on 2025/7/8.
//

#import "ToastTool.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation ToastTool

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
    UIImage *image = [[UIImage imageNamed:@"hud_success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

+ (void)showError:(NSString *)message inView:(UIView *)view {
    if (!view || !message.length) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"hud_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

@end

