//
//  JJRAIAdviceCardView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRAILoanAdvice.h"

NS_ASSUME_NONNULL_BEGIN

@class JJRAIAdviceCardView;

@protocol JJRAIAdviceCardViewDelegate <NSObject>

- (void)adviceCardView:(JJRAIAdviceCardView *)view didSelectAdvice:(JJRAILoanAdvice *)advice;
- (void)adviceCardView:(JJRAIAdviceCardView *)view didRequestDetailsForAdvice:(JJRAILoanAdvice *)advice;

@end

@interface JJRAIAdviceCardView : UIView

@property (nonatomic, weak) id<JJRAIAdviceCardViewDelegate> delegate;
@property (nonatomic, strong) JJRAILoanAdvice *advice;
@property (nonatomic, assign) BOOL isRecommended;

- (instancetype)initWithAdvice:(JJRAILoanAdvice *)advice;
- (void)updateWithAdvice:(JJRAILoanAdvice *)advice;

@end

NS_ASSUME_NONNULL_END 