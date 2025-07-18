//
//  JJRFeedbackView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRSubmitFeedbackBlock)(NSString *content);

@interface JJRFeedbackView : UIView

@property (nonatomic, copy) JJRSubmitFeedbackBlock submitFeedbackBlock;

- (void)clearContent;

@end

NS_ASSUME_NONNULL_END 