//
//  JJRAppInfoModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRAppInfoModel : JJRBaseModel

@property (nonatomic, strong) NSString *appName;    // 应用名称
@property (nonatomic, strong) NSString *appText;    // 应用描述

@end

NS_ASSUME_NONNULL_END 