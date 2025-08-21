//
//  JJRRiskAssessmentModel.m
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRRiskAssessmentModel.h"

@implementation JJRRiskFactor

- (instancetype)initWithType:(JJRRiskFactorType)type 
                       title:(NSString *)title 
             factorDescription:(NSString *)factorDescription 
                       score:(CGFloat)score 
                       level:(JJRRiskLevel)level 
                  suggestion:(NSString *)suggestion {
    if (self = [super init]) {
        _type = type;
        _title = title;
        _factorDescription = factorDescription;
        _score = score;
        _level = level;
        _suggestion = suggestion;
    }
    return self;
}

@end

@implementation JJRRiskAssessmentResult

- (instancetype)init {
    if (self = [super init]) {
        _assessmentDate = [NSDate date];
    }
    return self;
}

@end

@implementation JJRUserRiskProfile

- (instancetype)init {
    if (self = [super init]) {
        // 设置默认值
        _age = 30;
        _monthlyIncome = 8000;
        _totalDebt = 0;
        _totalAssets = 50000;
        _creditScore = 650;
        _employmentType = @"上班族";
        _employmentYears = 3;
        _hasHouse = NO;
        _hasCar = NO;
        _hasInsurance = NO;
    }
    return self;
}

@end 
