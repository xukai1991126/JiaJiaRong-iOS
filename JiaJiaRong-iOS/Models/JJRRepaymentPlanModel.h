//
//  JJRRepaymentPlanModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/01/01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRRepaymentPlanModel : NSObject

// 实际费用相关字段
@property (nonatomic, assign) CGFloat actualBreakFee;        // 实际违约金
@property (nonatomic, assign) CGFloat actualGuaranteeFee;    // 实际担保费
@property (nonatomic, assign) CGFloat actualInterest;        // 实际利息
@property (nonatomic, assign) CGFloat actualOtherFee;        // 实际其他费用
@property (nonatomic, assign) CGFloat actualPpenaltyInterest; // 实际罚息
@property (nonatomic, assign) CGFloat actualPprincipal;      // 实际本金
@property (nonatomic, assign) CGFloat actualServiceFee;      // 实际服务费
@property (nonatomic, assign) CGFloat actualTotalAmt;        // 实际总金额

// 计划费用相关字段
@property (nonatomic, assign) CGFloat breakFee;              // 违约金
@property (nonatomic, strong) NSString *canPayDate;          // 可还款日期
@property (nonatomic, strong) NSString *createBy;            // 创建人
@property (nonatomic, strong) NSString *createTime;          // 创建时间
@property (nonatomic, assign) BOOL deleteFlag;               // 删除标记
@property (nonatomic, strong) NSString *finishDate;          // 完成日期
@property (nonatomic, assign) CGFloat guaranteeFee;          // 担保费
@property (nonatomic, assign) NSInteger id;                  // ID
@property (nonatomic, assign) CGFloat interest;              // 利息
@property (nonatomic, strong) NSString *loanNo;              // 贷款编号
@property (nonatomic, assign) CGFloat otherFee;              // 其他费用
@property (nonatomic, strong) NSString *payDate;             // 还款日期
@property (nonatomic, assign) CGFloat penaltyInterest;       // 罚息
@property (nonatomic, assign) NSInteger periods;             // 期数
@property (nonatomic, strong) NSString *planNo;              // 计划编号
@property (nonatomic, assign) CGFloat principal;             // 本金
@property (nonatomic, assign) CGFloat serviceFee;            // 服务费
@property (nonatomic, assign) NSInteger status;              // 状态
@property (nonatomic, assign) CGFloat totalAmt;              // 总金额
@property (nonatomic, strong) NSString *updateBy;            // 更新人
@property (nonatomic, strong) NSString *updateTime;          // 更新时间
@property (nonatomic, assign) NSInteger userId;              // 用户ID
@property (nonatomic, assign) NSInteger version;             // 版本

// UI相关字段
@property (nonatomic, assign) BOOL selected;                 // 是否选中（用于展开/收起）

// 便利构造器
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END 