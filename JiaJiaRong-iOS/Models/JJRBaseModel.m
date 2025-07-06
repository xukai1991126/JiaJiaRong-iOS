//
//  JJRBaseModel.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

@implementation JJRBaseModel

+ (void)load {
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
            @"ID": @"id",
            @"desc": @"description"
        };
    }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return [self mj_keyValues];
}

- (NSString *)toJSONString {
    return [self mj_JSONString];
}

+ (instancetype)modelWithJSONString:(NSString *)jsonString {
    return [self mj_objectWithKeyValues:jsonString];
}

+ (NSArray *)modelArrayWithDictionaryArray:(NSArray *)dictionaryArray {
    return [self mj_objectArrayWithKeyValuesArray:dictionaryArray];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 忽略未定义的key
}

@end 