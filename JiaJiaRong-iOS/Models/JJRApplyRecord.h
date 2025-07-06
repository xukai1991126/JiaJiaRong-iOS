//
//  JJRApplyRecord.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRApplyRecord : JJRBaseModel

@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *applyNo;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *idNo;
@property (nonatomic, assign) CGFloat loanAmount;
@property (nonatomic, assign) NSInteger loanTerm;
@property (nonatomic, strong) NSString *loanPurpose;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusText;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *auditTime;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSDictionary *formData;

@end

NS_ASSUME_NONNULL_END 