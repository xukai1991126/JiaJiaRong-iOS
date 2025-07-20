//
//  JJRAILoanAdvice.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JJRAILoanType) {
    JJRAILoanTypePersonal = 0,      // 个人消费贷款
    JJRAILoanTypeMortgage,          // 房屋抵押贷款
    JJRAILoanTypeBusiness,          // 经营贷款
    JJRAILoanTypeCredit,            // 信用贷款
    JJRAILoanTypeInstallment        // 分期贷款
};

typedef NS_ENUM(NSInteger, JJRAIRepaymentType) {
    JJRAIRepaymentTypeEqual = 0,    // 等额本息
    JJRAIRepaymentTypePrincipal,    // 等额本金
    JJRAIRepaymentTypeInterestFirst, // 先息后本
    JJRAIRepaymentTypeBullet        // 一次性还款
};

@interface JJRAILoanAdvice : JJRBaseModel

@property (nonatomic, assign) JJRAILoanType loanType;
@property (nonatomic, assign) JJRAIRepaymentType repaymentType;
@property (nonatomic, strong) NSNumber *recommendedAmount;      // 推荐贷款金额
@property (nonatomic, assign) NSInteger recommendedTerm;        // 推荐贷款期限(月)
@property (nonatomic, strong) NSNumber *interestRate;           // 推荐利率
@property (nonatomic, strong) NSNumber *monthlyPayment;         // 月还款额
@property (nonatomic, strong) NSString *reason;                 // AI推荐理由
@property (nonatomic, strong) NSString *riskAnalysis;           // 风险分析
@property (nonatomic, strong) NSArray<NSString *> *advantages;  // 优势分析
@property (nonatomic, strong) NSArray<NSString *> *suggestions; // AI建议
@property (nonatomic, assign) CGFloat confidence;               // AI信心度 0-1
@property (nonatomic, strong) NSDate *analysisDate;             // 分析日期

@end

@interface JJRAIUserProfile : JJRBaseModel

@property (nonatomic, strong) NSNumber *monthlyIncome;          // 月收入
@property (nonatomic, strong) NSNumber *monthlyExpense;         // 月支出
@property (nonatomic, strong) NSNumber *currentDebt;            // 当前负债
@property (nonatomic, strong) NSNumber *creditScore;            // 信用评分
@property (nonatomic, assign) NSInteger age;                    // 年龄
@property (nonatomic, strong) NSString *occupation;             // 职业
@property (nonatomic, strong) NSString *employmentType;         // 就业类型
@property (nonatomic, assign) NSInteger workYears;              // 工作年限
@property (nonatomic, strong) NSNumber *assets;                 // 总资产
@property (nonatomic, assign) BOOL hasHouse;                    // 是否有房产
@property (nonatomic, assign) BOOL hasCar;                      // 是否有车辆
@property (nonatomic, strong) NSString *loanPurpose;            // 贷款用途

@end

NS_ASSUME_NONNULL_END 