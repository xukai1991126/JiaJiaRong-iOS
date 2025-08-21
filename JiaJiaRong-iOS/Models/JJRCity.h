//
//  JJRCity.h
//  JiaJiaRong-iOS
//
//  Created by json on 2025/7/5.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRCity : JJRBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, assign) BOOL isHot;

@end

NS_ASSUME_NONNULL_END 
