//
//  JJRRepaymentPlan.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRRepaymentPlan : JJRBaseModel

@property (nonatomic, strong) NSString *planId;
@property (nonatomic, strong) NSString *applyNo;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, assign) CGFloat principal;
@property (nonatomic, assign) CGFloat interest;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, strong) NSString *dueDate;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusText;
@property (nonatomic, assign) BOOL isOverdue;
@property (nonatomic, strong) NSString *repayTime;
@property (nonatomic, assign) CGFloat overdueFee;

@end

NS_ASSUME_NONNULL_END 