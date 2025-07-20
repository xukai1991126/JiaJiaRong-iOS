//
//  JJRAILoanAdvisorViewModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseViewModel.h"
#import "JJRAILoanAdvice.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRAILoanAdvisorViewModel : JJRBaseViewModel

@property (nonatomic, strong) JJRAIUserProfile *userProfile;
@property (nonatomic, strong, readonly) NSArray<JJRAILoanAdvice *> *loanAdvices;
@property (nonatomic, strong, readonly) JJRAILoanAdvice *bestAdvice;

// 输入用户信息
- (void)updateUserProfile:(JJRAIUserProfile *)profile;

// 获取AI建议
- (void)generateLoanAdvices;

// 获取特定类型的建议
- (void)generateAdviceForLoanType:(JJRAILoanType)loanType;

// 计算还款详情
- (NSArray *)calculateRepaymentPlan:(JJRAILoanAdvice *)advice;

// 风险评估
- (NSString *)assessRiskLevel:(JJRAIUserProfile *)profile;

// 格式化显示
- (NSString *)formatAmount:(NSNumber *)amount;
- (NSString *)formatInterestRate:(NSNumber *)rate;
- (NSString *)loanTypeDescription:(JJRAILoanType)type;
- (NSString *)repaymentTypeDescription:(JJRAIRepaymentType)type;

@end

NS_ASSUME_NONNULL_END 