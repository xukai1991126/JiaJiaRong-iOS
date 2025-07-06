//
//  JJRPasswordForgetView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRSendCodeBlock)(NSString *phone);
typedef void(^JJRResetPasswordBlock)(NSString *phone, NSString *code, NSString *newPassword, NSString *confirmPassword);

@interface JJRPasswordForgetView : UIView

@property (nonatomic, copy) JJRSendCodeBlock sendCodeBlock;
@property (nonatomic, copy) JJRResetPasswordBlock resetPasswordBlock;

- (void)startCountdown;

@end

NS_ASSUME_NONNULL_END 