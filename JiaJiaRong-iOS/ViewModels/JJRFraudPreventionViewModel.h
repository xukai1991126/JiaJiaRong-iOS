//
//  JJRFraudPreventionViewModel.h
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseViewModel.h"
#import "JJRFraudPreventionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRFraudPreventionViewModel : JJRBaseViewModel

@property (nonatomic, strong, readonly) NSArray<JJRFraudCase *> *fraudCases;
@property (nonatomic, strong, readonly) NSArray<JJRFraudPreventionTip *> *preventionTips;
@property (nonatomic, strong, readonly) JJRSecurityScore *securityScore;

// 加载数据
- (void)loadFraudCases;
- (void)loadPreventionTips;

// 风险检测
- (void)checkSecurityRisk:(NSString *)inputText completion:(void(^)(JJRFraudCheckResult *result))completion;
- (void)updateSecurityScore;

// 搜索和过滤
- (NSArray<JJRFraudCase *> *)searchCases:(NSString *)keyword;
- (NSArray<JJRFraudCase *> *)filterCasesByType:(JJRFraudType)type;
- (NSArray<JJRFraudCase *> *)filterCasesByRiskLevel:(JJRRiskLevel)riskLevel;

// 获取推荐内容
- (NSArray<JJRFraudPreventionTip *> *)getRecommendedTips;
- (NSArray<JJRFraudCase *> *)getHighRiskCases;

// 工具方法
- (NSString *)fraudTypeDescription:(JJRFraudType)type;
- (NSString *)riskLevelDescription:(JJRRiskLevel)level;
- (UIColor *)riskLevelColor:(JJRRiskLevel)level;

// 统计信息
- (NSDictionary *)getFraudStatistics;

@end

NS_ASSUME_NONNULL_END 
