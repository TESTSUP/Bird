//
//  BirdUtil.h
//  Bird
//
//  Created by 孙永刚 on 15-6-30.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Bird.h"

@interface BirdUtil : NSObject

+ (NSString *)createItemID;

+ (NSString *)createCategoryID;

+ (NSString *)createImageID;

+ (NSString *)MD5:(NSString *)aString;

+ (UIImage *)getImageWithID:(NSString *)aImageId;

+ (void)saveImage:(UIImage *)aImgae withId:(NSString *)aImageId;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (void)deleteImageWithId:(NSString *)aImageId;

+ (UIImage *)compressImage:(UIImage*)aImage withWidth:(CGFloat)width;

+ (UIImage *)squareThumbnailWithOrgImage:(UIImage *)image
                           andSideLength:(CGFloat)aLength;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (void)showAlertViewWithMsg:(NSString *)aMsg;

@end
