
//
//  UIColor+Hex.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if (!hexString || hexString.length == 0) {
        return [UIColor clearColor];
    }
    
    // 移除 # 前缀
    NSString *cleanHexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    // 确保是6位十六进制
    if (cleanHexString.length != 6) {
        return [UIColor clearColor];
    }
    
    // 解析RGB值
    unsigned int rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:cleanHexString];
    [scanner scanHexInt:&rgbValue];
    
    CGFloat red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((rgbValue & 0x00FF00) >> 8) / 255.0;
    CGFloat blue = (rgbValue & 0x0000FF) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)hexString {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    return [NSString stringWithFormat:@"#%02X%02X%02X",
            (int)(red * 255),
            (int)(green * 255),
            (int)(blue * 255)];
}

@end
