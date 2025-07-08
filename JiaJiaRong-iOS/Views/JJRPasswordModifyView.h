//
//  JJRPasswordModifyView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRSendCaptchaBlock)(NSString *mobile);
typedef void(^JJRPasswordUpdateBlock)(NSString *mobile, NSString *captcha, NSString *newPassword, NSString *confirmPassword);

@interface JJRPasswordModifyView : UIView

@property (nonatomic, copy) JJRSendCaptchaBlock sendCaptchaBlock;
@property (nonatomic, copy) JJRPasswordUpdateBlock passwordUpdateBlock;

// 设置手机号
- (void)setMobile:(NSString *)mobile;

// 开始验证码倒计时
- (void)startCaptchaCountdown;

@end

NS_ASSUME_NONNULL_END 