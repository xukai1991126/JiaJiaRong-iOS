//
//  JJRRiskAssessmentViewModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJRRiskAssessmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JJRRiskAssessmentViewModelDelegate <NSObject>

@optional
- (void)riskAssessmentDidStartAnalyzing;
- (void)riskAssessmentDidFinishWithResult:(JJRRiskAssessmentResult *)result;
- (void)riskAssessmentDidFailWithError:(NSError *)error;

@end

@interface JJRRiskAssessmentViewModel : NSObject

@property (nonatomic, weak) id<JJRRiskAssessmentViewModelDelegate> delegate;
@property (nonatomic, strong) JJRUserRiskProfile *userProfile;
@property (nonatomic, strong, nullable) JJRRiskAssessmentResult *assessmentResult;
@property (nonatomic, assign, readonly) BOOL isAnalyzing;

// 数据源方法
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)titleForSection:(NSInteger)section;

// 风险评估
- (void)startRiskAssessment;
- (void)updateUserProfile:(JJRUserRiskProfile *)profile;

// 工具方法
- (NSString *)riskLevelDescription:(JJRRiskLevel)level;
- (UIColor *)colorForRiskLevel:(JJRRiskLevel)level;
- (NSString *)riskFactorTypeDescription:(JJRRiskFactorType)type;

@end

NS_ASSUME_NONNULL_END 