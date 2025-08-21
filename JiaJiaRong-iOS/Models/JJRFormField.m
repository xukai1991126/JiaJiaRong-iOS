//
//  JJRFormField.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/7/6.
//

#import "JJRFormField.h"
#import <MJExtension/MJExtension.h>

@implementation JJRFormFieldCondition
@end

@implementation JJRFormField
+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"conditionList": [JJRFormFieldCondition class] };
}
@end 
