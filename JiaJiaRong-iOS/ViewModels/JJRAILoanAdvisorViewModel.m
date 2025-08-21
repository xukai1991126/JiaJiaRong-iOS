//
//  JJRAILoanAdvisorViewModel.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRAILoanAdvisorViewModel.h"

@interface JJRAILoanAdvisorViewModel ()

@property (nonatomic, strong) NSArray<JJRAILoanAdvice *> *loanAdvices;
@property (nonatomic, strong) JJRAILoanAdvice *bestAdvice;

@end

@implementation JJRAILoanAdvisorViewModel

- (instancetype)init {
    if (self = [super init]) {
        _userProfile = [[JJRAIUserProfile alloc] init];
        _loanAdvices = @[];
    }
    return self;
}

- (void)updateUserProfile:(JJRAIUserProfile *)profile {
    self.userProfile = profile;
    [self updateData];
}

- (void)generateLoanAdvices {
    NSLog(@"🧠 ViewModel开始生成贷款建议");
    [self startLoading];
    
    // 模拟AI分析过程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"🔍 AI分析后台处理中...");
        
        NSMutableArray *advices = [NSMutableArray array];
        
        // 根据用户资料生成不同类型的贷款建议
        [advices addObject:[self generatePersonalLoanAdvice]];
        [advices addObject:[self generateCreditLoanAdvice]];
        
        if (self.userProfile.hasHouse) {
            [advices addObject:[self generateMortgageLoanAdvice]];
        }
        
        if ([self.userProfile.employmentType isEqualToString:@"个体经营"] || 
            [self.userProfile.employmentType isEqualToString:@"企业主"]) {
            [advices addObject:[self generateBusinessLoanAdvice]];
        }
        
        // 按信心度排序，选择最佳建议
        [advices sortUsingComparator:^NSComparisonResult(JJRAILoanAdvice *obj1, JJRAILoanAdvice *obj2) {
            if (obj1.confidence > obj2.confidence) return NSOrderedAscending;
            if (obj1.confidence < obj2.confidence) return NSOrderedDescending;
            return NSOrderedSame;
        }];
        
        self.loanAdvices = [advices copy];
        self.bestAdvice = advices.firstObject;
        
        NSLog(@"✅ 生成了 %lu 个贷款建议", (unsigned long)advices.count);
        
        [self finishLoading];
        
        // 发送通知而不是使用delegate
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"📢 发送ViewModel更新通知");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JJRAILoanAdvisorViewModel_AdvicesUpdated" 
                                                                object:self];
        });
    });
}

- (JJRAILoanAdvice *)generatePersonalLoanAdvice {
    JJRAILoanAdvice *advice = [[JJRAILoanAdvice alloc] init];
    advice.loanType = JJRAILoanTypePersonal;
    advice.repaymentType = JJRAIRepaymentTypeEqual;
    
    // AI算法计算推荐金额 (基于收入的3-5倍)
    CGFloat incomeMultiplier = [self calculateIncomeMultiplier];
    advice.recommendedAmount = @([self.userProfile.monthlyIncome floatValue] * incomeMultiplier * 12);
    
    // 根据信用评分确定利率
    advice.interestRate = [self calculateInterestRate];
    
    // 推荐期限
    advice.recommendedTerm = [self calculateRecommendedTerm];
    
    // 计算月还款额
    advice.monthlyPayment = [self calculateMonthlyPayment:advice];
    
    advice.reason = [self generateReasonForPersonalLoan];
    advice.riskAnalysis = [self assessRiskLevel:self.userProfile];
    advice.advantages = [self generateAdvantagesForPersonalLoan];
    advice.suggestions = [self generateSuggestionsForPersonalLoan];
    advice.confidence = [self calculateConfidence:advice];
    
    return advice;
}

