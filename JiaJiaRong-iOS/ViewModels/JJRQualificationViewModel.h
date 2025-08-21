//
//  JJRQualificationViewModel.h
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRQualificationViewModel : NSObject

// 用户信息
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *qualificationMessage;

// 预估额度信息
@property (nonatomic, strong) NSString *estimatedAmount;
@property (nonatomic, strong) NSString *loanPeriod;
@property (nonatomic, strong) NSString *yearlyRate;

// 服务机构信息
@property (nonatomic, strong) NSString *institutionName;
@property (nonatomic, strong) NSString *institutionFullName;
@property (nonatomic, strong) NSString *institutionIcon;

// 步骤信息
@property (nonatomic, strong) NSArray *processSteps;

// 提示信息
@property (nonatomic, strong) NSString *reminderText;

// 协议信息
@property (nonatomic, strong) NSString *agreementTitle;
@property (nonatomic, assign) BOOL isAgreementChecked;

@end

NS_ASSUME_NONNULL_END 
