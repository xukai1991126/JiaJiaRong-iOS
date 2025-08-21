//
//  JJRRealNameAuthViewModel.m
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRRealNameAuthViewModel.h"

@implementation JJRRealNameAuthViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化mock额度数据
        _maxAmount = @"200,000.00";
        _maxPeriod = @"最高可分36期";
        
        // 初始化用户数据
        _realName = @"";
        _age = @"";
        _isMale = YES; // 默认选择男
        _cityName = @""; // 默认不选择城市
        _cityCode = @"";
    }
    return self;
}

- (BOOL)canSubmit {
    return self.realName.length > 0 && 
           self.age.length > 0 && 
           self.cityName.length > 0;
}

@end 
