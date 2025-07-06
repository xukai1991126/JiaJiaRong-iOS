//
//  JJRBaseModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJRBaseModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSDictionary *err;

// 初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// 转换为字典
- (NSDictionary *)toDictionary;

// 转换为JSON字符串
- (NSString *)toJSONString;

// 从JSON字符串创建对象
+ (instancetype)modelWithJSONString:(NSString *)jsonString;

// 从字典数组创建对象数组
+ (NSArray *)modelArrayWithDictionaryArray:(NSArray *)dictionaryArray;


@end

NS_ASSUME_NONNULL_END 
