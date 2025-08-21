//
//  LoanAssessmentStep3View.h
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJRLoanAssessmentViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface LoanAssessmentStep3View : UIView

- (instancetype)initWithViewModel:(JJRLoanAssessmentViewModel *)viewModel;
- (void)updateDisplay;

@end

NS_ASSUME_NONNULL_END 
