//
//  NSString+HXString.m
//  eplatform-edu
//
//  Created by iMac on 16/8/16.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "NSString+HXString.h"

@implementation NSString (HXString)

-(NSMutableAttributedString*)attriStringWithFirstString:(NSString*)string1 withTwoString:(NSString*)string2 withThreeString:(NSString*)string3 color:(UIColor*)colors{
    NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",string1,string2,string3]];
    NSDictionary * attris = @{NSForegroundColorAttributeName:colors,NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [mutableAttriStr setAttributes:attris range:NSMakeRange(0,string1.length)];
    [mutableAttriStr setAttributes:attris range:NSMakeRange(mutableAttriStr.length - string3.length,string3.length)];

    return mutableAttriStr;
}

// 是否是有效的正则表达式
- (BOOL)isValidateByRegex:(NSString *)regex {
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

// 验证手机号
- (BOOL)isValidateTelNumber {
    
    NSString *strRegex = @"^1[0-9][0-9]{9}$";
    return [self isValidateByRegex:strRegex];
}

// 验证邮箱
- (BOOL)isValidateEmail {
    
    NSString *strRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:strRegex];
}

// 验证url
- (BOOL)isTrueUrl {
    
    NSString *strRegex = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    return [self isValidateByRegex:strRegex];
}



// 字符串编码
- (NSString *)urlEncodeString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’(){}<>*+,;="),kCFStringEncodingUTF8));
    return result;
}

// 反URL编码
- (NSString *)decodeFromPercentEscapeString
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(BOOL)isImageFileName:(NSString *)name
{
    NSString * havePic = [name lowercaseString];
    if ([havePic hasSuffix:@"gif"]||[havePic hasSuffix:@"png"]||[havePic hasSuffix:@"jpg"]||[havePic hasSuffix:@"jpeg"])
    {
        return YES;
    }
    return NO;
}


+(BOOL)isAudioFileName:(NSString *)name
{
    NSString * havePic = [name lowercaseString];
    if ([havePic hasSuffix:@"mp3"])
    {
        return YES;
    }
    return NO;
}

+(BOOL)isVideoFileName:(NSString *)name
{
    NSString * havePic = [name lowercaseString];
    if ([havePic hasSuffix:@"mp4"])
    {
        return YES;
    }
    return NO;
}



/**
 校验身份证号码是否正确 返回BOOL值
 
 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString {
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardString];
    if (!isRe) {
        //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardString.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}

@end
