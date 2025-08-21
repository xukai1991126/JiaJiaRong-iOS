//
//  JJRFraudPreventionModel.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRFraudPreventionModel.h"

@implementation JJRFraudCase

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"fraudType": @"fraud_type",
        @"riskLevel": @"risk_level",
        @"caseDescription": @"case_description",
        @"fraudMethod": @"fraud_method",
        @"warningSignals": @"warning_signals",
        @"preventionTips": @"prevention_tips",
        @"victimLoss": @"victim_loss",
        @"reportDate": @"report_date",
        @"readCount": @"read_count"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"warningSignals": @"NSString",
        @"preventionTips": @"NSString"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _reportDate = [NSDate date];
        _readCount = 0;
    }
    return self;
}

@end

@implementation JJRFraudPreventionTip

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"isOfficial": @"is_official"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"keywords": @"NSString"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _priority = 1;
        _isOfficial = NO;
    }
    return self;
}

@end

@implementation JJRFraudCheckResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"overallRisk": @"overall_risk",
        @"riskFactors": @"risk_factors",
        @"riskScore": @"risk_score",
        @"resultSummary": @"result_summary",
        @"checkDate": @"check_date"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"riskFactors": @"NSString",
        @"suggestions": @"NSString"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _checkDate = [NSDate date];
        _riskScore = 0.0;
        _overallRisk = JJRRiskLevelLow;
    }
    return self;
}

@end

@implementation JJRSecurityScore

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"totalScore": @"total_score",
        @"identitySecurityScore": @"identity_security_score",
        @"deviceSecurityScore": @"device_security_score",
        @"behaviorSecurityScore": @"behavior_security_score",
        @"networkSecurityScore": @"network_security_score",
        @"lastUpdateDate": @"last_update_date"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"recommendations": @"NSString"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _lastUpdateDate = [NSDate date];
        _totalScore = 85; // 默认分数
        _identitySecurityScore = 85;
        _deviceSecurityScore = 85;
        _behaviorSecurityScore = 85;
        _networkSecurityScore = 85;
    }
    return self;
}

@end 
