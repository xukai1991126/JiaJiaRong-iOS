//
//  JJRRiskAssessmentModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JJRRiskLevel) {
    JJRRiskLevelLow = 1,
    JJRRiskLevelMedium,
    JJRRiskLevelHigh,
    JJRRiskLevelExtreme
};

typedef NS_ENUM(NSInteger, JJRRiskFactorType) {
    JJRRiskFactorTypeCredit = 1,
    JJRRiskFactorTypeIncome,
    JJRRiskFactorTypeDebt,
    JJRRiskFactorTypeAsset,
    JJRRiskFactorTypeEmployment,
    JJRRiskFactorTypeAge
};

@interface JJRRiskFactor : NSObject

@property (nonatomic, assign) JJRRiskFactorType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *factorDescription;
@property (nonatomic, assign) CGFloat score; // 0-100
@property (nonatomic, assign) JJRRiskLevel level;
@property (nonatomic, strong) NSString *suggestion;

- (instancetype)initWithType:(JJRRiskFactorType)type 
                       title:(NSString *)title 
             factorDescription:(NSString *)factorDescription 
                       score:(CGFloat)score 
                       level:(JJRRiskLevel)level 
                  suggestion:(NSString *)suggestion;

@end

@interface JJRRiskAssessmentResult : NSObject

@property (nonatomic, assign) CGFloat overallScore; // 0-100
@property (nonatomic, assign) JJRRiskLevel overallLevel;
@property (nonatomic, strong) NSString *levelDescription;
@property (nonatomic, strong) NSArray<JJRRiskFactor *> *riskFactors;
@property (nonatomic, strong) NSArray<NSString *> *recommendations;
@property (nonatomic, strong) NSDate *assessmentDate;

@end

@interface JJRUserRiskProfile : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) CGFloat monthlyIncome;
@property (nonatomic, assign) CGFloat totalDebt;
@property (nonatomic, assign) CGFloat totalAssets;
@property (nonatomic, assign) NSInteger creditScore;
@property (nonatomic, strong) NSString *employmentType;
@property (nonatomic, assign) NSInteger employmentYears;
@property (nonatomic, assign) BOOL hasHouse;
@property (nonatomic, assign) BOOL hasCar;
@property (nonatomic, assign) BOOL hasInsurance;

@end

NS_ASSUME_NONNULL_END 