- (JJRAILoanAdvice *)generateCreditLoanAdvice {
    JJRAILoanAdvice *advice = [[JJRAILoanAdvice alloc] init];
    advice.loanType = JJRAILoanTypeCredit;
    advice.repaymentType = JJRAIRepaymentTypeEqual;
    
    // 信用贷款额度相对保守
    advice.recommendedAmount = @([self.userProfile.monthlyIncome floatValue] * 2.5 * 12);
    advice.interestRate = @([[self calculateInterestRate] floatValue] + 0.02); // 利率稍高
    advice.recommendedTerm = 24; // 较短期限
    
    advice.monthlyPayment = [self calculateMonthlyPayment:advice];
    advice.reason = @"基于您的信用状况，信用贷款审批快速，无需抵押物，适合短期资金需求";
    advice.riskAnalysis = [self assessRiskLevel:self.userProfile];
    advice.advantages = @[@"审批速度快", @"无需抵押物", @"使用灵活"];
    advice.suggestions = @[@"建议保持良好的信用记录", @"按时还款提升信用额度"];
    advice.confidence = [self calculateConfidence:advice] - 0.1;
    
    return advice;
}

- (JJRAILoanAdvice *)generateMortgageLoanAdvice {
    JJRAILoanAdvice *advice = [[JJRAILoanAdvice alloc] init];
    advice.loanType = JJRAILoanTypeMortgage;
    advice.repaymentType = JJRAIRepaymentTypeEqual;
    
    // 房屋抵押可以贷更多
    advice.recommendedAmount = @([self.userProfile.monthlyIncome floatValue] * 8 * 12);
    advice.interestRate = @([[self calculateInterestRate] floatValue] - 0.015); // 利率较低
    advice.recommendedTerm = 60; // 较长期限
    
    advice.monthlyPayment = [self calculateMonthlyPayment:advice];
    advice.reason = @"您拥有房产作为抵押物，可获得较大额度和较低利率的贷款";
    advice.riskAnalysis = @"风险较低，有房产作为抵押保障";
    advice.advantages = @[@"额度大", @"利率低", @"期限灵活"];
    advice.suggestions = @[@"建议评估房产价值", @"考虑房产升值潜力"];
    advice.confidence = [self calculateConfidence:advice] + 0.2;
    
    return advice;
}

- (JJRAILoanAdvice *)generateBusinessLoanAdvice {
    JJRAILoanAdvice *advice = [[JJRAILoanAdvice alloc] init];
    advice.loanType = JJRAILoanTypeBusiness;
    advice.repaymentType = JJRAIRepaymentTypeInterestFirst;
    
    advice.recommendedAmount = @([self.userProfile.monthlyIncome floatValue] * 6 * 12);
    advice.interestRate = @([[self calculateInterestRate] floatValue] + 0.01);
    advice.recommendedTerm = 36;
    
    advice.monthlyPayment = [self calculateMonthlyPayment:advice];
    advice.reason = @"基于您的经营状况，经营贷款可为您的事业发展提供资金支持";
    advice.riskAnalysis = @"需要评估经营风险，建议提供经营相关证明材料";
    advice.advantages = @[@"支持事业发展", @"还款方式灵活", @"可循环使用"];
    advice.suggestions = @[@"准备经营流水证明", @"保持良好的经营状况"];
    advice.confidence = [self calculateConfidence:advice];
    
    return advice;
}

#pragma mark - Helper Methods

- (CGFloat)calculateIncomeMultiplier {
    CGFloat creditScore = [self.userProfile.creditScore floatValue];
    CGFloat debtRatio = [self.userProfile.currentDebt floatValue] / [self.userProfile.monthlyIncome floatValue];
    
    CGFloat multiplier = 3.0;
    
    if (creditScore > 750) multiplier += 1.0;
    else if (creditScore > 650) multiplier += 0.5;
    
    if (debtRatio < 0.3) multiplier += 0.5;
    else if (debtRatio > 0.6) multiplier -= 1.0;
    
    return MAX(2.0, MIN(6.0, multiplier));
}

