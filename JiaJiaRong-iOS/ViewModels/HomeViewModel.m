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
    
    // 用户证明数据 - 20条自动滚动数据
    self.testimonialData = @[
        @{@"name": @"张先生", @"phone": @"175****1239", @"time": @"1分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"刘女士", @"phone": @"155****5213", @"time": @"2分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"王先生", @"phone": @"138****9876", @"time": @"3分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"李女士", @"phone": @"189****4567", @"time": @"5分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"陈先生", @"phone": @"136****7890", @"time": @"7分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"赵女士", @"phone": @"158****3456", @"time": @"8分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"黄先生", @"phone": @"177****6543", @"time": @"10分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"周女士", @"phone": @"159****2468", @"time": @"12分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"吴先生", @"phone": @"185****1357", @"time": @"15分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"郑女士", @"phone": @"176****8024", @"time": @"18分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"孙先生", @"phone": @"139****5791", @"time": @"20分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"马女士", @"phone": @"187****3642", @"time": @"22分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"朱先生", @"phone": @"156****9517", @"time": @"25分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"胡女士", @"phone": @"178****7428", @"time": @"28分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"林先生", @"phone": @"135****6184", @"time": @"30分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"何女士", @"phone": @"188****2973", @"time": @"32分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"高先生", @"phone": @"157****4816", @"time": @"35分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"梁女士", @"phone": @"186****5739", @"time": @"38分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"徐先生", @"phone": @"134****8205", @"time": @"40分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"},
        @{@"name": @"罗女士", @"phone": @"183****1647", @"time": @"42分钟前", @"status": @"提交成功", @"avatar": @"img_e91c0ba3be4d"}
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