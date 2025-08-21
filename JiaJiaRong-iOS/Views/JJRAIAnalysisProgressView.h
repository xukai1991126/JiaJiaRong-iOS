//
//  JJRAIAnalysisProgressView.h
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRAIAnalysisProgressView : UIView

@property (nonatomic, assign) CGFloat progress; // 0.0 - 1.0
@property (nonatomic, strong) NSString *statusMessage;

- (void)startAnimation;
- (void)stopAnimation;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END 
