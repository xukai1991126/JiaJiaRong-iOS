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
    _successMessage = @"恭喜！广东南枫贷款申请成功！";
    
    // 额度信息
    _approvedAmount = @"200,000";
    _processingTime = @"60分钟内";
    
    // 机构信息
    _institutionName = @"广东南枫";
    _institutionFullName = @"广东南枫融资担保集团有限公司";
    
    // 提醒信息
    _phoneReminderText = @"请保持您的电话畅通注意接听 审核服务电话！";
    
    // 步骤信息
    _progressSteps = @[
        @{@"title": @"智能资质审核", @"status": @"completed", @"icon": @"img_7a757391618c"},
        @{@"title": @"人工电话复审", @"status": @"current", @"icon": @"img_1ccf22ec22d9"},
        @{@"title": @"放款到账", @"status": @"pending", @"icon": @"img_5d69ae6da46f"}
    ];
    
    // 联系信息
    _servicePhone = @"审核服务电话归属地：";
    _serviceLocation = @"上海市";
}

@end 
