//
//  JJRApplicationProgressViewModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRApplicationProgressViewModel : NSObject

// 成功消息
@property (nonatomic, strong) NSString *successMessage;

// 额度信息
@property (nonatomic, strong) NSString *approvedAmount;
@property (nonatomic, strong) NSString *processingTime;

// 机构信息
@property (nonatomic, strong) NSString *institutionName;
@property (nonatomic, strong) NSString *institutionFullName;

// 提醒信息
@property (nonatomic, strong) NSString *phoneReminderText;

// 步骤信息
@property (nonatomic, strong) NSArray *progressSteps;

// 联系信息
@property (nonatomic, strong) NSString *servicePhone;
@property (nonatomic, strong) NSString *serviceLocation;

@end

NS_ASSUME_NONNULL_END 