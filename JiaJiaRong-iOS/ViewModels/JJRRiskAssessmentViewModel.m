//
//  JJRRiskAssessmentViewModel.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRRiskAssessmentViewModel.h"

@interface JJRRiskAssessmentViewModel()

@property (nonatomic, assign) BOOL isAnalyzing;

@end

@implementation JJRRiskAssessmentViewModel

- (instancetype)init {
    if (self = [super init]) {
        _userProfile = [[JJRUserRiskProfile alloc] init];
        _isAnalyzing = NO;
    }
    return self;
}

#pragma mark - 数据源方法

- (NSInteger)numberOfSections {
    if (self.assessmentResult) {
        return 3; // 总体评估、风险因子、建议
    } else {
        return 1; // 用户输入
    }
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (self.assessmentResult) {
        switch (section) {
            case 0: return 1; // 总体评估
            case 1: return self.assessmentResult.riskFactors.count; // 风险因子
            case 2: return self.assessmentResult.recommendations.count; // 建议
            default: return 0;
        }
    } else {
        return 1; // 输入表单
    }
}

- (NSString *)titleForSection:(NSInteger)section {
    if (self.assessmentResult) {
        switch (section) {
            case 0: return @"📊 风险评估结果";
            case 1: return @"🔍 风险因子分析";
            case 2: return @"💡 改善建议";
            default: return @"";
        }
    } else {
        return @"📝 基本信息填写";
    }
}

#pragma mark - 风险评估

- (void)startRiskAssessment {
    self.isAnalyzing = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(riskAssessmentDidStartAnalyzing)]) {
        [self.delegate riskAssessmentDidStartAnalyzing];
    }
    
    // 模拟网络请求延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.assessmentResult = [self generateMockAssessmentResult];
        self.isAnalyzing = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(riskAssessmentDidFinishWithResult:)]) {
            [self.delegate riskAssessmentDidFinishWithResult:self.assessmentResult];
        }
    });
}

- (void)updateUserProfile:(JJRUserRiskProfile *)profile {
    self.userProfile = profile;
}

#pragma mark - 生成模拟数据

- (JJRRiskAssessmentResult *)generateMockAssessmentResult {
    JJRRiskAssessmentResult *result = [[JJRRiskAssessmentResult alloc] init];
    
    // 生成风险因子
    NSMutableArray *factors = [NSMutableArray array];
    
    // 信用因子
    JJRRiskFactor *creditFactor = [[JJRRiskFactor alloc] 
                                   initWithType:JJRRiskFactorTypeCredit 
                                   title:@"信用状况" 
                                   factorDescription:[NSString stringWithFormat:@"信用评分：%ld分", (long)self.userProfile.creditScore]
                                   score:[self calculateCreditScore] 
                                   level:[self riskLevelForScore:[self calculateCreditScore]]
                                   suggestion:@"保持良好的信用记录，按时还款"];
    [factors addObject:creditFactor];
    
    // 收入因子
    JJRRiskFactor *incomeFactor = [[JJRRiskFactor alloc] 
                                   initWithType:JJRRiskFactorTypeIncome 
                                   title:@"收入水平" 
                                   factorDescription:[NSString stringWithFormat:@"月收入：%.0f元", self.userProfile.monthlyIncome]
                                   score:[self calculateIncomeScore] 
                                   level:[self riskLevelForScore:[self calculateIncomeScore]]
                                   suggestion:@"建议提高收入来源，降低债务收入比"];
    [factors addObject:incomeFactor];
    
    // 负债因子
    JJRRiskFactor *debtFactor = [[JJRRiskFactor alloc] 
                                 initWithType:JJRRiskFactorTypeDebt 
                                 title:@"负债情况" 
                                 factorDescription:[NSString stringWithFormat:@"总负债：%.0f元", self.userProfile.totalDebt]
                                 score:[self calculateDebtScore] 
                                 level:[self riskLevelForScore:[self calculateDebtScore]]
                                 suggestion:@"控制负债水平，避免过度借贷"];
    [factors addObject:debtFactor];
    
    // 资产因子
    JJRRiskFactor *assetFactor = [[JJRRiskFactor alloc] 
                                  initWithType:JJRRiskFactorTypeAsset 
                                  title:@"资产状况" 
                                  factorDescription:[NSString stringWithFormat:@"总资产：%.0f元", self.userProfile.totalAssets]
                                  score:[self calculateAssetScore] 
                                  level:[self riskLevelForScore:[self calculateAssetScore]]
                                  suggestion:@"增加资产积累，提高抗风险能力"];
    [factors addObject:assetFactor];
    
    // 就业因子
    JJRRiskFactor *employmentFactor = [[JJRRiskFactor alloc] 
                                       initWithType:JJRRiskFactorTypeEmployment 
                                       title:@"就业稳定性" 
                                       factorDescription:[NSString stringWithFormat:@"%@，工作%ld年", self.userProfile.employmentType, (long)self.userProfile.employmentYears]
                                       score:[self calculateEmploymentScore] 
                                       level:[self riskLevelForScore:[self calculateEmploymentScore]]
                                       suggestion:@"保持稳定就业，提升职业技能"];
    [factors addObject:employmentFactor];
    
    // 年龄因子
    JJRRiskFactor *ageFactor = [[JJRRiskFactor alloc] 
                                initWithType:JJRRiskFactorTypeAge 
                                title:@"年龄因素" 
                                factorDescription:[NSString stringWithFormat:@"年龄：%ld岁", (long)self.userProfile.age]
                                score:[self calculateAgeScore] 
                                level:[self riskLevelForScore:[self calculateAgeScore]]
                                suggestion:@"合理规划财务，做好养老准备"];
    [factors addObject:ageFactor];
    
    result.riskFactors = factors;
    
    // 计算总体评分
    CGFloat totalScore = 0;
    for (JJRRiskFactor *factor in factors) {
        totalScore += factor.score;
    }
    result.overallScore = totalScore / factors.count;
    result.overallLevel = [self riskLevelForScore:result.overallScore];
    result.levelDescription = [self riskLevelDescription:result.overallLevel];
    
    // 生成建议
    result.recommendations = [self generateRecommendations:result.overallLevel];
    
    return result;
}

