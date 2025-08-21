//
//  LoanAssessmentStepIndicatorView.h
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRLoanAssessmentViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoanAssessmentStepIndicatorView : UIView

- (void)updateWithCurrentStep:(LoanAssessmentStep)currentStep;

@end

NS_ASSUME_NONNULL_END 
