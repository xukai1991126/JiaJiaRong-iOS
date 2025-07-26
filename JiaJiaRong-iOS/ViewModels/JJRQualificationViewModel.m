//
//  JJRQualificationViewModel.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRQualificationViewModel.h"
#import "JJRUserManager.h"

@implementation JJRQualificationViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupMockData];
    }
    return self;
}

- (void)setupMockData {
    // 用户信息 - 根据真实姓名和性别生成称呼
    _userName = [self generateUserTitle];
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
        @{@"title": @"智能资质审核", @"status": @"completed", @"icon": @"img_7a757391618c"},
        @{@"title": @"人工电话复审", @"status": @"pending", @"icon": @"img_1ccf22ec22d9"},
        @{@"title": @"放款到账", @"status": @"pending", @"icon": @"img_5d69ae6da46f"}
    ];
    
    // 提示信息
    _reminderText = @"请保持您的电话畅通等待复审电话，为能接听将导致额度失效";
    
    // 协议信息
    _agreementTitle = @"《个人信息授权书》";
    _isAgreementChecked = NO;
}

#pragma mark - Private Methods

- (NSString *)generateUserTitle {
    // 从NSUserDefaults获取用户信息
    NSDictionary *userData = [[JJRUserManager sharedManager] getUserDataFromDefaults];
    NSString *realName = userData[@"realName"];
    NSString *gender = userData[@"gender"];
    
    // 如果没有真实姓名，使用默认值
    if (!realName || realName.length == 0) {
        return @"张女士";
    }
    
    // 提取姓氏（通常是第一个字符）
    NSString *lastName = [realName substringToIndex:1];
    
    // 根据性别添加称呼
    NSString *title = @"女士"; // 默认女士
    if (gender && [gender isEqualToString:@"男"]) {
        title = @"先生";
    }
    
    return [NSString stringWithFormat:@"%@%@", lastName, title];
}

@end 
