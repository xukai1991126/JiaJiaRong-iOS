//
//  JJRFormField.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/6.
//

#import <Foundation/Foundation.h>
#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRFormFieldCondition : JJRBaseModel
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@end

@interface JJRFormField : JJRBaseModel
@property (nonatomic, copy) NSString *field;         // 字段名
@property (nonatomic, copy) NSString *fieldName;     // 字段显示名
@property (nonatomic, strong) NSArray<JJRFormFieldCondition *> *conditionList; // 选项列表，可为空
@end

NS_ASSUME_NONNULL_END 