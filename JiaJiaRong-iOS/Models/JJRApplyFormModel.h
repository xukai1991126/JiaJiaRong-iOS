//
//  JJRApplyFormModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRApplyFormModel : JJRBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *purpose;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *emergencyContact;
@property (nonatomic, copy) NSString *emergencyPhone;
@property (nonatomic, copy) NSString *relationship;

@end

NS_ASSUME_NONNULL_END 