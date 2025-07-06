//
//  JJRPasswordModifyView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRPasswordModifyBlock)(NSString *oldPassword, NSString *newPassword, NSString *confirmPassword);

@interface JJRPasswordModifyView : UIView

@property (nonatomic, copy) JJRPasswordModifyBlock modifyPasswordBlock;

@end

NS_ASSUME_NONNULL_END 