- (NSNumber *)calculateInterestRate {
    CGFloat baseRate = 0.045; // 基准利率4.5%
    CGFloat creditScore = [self.userProfile.creditScore floatValue];
    
    if (creditScore > 750) baseRate -= 0.005;
    else if (creditScore < 600) baseRate += 0.015;
    
    if (self.userProfile.workYears > 5) baseRate -= 0.003;
    if (self.userProfile.hasHouse) baseRate -= 0.005;
    
    return @(baseRate);
}

- (NSInteger)calculateRecommendedTerm {
    CGFloat amount = [self.userProfile.monthlyIncome floatValue] * [self calculateIncomeMultiplier] * 12;
    
    if (amount < 100000) return 24;
    else if (amount < 300000) return 36;
    else return 48;
}

- (NSNumber *)calculateMonthlyPayment:(JJRAILoanAdvice *)advice {
    CGFloat amount = [advice.recommendedAmount floatValue];
    CGFloat monthlyRate = [advice.interestRate floatValue] / 12;
    NSInteger months = advice.recommendedTerm;
    
    CGFloat payment = amount * (monthlyRate * pow(1 + monthlyRate, months)) / (pow(1 + monthlyRate, months) - 1);
    
    return @(payment);
}

- (CGFloat)calculateConfidence:(JJRAILoanAdvice *)advice {
    CGFloat confidence = 0.6; // 基础信心度
    
    CGFloat paymentRatio = [advice.monthlyPayment floatValue] / [self.userProfile.monthlyIncome floatValue];
    
    if (paymentRatio < 0.3) confidence += 0.3;
    else if (paymentRatio < 0.5) confidence += 0.1;
    else if (paymentRatio > 0.7) confidence -= 0.2;
    
    CGFloat creditScore = [self.userProfile.creditScore floatValue];
    if (creditScore > 700) confidence += 0.2;
    else if (creditScore < 600) confidence -= 0.3;
    
    return MAX(0.1, MIN(1.0, confidence));
}

#pragma mark - Risk Assessment

- (NSString *)assessRiskLevel:(JJRAIUserProfile *)profile {
    CGFloat income = [profile.monthlyIncome floatValue];
    CGFloat debt = [profile.currentDebt floatValue];
    CGFloat creditScore = [profile.creditScore floatValue];
    
    CGFloat debtRatio = debt / income;
    
    if (creditScore > 700 && debtRatio < 0.3) {
        return @"低风险：信用状况良好，负债比例合理，还款能力强";
    } else if (creditScore > 600 && debtRatio < 0.5) {
        return @"中风险：信用状况一般，需要控制负债比例，按时还款";
    } else {
        return @"高风险：建议改善信用状况，降低负债比例后再申请";
    }
}

#pragma mark - Text Generation

- (NSString *)generateReasonForPersonalLoan {
    NSMutableString *reason = [NSMutableString string];
    
    [reason appendFormat:@"基于您的月收入%.0f元，信用评分%.0f分", 
     [self.userProfile.monthlyIncome floatValue], [self.userProfile.creditScore floatValue]];
    
    if (self.userProfile.workYears > 3) {
        [reason appendFormat:@"，%ld年稳定工作经验", (long)self.userProfile.workYears];
    }
    
    [reason appendString:@"，AI智能分析为您推荐此个人贷款方案"];
    
    return reason;
}

- (NSArray *)generateAdvantagesForPersonalLoan {
    NSMutableArray *advantages = [NSMutableArray array];
    
    [advantages addObject:@"利率优惠，还款压力适中"];
    [advantages addObject:@"期限合理，匹配您的还款能力"];
    
    if ([self.userProfile.creditScore floatValue] > 650) {
        [advantages addObject:@"信用状况良好，审批通过率高"];
    }
    
    if (self.userProfile.hasHouse || self.userProfile.hasCar) {
        [advantages addObject:@"资产状况良好，可获得更优条件"];
    }
    
    return advantages;
}

