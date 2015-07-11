//
//  UIColor+Bird.m
//  Bird
//
//  Created by 孙永刚 on 15/7/11.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "UIColor+Bird.h"

@implementation UIColor (Bird)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}


//#f7f7f7
+ (UIColor *)navBgColor
{
    return [UIColor colorWithRed:247.0/255.0
                           green:247.0/255.0
                            blue:247.0/255.0
                           alpha:1.0];
}

+ (UIColor *)viewBgColor
{
    return [UIColor colorWithRed:231.0/255.0
                           green:231.0/255.0
                            blue:231.0/255.0
                           alpha:1.0];
}

+ (UIColor *)normalTextColor
{
    return [UIColor colorWithRed:68.0/255.0
                           green:68.0/255.0
                            blue:68.0/255.0
                           alpha:1.0];
}

+ (UIColor *)selectedTextColor
{
    return [UIColor colorWithRed:189.0/255.0
                           green:8.0/255.0
                            blue:28.0/255.0
                           alpha:1.0];
}

+ (UIColor *)separatorColor
{
    return [UIColor colorWithRed:204.0/255.0
                           green:204.0/255.0
                            blue:204.0/255.0
                           alpha:1.0];
}

@end
