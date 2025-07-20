//
//  JJRCreditAssessmentModel.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRCreditAssessmentModel.h"

@implementation JJRCreditAssessment

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"totalScore": @"total_score",
        @"creditLevel": @"credit_level",
        @"levelDescription": @"level_description",
        @"factorScores": @"factor_scores",
        @"assessmentDate": @"assessment_date",
        @"improvementPotential": @"improvement_potential"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"factorScores": @"NSDictionary",
        @"strengths": @"NSString",
        @"weaknesses": @"NSString",
        @"recommendations": @"NSString"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _assessmentDate = [NSDate date];
        _totalScore = 650; // 默认分数
        _creditLevel = JJRCreditLevelGood;
    }
    return self;
}

@end

@implementation JJRCreditFactor

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"factorType": @"factor_type",
        @"factorName": @"factor_name",
        @"currentScore": @"current_score",
        @"maxScore": @"max_score",
        @"improvementTips": @"improvement_tips"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"improvementTips": @"NSString"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _maxScore = 100;
        _weight = 0.2;
    }
    return self;
}

@end

@implementation JJRCreditHistory

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"firstAssessmentDate": @"first_assessment_date",
        @"scoreChange": @"score_change"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"assessments": @"JJRCreditAssessment"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _firstAssessmentDate = [NSDate date];
        _scoreChange = 0;
        _trend = @"稳定";
    }
    return self;
}

@end

@implementation JJRCreditSimulation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"projectedScore": @"projected_score",
        @"timeToAchieve": @"time_to_achieve"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"actions": @"NSString"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _probability = 0.7;
        _timeToAchieve = 6;
    }
    return self;
}

@end

@implementation JJRCreditReport

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"reportId": @"report_id",
        @"generateDate": @"generate_date",
        @"detailFactors": @"detail_factors",
        @"industryComparison": @"industry_comparison"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"detailFactors": @"JJRCreditFactor",
        @"simulations": @"JJRCreditSimulation"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _generateDate = [NSDate date];
        _reportId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

@end 