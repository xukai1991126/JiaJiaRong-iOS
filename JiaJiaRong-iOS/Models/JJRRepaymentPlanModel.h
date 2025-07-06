//
//  JJRRepaymentPlanModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRRepaymentPlanModel : JJRBaseModel

@property (nonatomic, copy) NSString *planId;
@property (nonatomic, copy) NSString *applyNo;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *dueDate;
@property (nonatomic, copy) NSString *principal;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *statusText;
@property (nonatomic, copy) NSString *repayDate;
@property (nonatomic, copy) NSString *overdueDays;

@end

NS_ASSUME_NONNULL_END 