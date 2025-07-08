//
//  DTFStringsManager.h
//  DTFUtility
//
//  Created by mengbingchuan on 2024/1/23.
//  Copyright © 2024 com.alipay.iphoneclient.zoloz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTFStringsUtils : NSObject

+ (NSString *)faceStringWithKey:(NSString *)key;
+ (NSString *)docStringWithKey:(NSString *)key;
+ (NSString *)guideStringWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
