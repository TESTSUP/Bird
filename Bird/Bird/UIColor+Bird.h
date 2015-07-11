//
//  UIColor+Bird.h
//  Bird
//
//  Created by 孙永刚 on 15/7/11.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Bird)
//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//#f7f7f7
+ (UIColor *)navBgColor;
//#e7e7e7
+ (UIColor *)viewBgColor;
//#444444
+ (UIColor *)normalTextColor;
//#bd081c
+ (UIColor *)selectedTextColor;
//#cccccc
+ (UIColor *)separatorColor;
@end