- (NSArray *)generateSuggestionsForPersonalLoan {
    NSMutableArray *suggestions = [NSMutableArray array];
    
    [suggestions addObject:@"建议按时还款，维护良好的信用记录"];
    [suggestions addObject:@"可考虑提前还款减少利息支出"];
    
    CGFloat paymentRatio = [[self.loanAdvices.firstObject monthlyPayment] floatValue] / [self.userProfile.monthlyIncome floatValue];
    if (paymentRatio > 0.4) {
        [suggestions addObject:@"还款比例较高，建议合理规划支出"];
    }
    
    [suggestions addObject:@"保持稳定收入来源，避免逾期还款"];
    
    return suggestions;
}

#pragma mark - Formatting

- (NSString *)formatAmount:(NSNumber *)amount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 0;
    return [NSString stringWithFormat:@"¥%@", [formatter stringFromNumber:amount]];
}

- (NSString *)formatInterestRate:(NSNumber *)rate {
    return [NSString stringWithFormat:@"%.2f%%", [rate floatValue] * 100];
}

- (NSString *)loanTypeDescription:(JJRAILoanType)type {
    switch (type) {
        case JJRAILoanTypePersonal: return @"个人消费贷款";
        case JJRAILoanTypeMortgage: return @"房屋抵押贷款";
        case JJRAILoanTypeBusiness: return @"经营贷款";
        case JJRAILoanTypeCredit: return @"信用贷款";
        case JJRAILoanTypeInstallment: return @"分期贷款";
        default: return @"未知类型";
    }
}

- (NSString *)repaymentTypeDescription:(JJRAIRepaymentType)type {
    switch (type) {
        case JJRAIRepaymentTypeEqual: return @"等额本息";
        case JJRAIRepaymentTypePrincipal: return @"等额本金";
        case JJRAIRepaymentTypeInterestFirst: return @"先息后本";
        case JJRAIRepaymentTypeBullet: return @"一次性还款";
        default: return @"未知类型";
    }
}

- (void)generateAdviceForLoanType:(JJRAILoanType)loanType {
    // 为特定贷款类型生成建议的实现
    [self startLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JJRAILoanAdvice *advice;
        
        switch (loanType) {
            case JJRAILoanTypePersonal:
                advice = [self generatePersonalLoanAdvice];
                break;
            case JJRAILoanTypeCredit:
                advice = [self generateCreditLoanAdvice];
                break;
            case JJRAILoanTypeMortgage:
                advice = [self generateMortgageLoanAdvice];
                break;
            case JJRAILoanTypeBusiness:
                advice = [self generateBusinessLoanAdvice];
                break;
            default:
                advice = [self generatePersonalLoanAdvice];
                break;
        }
        
        self.loanAdvices = @[advice];
        self.bestAdvice = advice;
        
        [self finishLoading];
        [self updateData];
    });
}

- (NSArray *)calculateRepaymentPlan:(JJRAILoanAdvice *)advice {
    NSMutableArray *plan = [NSMutableArray array];
    
    CGFloat amount = [advice.recommendedAmount floatValue];
    CGFloat monthlyRate = [advice.interestRate floatValue] / 12;
    NSInteger months = advice.recommendedTerm;
    CGFloat monthlyPayment = [advice.monthlyPayment floatValue];
    
    CGFloat remainingAmount = amount;
    
    for (int i = 1; i <= months; i++) {
        CGFloat interestPayment = remainingAmount * monthlyRate;
        CGFloat principalPayment = monthlyPayment - interestPayment;
        remainingAmount -= principalPayment;
        
        NSDictionary *monthData = @{
            @"month": @(i),
            @"monthlyPayment": @(monthlyPayment),
            @"principalPayment": @(principalPayment),
            @"interestPayment": @(interestPayment),
            @"remainingAmount": @(MAX(0, remainingAmount))
        };
        
        [plan addObject:monthData];
    }
    
    return plan;
}

@end 
