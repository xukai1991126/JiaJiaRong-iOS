//
//  LoanAssessmentStepIndicatorView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRLoanAssessmentViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoanAssessmentStepIndicatorView : UIView

- (void)updateWithCurrentStep:(LoanAssessmentStep)currentStep;

@end

NS_ASSUME_NONNULL_END 