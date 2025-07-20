//
//  JJRFraudPreventionModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JJRFraudType) {
    JJRFraudTypePhishing = 0,       // 钓鱼诈骗
    JJRFraudTypeFakeLoan,           // 虚假贷款
    JJRFraudTypeIdentityTheft,      // 身份盗用
    JJRFraudTypeAdvanceFee,         // 预付费诈骗
    JJRFraudTypePhoneCall,          // 电话诈骗
    JJRFraudTypeFakeApp,            // 虚假APP
    JJRFraudTypePersonalInfo        // 个人信息泄露
};

typedef NS_ENUM(NSInteger, JJRRiskLevel) {
    JJRRiskLevelLow = 0,
    JJRRiskLevelMedium,
    JJRRiskLevelHigh,
    JJRRiskLevelCritical
};

@interface JJRFraudCase : JJRBaseModel

@property (nonatomic, assign) JJRFraudType fraudType;
@property (nonatomic, assign) JJRRiskLevel riskLevel;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *caseDescription;
@property (nonatomic, strong) NSString *fraudMethod;           // 诈骗手段
@property (nonatomic, strong) NSArray<NSString *> *warningSignals; // 预警信号
@property (nonatomic, strong) NSArray<NSString *> *preventionTips;  // 防范措施
@property (nonatomic, strong) NSString *victimLoss;            // 受害者损失
@property (nonatomic, strong) NSDate *reportDate;              // 举报日期
@property (nonatomic, strong) NSString *source;                // 案例来源
@property (nonatomic, assign) NSInteger readCount;             // 阅读次数

@end

@interface JJRFraudPreventionTip : JJRBaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *category;              // 分类
@property (nonatomic, assign) NSInteger priority;              // 优先级
@property (nonatomic, strong) NSArray<NSString *> *keywords;   // 关键词
@property (nonatomic, assign) BOOL isOfficial;                 // 是否官方发布

@end

@interface JJRFraudCheckResult : JJRBaseModel

@property (nonatomic, assign) JJRRiskLevel overallRisk;
@property (nonatomic, strong) NSArray<NSString *> *riskFactors;
@property (nonatomic, strong) NSArray<NSString *> *suggestions;
@property (nonatomic, assign) CGFloat riskScore;               // 风险评分 0-100
@property (nonatomic, strong) NSString *resultSummary;
@property (nonatomic, strong) NSDate *checkDate;

@end

@interface JJRSecurityScore : JJRBaseModel

@property (nonatomic, assign) NSInteger totalScore;            // 总分
@property (nonatomic, assign) NSInteger identitySecurityScore; // 身份安全
@property (nonatomic, assign) NSInteger deviceSecurityScore;   // 设备安全
@property (nonatomic, assign) NSInteger behaviorSecurityScore; // 行为安全
@property (nonatomic, assign) NSInteger networkSecurityScore;  // 网络安全
@property (nonatomic, strong) NSArray<NSString *> *recommendations;
@property (nonatomic, strong) NSDate *lastUpdateDate;

@end

NS_ASSUME_NONNULL_END 