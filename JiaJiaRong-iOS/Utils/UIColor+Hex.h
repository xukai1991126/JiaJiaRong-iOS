
//
//  UIColor+Hex.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

/**
 * 从十六进制字符串创建颜色
 * @param hexString 十六进制颜色字符串，支持 #FFFFFF 或 FFFFFF 格式
 * @return UIColor 对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 * 从十六进制字符串创建颜色，带透明度
 * @param hexString 十六进制颜色字符串
 * @param alpha 透明度 (0.0 - 1.0)
 * @return UIColor 对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 * 获取颜色的十六进制字符串
 * @return 十六进制颜色字符串
 */
- (NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
