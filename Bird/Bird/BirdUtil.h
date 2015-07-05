//
//  BirdUtil.h
//  Bird
//
//  Created by 孙永刚 on 15-6-30.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BirdUtil : NSObject

+ (NSString *)createItemID;

+ (NSString *)createCategoryID;

+ (NSString *)MD5:(NSString *)aString;

+ (UIImage *)getImageWithID:(NSString *)aImageId;

+ (void)saveImage:(UIImage *)aImgae withId:(NSString *)aImageId;

+ (void)deleteImageWithId:(NSString *)aImageId;

+ (CGSize)compressImage:(UIImage*)aImage withWidth:(CGFloat)width;

+ (UIImage *)generatePhotoThumbnail:(UIImage *)image;

@end
