//
//  LoanAssessmentStep1View.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJRLoanAssessmentViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface LoanAssessmentStep1View : UIView

- (instancetype)initWithViewModel:(JJRLoanAssessmentViewModel *)viewModel;
- (void)updateDisplay;

@end

NS_ASSUME_NONNULL_END 