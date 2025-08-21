//
//  JJRCreditAssessmentModel.h
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JJRCreditLevel) {
    JJRCreditLevelExcellent = 0,    // 优秀(750-850)
    JJRCreditLevelGood,             // 良好(650-749)
    JJRCreditLevelFair,             // 一般(550-649)
    JJRCreditLevelPoor,             // 较差(350-549)
    JJRCreditLevelVeryPoor          // 很差(300-349)
};

typedef NS_ENUM(NSInteger, JJRCreditFactorType) {
    JJRCreditFactorTypePaymentHistory = 0,  // 还款历史
    JJRCreditFactorTypeCreditUtilization,   // 信用利用率
    JJRCreditFactorTypeCreditHistory,       // 信用历史长度
    JJRCreditFactorTypeCreditMix,           // 信用组合
    JJRCreditFactorTypeNewCredit           // 新开信用
};

@interface JJRCreditAssessment : JJRBaseModel

@property (nonatomic, assign) NSInteger totalScore;         // 总评分
@property (nonatomic, assign) JJRCreditLevel creditLevel;   // 信用等级
@property (nonatomic, strong) NSString *levelDescription;   // 等级描述
@property (nonatomic, strong) NSArray<NSDictionary *> *factorScores; // 各因子得分
@property (nonatomic, strong) NSArray<NSString *> *strengths;        // 优势
@property (nonatomic, strong) NSArray<NSString *> *weaknesses;       // 需改善项
@property (nonatomic, strong) NSArray<NSString *> *recommendations;  // 改善建议
@property (nonatomic, strong) NSDate *assessmentDate;       // 评估日期
@property (nonatomic, assign) NSInteger improvementPotential; // 提升潜力分数

@end

@interface JJRCreditFactor : JJRBaseModel

@property (nonatomic, assign) JJRCreditFactorType factorType;
@property (nonatomic, strong) NSString *factorName;
@property (nonatomic, assign) NSInteger currentScore;       // 当前得分
@property (nonatomic, assign) NSInteger maxScore;           // 满分
@property (nonatomic, assign) CGFloat weight;               // 权重
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSArray<NSString *> *improvementTips; // 改善建议

@end

@interface JJRCreditHistory : JJRBaseModel

@property (nonatomic, strong) NSArray<JJRCreditAssessment *> *assessments;
@property (nonatomic, strong) NSDate *firstAssessmentDate;
@property (nonatomic, assign) NSInteger scoreChange;        // 分数变化
@property (nonatomic, strong) NSString *trend;              // 趋势：上升/下降/稳定

@end

@interface JJRCreditSimulation : JJRBaseModel

@property (nonatomic, strong) NSString *scenario;           // 模拟场景
@property (nonatomic, assign) NSInteger projectedScore;     // 预计分数
@property (nonatomic, assign) NSInteger timeToAchieve;      // 达成时间(月)
@property (nonatomic, strong) NSArray<NSString *> *actions; // 需要采取的行动
@property (nonatomic, assign) CGFloat probability;          // 成功概率

@end

@interface JJRCreditReport : JJRBaseModel

@property (nonatomic, strong) NSString *reportId;
@property (nonatomic, strong) NSDate *generateDate;
@property (nonatomic, strong) JJRCreditAssessment *assessment;
@property (nonatomic, strong) NSArray<JJRCreditFactor *> *detailFactors;
@property (nonatomic, strong) JJRCreditHistory *history;
@property (nonatomic, strong) NSArray<JJRCreditSimulation *> *simulations;
@property (nonatomic, strong) NSDictionary *industryComparison; // 行业对比
@property (nonatomic, strong) NSString *summary;

@end

NS_ASSUME_NONNULL_END 
