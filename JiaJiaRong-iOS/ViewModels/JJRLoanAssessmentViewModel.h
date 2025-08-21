//
//  JJRLoanAssessmentViewModel.h
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LoanAssessmentStep) {
    LoanAssessmentStepAmount = 0,    // 额度需求
    LoanAssessmentStepCredit = 1,    // 个人信用
    LoanAssessmentStepAsset = 2,     // 个人资产
    LoanAssessmentStepIncome = 3     // 月收入
};

@protocol JJRLoanAssessmentViewModelDelegate <NSObject>

- (void)viewModelDidUpdateStep;
- (void)viewModelDidCompleteAssessment;

@end

@interface JJRLoanAssessmentViewModel : NSObject

@property (nonatomic, weak) id<JJRLoanAssessmentViewModelDelegate> delegate;
@property (nonatomic, assign) LoanAssessmentStep currentStep;
@property (nonatomic, strong, readonly) NSArray<NSArray<NSString *> *> *allOptions;
@property (nonatomic, strong, readonly) NSMutableArray *selectedIndexes;

// 步骤管理
- (NSArray<NSString *> *)optionsForCurrentStep;
- (id)selectedForCurrentStep;
- (void)selectOptionAtIndex:(NSInteger)index;
- (void)deselectOptionAtIndex:(NSInteger)index;
- (void)goToNextStep;
- (void)goToPreviousStep;
- (BOOL)isLastStep;
- (BOOL)isFirstStep;
- (BOOL)canProceedToNextStep;
- (BOOL)isMultiSelectStep;

// 界面信息
- (NSString *)titleForCurrentStep;
- (NSString *)subtitleForCurrentStep;
- (NSString *)nextButtonTitleForCurrentStep;

@end

NS_ASSUME_NONNULL_END 
