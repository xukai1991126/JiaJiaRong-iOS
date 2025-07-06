//
//  JJRFormField.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/6.
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