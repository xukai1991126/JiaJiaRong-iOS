//
//  JJRFeedbackView.h
//  JiaJiaRong-iOS
//
//  Created by json on 2025/7/5.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRSubmitFeedbackBlock)(NSString *content);

@interface JJRFeedbackView : UIView

@property (nonatomic, copy) JJRSubmitFeedbackBlock submitFeedbackBlock;

- (void)clearContent;

@end

NS_ASSUME_NONNULL_END 
