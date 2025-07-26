//
//  JJRRealNameAuthViewModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRRealNameAuthViewModel : NSObject

// 额度信息
@property (nonatomic, strong) NSString *maxAmount;
@property (nonatomic, strong) NSString *maxPeriod;

// 用户输入信息
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, assign) BOOL isMale; // YES: 男, NO: 女
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityCode;

// 验证方法
- (BOOL)canSubmit;

@end

NS_ASSUME_NONNULL_END 