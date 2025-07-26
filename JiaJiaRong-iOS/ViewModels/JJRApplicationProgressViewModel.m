//
//  JJRApplicationProgressViewModel.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRApplicationProgressViewModel.h"

@implementation JJRApplicationProgressViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupMockData];
    }
    return self;
}

- (void)setupMockData {
    // 成功消息
    _successMessage = @"恭喜！上海善语金服贷款申请成功！";
    
    // 额度信息
    _approvedAmount = @"200,000";
    _processingTime = @"60分钟内";
    
    // 机构信息
    _institutionName = @"上海善语金服";
    _institutionFullName = @"善语互联网金融信息服务（上海）有限公司";
    
    // 提醒信息
    _phoneReminderText = @"请保持您的电话畅通注意接听 审核服务电话！";
    
    // 步骤信息
    _progressSteps = @[
        @{@"title": @"智能资质审核", @"status": @"completed", @"icon": @"step_check"},
        @{@"title": @"人工电话复审", @"status": @"current", @"icon": @"step_phone"},
        @{@"title": @"放款到账", @"status": @"pending", @"icon": @"step_money"}
    ];
    
    // 联系信息
    _servicePhone = @"审核服务电话归属地：";
    _serviceLocation = @"上海市";
}

@end 