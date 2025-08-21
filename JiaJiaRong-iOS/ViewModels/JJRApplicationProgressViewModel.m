//
//  JJRApplicationProgressViewModel.m
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRApplicationProgressViewModel.h"
#import "JJRUserManager.h"

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
    _successMessage = @"恭喜！佳佳融融资担保预估授信成功！";
    
    // 额度信息
    _approvedAmount = @"200,000";
    _processingTime = @"60分钟内";
    
    // 机构信息
    _institutionName = @"佳佳融";
    _institutionFullName = @"广东南枫融资担保集团有限公司";
    
    // 提醒信息
    _phoneReminderText = @"请保持您的电话畅通注意接听 审核服务电话！";
    
    // 步骤信息
    _progressSteps = @[
        @{@"title": @"智能资质审核", @"status": @"completed", @"icon": @"img_7a757391618c"},
        @{@"title": @"人工电话复审", @"status": @"current", @"icon": @"img_1ccf22ec22d9"},
        @{@"title": @"放款到账", @"status": @"pending", @"icon": @"img_5d69ae6da46f"}
    ];
    
    // 联系信息 - 根据用户选择的城市动态生成
    _servicePhone = @"审核服务电话归属地：";
    _serviceLocation = [self getUserSelectedCity];
}

#pragma mark - Private Methods

- (NSString *)getUserSelectedCity {
    // 从NSUserDefaults获取用户选择的城市信息
    NSDictionary *userData = [[JJRUserManager sharedManager] getUserDataFromDefaults];
    NSString *cityName = userData[@"cityName"];
    
    // 如果没有选择城市，使用默认值
    if (!cityName || cityName.length == 0) {
        return @"上海市";
    }
    
    // 确保城市名以"市"结尾，如果不是则添加
    if (![cityName hasSuffix:@"市"] && ![cityName hasSuffix:@"区"] && ![cityName hasSuffix:@"县"]) {
        return [NSString stringWithFormat:@"%@市", cityName];
    }
    
    return cityName;
}

@end 
