//
//  LoanAssessmentStepView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJRLoanAssessmentViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface LoanAssessmentStepView : UIView

- (instancetype)initWithViewModel:(JJRLoanAssessmentViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END 