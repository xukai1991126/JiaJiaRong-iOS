//
//  JJRApplyRecordModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRApplyRecordModel : JJRBaseModel

@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *applyNo;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *purpose;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *statusText;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END 