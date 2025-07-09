//
//  JJRRepaymentPlanModel.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/01/01.
//

#import "JJRRepaymentPlanModel.h"

@implementation JJRRepaymentPlanModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        // 实际费用相关字段
        self.actualBreakFee = [dict[@"actualBreakFee"] floatValue];
        self.actualGuaranteeFee = [dict[@"actualGuaranteeFee"] floatValue];
        self.actualInterest = [dict[@"actualInterest"] floatValue];
        self.actualOtherFee = [dict[@"actualOtherFee"] floatValue];
        self.actualPpenaltyInterest = [dict[@"actualPpenaltyInterest"] floatValue];
        self.actualPprincipal = [dict[@"actualPprincipal"] floatValue];
        self.actualServiceFee = [dict[@"actualServiceFee"] floatValue];
        self.actualTotalAmt = [dict[@"actualTotalAmt"] floatValue];
        
        // 计划费用相关字段
        self.breakFee = [dict[@"breakFee"] floatValue];
        self.canPayDate = dict[@"canPayDate"] ?: @"";
        self.createBy = dict[@"createBy"] ?: @"";
        self.createTime = dict[@"createTime"] ?: @"";
        self.deleteFlag = [dict[@"deleteFlag"] boolValue];
        self.finishDate = dict[@"finishDate"] ?: @"";
        self.guaranteeFee = [dict[@"guaranteeFee"] floatValue];
        self.id = [dict[@"id"] integerValue];
        self.interest = [dict[@"interest"] floatValue];
        self.loanNo = dict[@"loanNo"] ?: @"";
        self.otherFee = [dict[@"otherFee"] floatValue];
        self.payDate = dict[@"payDate"] ?: @"";
        self.penaltyInterest = [dict[@"penaltyInterest"] floatValue];
        self.periods = [dict[@"periods"] integerValue];
        self.planNo = dict[@"planNo"] ?: @"";
        self.principal = [dict[@"principal"] floatValue];
        self.serviceFee = [dict[@"serviceFee"] floatValue];
        self.status = [dict[@"status"] integerValue];
        self.totalAmt = [dict[@"totalAmt"] floatValue];
        self.updateBy = dict[@"updateBy"] ?: @"";
        self.updateTime = dict[@"updateTime"] ?: @"";
        self.userId = [dict[@"userId"] integerValue];
        self.version = [dict[@"version"] integerValue];
        
        // UI相关字段
        self.selected = NO; // 默认不选中
    }
    return self;
}

@end 