//
//  HomeViewModel.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "HomeViewModel.h"
#import "JJRNetworkService.h"

@interface HomeViewModel ()

@property (nonatomic, strong) NSString *maxAmount;
@property (nonatomic, strong) NSString *maxPeriod;
@property (nonatomic, strong) NSString *loginButtonTitle;
@property (nonatomic, assign) BOOL showProtocolCheckbox;
@property (nonatomic, strong) NSArray *featureData;
@property (nonatomic, strong) NSArray *testimonialData;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation HomeViewModel

- (void)loadInitialData {
    // 初始化融资担保相关数据
    self.maxAmount = @"200,000.00";
    self.maxPeriod = @"最高可分36期";
    
    // 根据登录状态设置按钮文字
    [self updateLoginButtonTitle];
    
    self.showProtocolCheckbox = YES;
    self.protocolChecked = NO;
    
    // 特色数据
    self.featureData = @[
        @{@"title": @"额度高", @"icon": @"img_29938b72a413"},
        @{@"title": @"利率低", @"icon": @"img_83692599799e"},
        @{@"title": @"放款快", @"icon": @"img_3599d1c6faa3"}
    ];
    
    // 用户证明数据
    self.testimonialData = @[
        @{
            @"name": @"张先生",
            @"phone": @"175****1239",
            @"time": @"12分钟前",
            @"status": @"提交成功",
            @"avatar": @"img_e91c0ba3be4d"
        },
        @{
            @"name": @"刘女士",
            @"phone": @"155****5213",
            @"time": @"15分钟前",
            @"status": @"提交成功",
            @"avatar": @"img_e91c0ba3be4d"
        }
    ];
    
    [self updateData];
}

- (void)fetchUserInfo {
    [self startLoading];
    
    [[JJRNetworkService sharedInstance] getAppChannelWithAppId:@"JJR"
                                                       client:@"IOS"
                                                      success:^(NSDictionary *response) {
        self.userInfo = response[@"data"];
        
        // 获取用户信息后更新按钮文字
        [self updateLoginButtonTitle];
        
        // 根据audit状态设置协议显示
        self.showProtocolCheckbox = [self.userInfo[@"audit"] integerValue] == 0;
        
        [self finishLoading];
        [self updateData];
        
    } failure:^(NSError *error) {
        [self failWithError:error];
    }];
}

- (void)updateLoginButtonTitle {
    // 默认显示登录按钮文字
    if (!self.loginButtonTitle) {
        self.loginButtonTitle = @"本机号码一键登录";
    }
}

- (void)updateLoginButtonTitleWithLoginStatus:(BOOL)isLoggedIn {
    if (isLoggedIn) {
        self.loginButtonTitle = @"领取授信额度";
    } else {
        self.loginButtonTitle = @"本机号码一键登录";
    }
    [self updateData];
}

@end 