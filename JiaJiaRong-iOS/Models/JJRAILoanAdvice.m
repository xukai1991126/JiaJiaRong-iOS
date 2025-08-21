//
//  JJRAILoanAdvice.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRAILoanAdvice.h"

@implementation JJRAILoanAdvice

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"recommendedAmount": @"recommended_amount",
        @"recommendedTerm": @"recommended_term",
        @"interestRate": @"interest_rate",
        @"monthlyPayment": @"monthly_payment",
        @"riskAnalysis": @"risk_analysis",
        @"analysisDate": @"analysis_date"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"advantages": @"NSString",
        @"suggestions": @"NSString"
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _analysisDate = [NSDate date];
        _confidence = 0.0;
    }
    return self;
}

@end

@implementation JJRAIUserProfile

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"monthlyIncome": @"monthly_income",
        @"monthlyExpense": @"monthly_expense",
        @"currentDebt": @"current_debt",
        @"creditScore": @"credit_score",
        @"employmentType": @"employment_type",
        @"workYears": @"work_years",
        @"hasHouse": @"has_house",
        @"hasCar": @"has_car",
        @"loanPurpose": @"loan_purpose"
    };
}

@end 
