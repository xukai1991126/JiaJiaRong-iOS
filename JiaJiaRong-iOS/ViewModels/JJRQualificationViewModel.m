//
//  JJRQualificationViewModel.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRQualificationViewModel.h"

@implementation JJRQualificationViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupMockData];
    }
    return self;
}

- (void)setupMockData {
    // 用户信息
    _userName = @"张女士";
    _qualificationMessage = @"恭喜您已通过资质初审！";
    
    // 预估额度信息
    _estimatedAmount = @"200,000";
    _loanPeriod = @"36个月";
    _yearlyRate = @"7%起";
    
    // 服务机构信息
    _institutionName = @"广东南枫";
    _institutionFullName = @"广东南枫融资担保集团有限公司";
    _institutionIcon = @"img_akfjfkjakjfjk";
    
    // 步骤信息
    _processSteps = @[
        @{@"title": @"智能资质审核", @"status": @"completed", @"icon": @"step_check"},
        @{@"title": @"人工电话复审", @"status": @"pending", @"icon": @"step_phone"},
        @{@"title": @"放款到账", @"status": @"pending", @"icon": @"step_money"}
    ];
    
    // 提示信息
    _reminderText = @"请保持您的电话畅通等待复审电话，为能接听将导致额度失效";
    
    // 协议信息
    _agreementTitle = @"《个人信息授权书》";
    _isAgreementChecked = NO;
}

@end 
