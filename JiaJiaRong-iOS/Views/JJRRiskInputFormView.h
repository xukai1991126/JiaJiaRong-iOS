//
//  JJRRiskInputFormView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRRiskAssessmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JJRRiskInputFormView;

@protocol JJRRiskInputFormViewDelegate <NSObject>

- (void)riskInputFormView:(JJRRiskInputFormView *)formView didUpdateProfile:(JJRUserRiskProfile *)profile;
- (void)riskInputFormViewDidTapAssessment:(JJRRiskInputFormView *)formView;

@end

@interface JJRRiskInputFormView : UIView

@property (nonatomic, weak) id<JJRRiskInputFormViewDelegate> delegate;
@property (nonatomic, strong) JJRUserRiskProfile *userProfile;

- (instancetype)initWithUserProfile:(JJRUserRiskProfile *)profile;
- (void)updateAssessmentButtonState:(BOOL)isLoading;

@end

NS_ASSUME_NONNULL_END 