#pragma mark - 评分计算

- (CGFloat)calculateCreditScore {
    if (self.userProfile.creditScore >= 750) return 90;
    if (self.userProfile.creditScore >= 700) return 80;
    if (self.userProfile.creditScore >= 650) return 70;
    if (self.userProfile.creditScore >= 600) return 60;
    return 40;
}

- (CGFloat)calculateIncomeScore {
    if (self.userProfile.monthlyIncome >= 20000) return 90;
    if (self.userProfile.monthlyIncome >= 15000) return 80;
    if (self.userProfile.monthlyIncome >= 10000) return 70;
    if (self.userProfile.monthlyIncome >= 5000) return 60;
    return 40;
}

- (CGFloat)calculateDebtScore {
    CGFloat debtRatio = self.userProfile.totalDebt / (self.userProfile.monthlyIncome * 12);
    if (debtRatio <= 0.1) return 90;
    if (debtRatio <= 0.3) return 80;
    if (debtRatio <= 0.5) return 60;
    if (debtRatio <= 1.0) return 40;
    return 20;
}

- (CGFloat)calculateAssetScore {
    if (self.userProfile.totalAssets >= 500000) return 90;
    if (self.userProfile.totalAssets >= 200000) return 80;
    if (self.userProfile.totalAssets >= 100000) return 70;
    if (self.userProfile.totalAssets >= 50000) return 60;
    return 40;
}

- (CGFloat)calculateEmploymentScore {
    NSInteger baseScore = 60;
    if ([self.userProfile.employmentType isEqualToString:@"公务员"]) baseScore = 90;
    else if ([self.userProfile.employmentType isEqualToString:@"上班族"]) baseScore = 70;
    else if ([self.userProfile.employmentType isEqualToString:@"自由职业"]) baseScore = 50;
    
    // 工作年限加分
    baseScore += self.userProfile.employmentYears * 2;
    return MIN(90, baseScore);
}

- (CGFloat)calculateAgeScore {
    if (self.userProfile.age >= 25 && self.userProfile.age <= 45) return 85;
    if (self.userProfile.age >= 18 && self.userProfile.age <= 55) return 75;
    return 60;
}

- (JJRRiskLevel)riskLevelForScore:(CGFloat)score {
    if (score >= 80) return JJRRiskLevelLow;
    if (score >= 65) return JJRRiskLevelMedium;
    if (score >= 50) return JJRRiskLevelHigh;
    return JJRRiskLevelExtreme;
}

- (NSArray<NSString *> *)generateRecommendations:(JJRRiskLevel)level {
    switch (level) {
        case JJRRiskLevelLow:
            return @[@"✅ 您的财务状况良好，风险较低",
                    @"💰 可以考虑适当的投资理财",
                    @"📈 建议定期评估并调整投资组合",
                    @"🏠 适合申请房贷等大额贷款"];
            
        case JJRRiskLevelMedium:
            return @[@"⚠️ 财务状况中等，需要谨慎管理",
                    @"💳 控制信用卡使用，避免过度消费",
                    @"📊 建议增加储蓄，建立应急基金",
                    @"🎯 制定明确的财务目标和计划"];
            
        case JJRRiskLevelHigh:
            return @[@"🚨 存在较高财务风险，需要关注",
                    @"💸 减少不必要支出，控制债务增长",
                    @"📉 暂缓大额投资和贷款申请",
                    @"🔧 考虑寻求专业理财师建议"];
            
        case JJRRiskLevelExtreme:
            return @[@"🚫 财务风险极高，急需改善",
                    @"⛑️ 立即制定债务偿还计划",
                    @"💼 考虑增加收入来源",
                    @"🆘 建议咨询专业债务管理机构"];
    }
}

#pragma mark - 工具方法

- (NSString *)riskLevelDescription:(JJRRiskLevel)level {
    switch (level) {
        case JJRRiskLevelLow: return @"低风险";
        case JJRRiskLevelMedium: return @"中等风险";
        case JJRRiskLevelHigh: return @"高风险";
        case JJRRiskLevelExtreme: return @"极高风险";
    }
}

- (UIColor *)colorForRiskLevel:(JJRRiskLevel)level {
    switch (level) {
        case JJRRiskLevelLow: return [UIColor colorWithHexString:@"#4CAF50"];
        case JJRRiskLevelMedium: return [UIColor colorWithHexString:@"#FF9800"];
        case JJRRiskLevelHigh: return [UIColor colorWithHexString:@"#FF5722"];
        case JJRRiskLevelExtreme: return [UIColor colorWithHexString:@"#F44336"];
    }
}

- (NSString *)riskFactorTypeDescription:(JJRRiskFactorType)type {
    switch (type) {
        case JJRRiskFactorTypeCredit: return @"信用状况";
        case JJRRiskFactorTypeIncome: return @"收入水平";
        case JJRRiskFactorTypeDebt: return @"负债情况";
        case JJRRiskFactorTypeAsset: return @"资产状况";
        case JJRRiskFactorTypeEmployment: return @"就业稳定性";
        case JJRRiskFactorTypeAge: return @"年龄因素";
    }
}

@end 