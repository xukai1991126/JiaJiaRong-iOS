//
//  JJRLoanAssessmentViewModel.m
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRLoanAssessmentViewModel.h"

@interface JJRLoanAssessmentViewModel ()

@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *allOptions;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;

@end

@implementation JJRLoanAssessmentViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentStep = LoanAssessmentStepAmount;
        
        // Mock数据 - 弱化"贷款"字眼，突出"融资担保"
        _allOptions = @[
            @[@"20万以上", @"10万-20万", @"5万-10万", @"1万-5万"], // 额度需求
            @[@"当前无逾期", @"当前有逾期"], // 个人信用
            @[@"有商品房", @"有车", @"有公积金", @"有营业执照", @"有社保"], // 个人资产
            @[@"2万以上", @"1万-2万", @"5000-1万", @"5000以下"] // 月收入
        ];
        
        // 初始化选中状态：单选用NSNumber(-1表示未选)，多选用NSMutableSet
        _selectedIndexes = [NSMutableArray arrayWithObjects:
                           @(-1), // 步骤1：额度需求 (单选)
                           @(-1), // 步骤2：个人信用 (单选)
                           [NSMutableSet set], // 步骤3：个人资产 (多选)
                           @(-1), // 步骤4：月收入 (单选)
                           nil];
    }
    return self;
}

#pragma mark - 步骤管理

- (NSArray<NSString *> *)optionsForCurrentStep {
    return self.allOptions[self.currentStep];
}

- (id)selectedForCurrentStep {
    return self.selectedIndexes[self.currentStep];
}

- (void)selectOptionAtIndex:(NSInteger)index {
    if ([self isMultiSelectStep]) {
        NSMutableSet *set = self.selectedIndexes[self.currentStep];
        [set addObject:@(index)];
    } else {
        self.selectedIndexes[self.currentStep] = @(index);
    }
}

- (void)deselectOptionAtIndex:(NSInteger)index {
    if ([self isMultiSelectStep]) {
        NSMutableSet *set = self.selectedIndexes[self.currentStep];
        [set removeObject:@(index)];
    }
}

- (void)goToNextStep {
    if (self.currentStep < LoanAssessmentStepIncome) {
        self.currentStep++;
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelDidUpdateStep)]) {
            [self.delegate viewModelDidUpdateStep];
        }
    } else {
        // 最后一步，完成评估
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelDidCompleteAssessment)]) {
            [self.delegate viewModelDidCompleteAssessment];
        }
    }
}

- (void)goToPreviousStep {
    if (self.currentStep > LoanAssessmentStepAmount) {
        self.currentStep--;
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelDidUpdateStep)]) {
            [self.delegate viewModelDidUpdateStep];
        }
    }
}

- (BOOL)isLastStep {
    return self.currentStep == LoanAssessmentStepIncome;
}

- (BOOL)isFirstStep {
    return self.currentStep == LoanAssessmentStepAmount;
}

- (BOOL)canProceedToNextStep {
    if ([self isMultiSelectStep]) {
        NSMutableSet *set = self.selectedIndexes[self.currentStep];
        return set.count > 0;
    } else {
        NSNumber *selected = self.selectedIndexes[self.currentStep];
        return selected && [selected integerValue] >= 0;
    }
}

- (BOOL)isMultiSelectStep {
    return self.currentStep == LoanAssessmentStepAsset; // 只有资产步骤是多选
}

#pragma mark - 界面信息

- (NSString *)titleForCurrentStep {
    switch (self.currentStep) {
        case LoanAssessmentStepAmount:
            return @"评估1/4";
        case LoanAssessmentStepCredit:
            return @"评估2/4";
        case LoanAssessmentStepAsset:
            return @"评估3/4";
        case LoanAssessmentStepIncome:
            return @"评估4/4";
        default:
            return @"额度评估";
    }
}

- (NSString *)subtitleForCurrentStep {
    return @"请您完善资料，我们将为您出具专属授信额度！";
}

- (NSString *)nextButtonTitleForCurrentStep {
    if ([self isLastStep]) {
        return @"获取授信额度";
    } else {
        return @"下一步";
    }
}

@end 
