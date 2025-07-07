//
//  JJRRealNameAuthModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRRealNameAuthModel : JJRBaseModel

@property (nonatomic, strong) NSString *name;          // 姓名
@property (nonatomic, strong) NSString *idNo;          // 身份证号
@property (nonatomic, strong) NSString *validPeriod;   // 证件照有效期

@end

NS_ASSUME_NONNULL_END 