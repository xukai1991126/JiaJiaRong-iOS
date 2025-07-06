//
//  JJRLaunchView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRLaunchView : UIView

@property (nonatomic, copy) void(^launchCompleted)(void);

- (void)startLaunchAnimation;
- (void)showUpdateDialog:(NSString *)version content:(NSString *)content forceUpdate:(BOOL)force;

@end

NS_ASSUME_NONNULL_END 