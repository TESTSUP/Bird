//
//  BirdUtil.m
//  Bird
//
//  Created by 孙永刚 on 15-6-30.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BirdUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BirdUtil

+ (NSString *)createDataIDWithPrefix:(NSString *)aPrefix
{
    static NSInteger magicItem = 0;
    NSString* timestamp = [NSString stringWithFormat:@"%@%f%@", aPrefix,[[NSDate date] timeIntervalSince1970], @(magicItem)];
    ++magicItem;
    
    if ([BGlobalConfig shareInstance].currentUser)
    {
        NSString* str = [[BGlobalConfig shareInstance].currentUser stringByAppendingString:timestamp];
        return [BirdUtil MD5:str];
    }
    return [BirdUtil MD5:timestamp];
}

+ (NSString *)createItemID
{
    return [BirdUtil createDataIDWithPrefix:@"item"];
}

+ (NSString *)createCategoryID
{
    return [BirdUtil createDataIDWithPrefix:@"category"];
}

+ (NSString *)createImageID
{
    return [BirdUtil createDataIDWithPrefix:@"image"];
}

+ (NSString *)MD5:(NSString *)aString
{
    if(aString == nil || [aString length] == 0)
        return nil;
    
    const char *value = [aString UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (UIImage *)getImageWithID:(NSString *)aImageId
{
    NSString *filePath = [[BGlobalConfig shareInstance].imageSourcePath stringByAppendingPathComponent:aImageId];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

+ (void)saveImage:(UIImage *)aImgae withId:(NSString *)aImageId
{
    if (aImageId == nil && [aImageId length] == 0) {
        NSLog(@"save image failed, param can not be nil");
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = UIImagePNGRepresentation(aImgae);
        if (imageData == nil) {
            imageData = UIImageJPEGRepresentation(aImgae, 1);
        }
        
        NSString *filePath = [[BGlobalConfig shareInstance].imageSourcePath stringByAppendingPathComponent:aImageId];
        if (imageData) {
            [imageData writeToFile:filePath atomically:YES];
        }
    });
}

+ (void)deleteImageWithId:(NSString *)aImageId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        NSString *filePath = [[BGlobalConfig shareInstance].imageSourcePath stringByAppendingPathComponent:aImageId];
        [defaultManager removeItemAtPath:filePath error:nil];
    });
}

+ (UIImage *)compressImage:(UIImage*)aImage withWidth:(CGFloat)width
{
    float orgi_width = aImage.size.width;
    float orgi_height = aImage.size.height;
    
    //按照每列的宽度，以及图片的宽高来按比例压缩
    float new_width = width;
    float new_height = (width * orgi_height)/orgi_width;

    CGRect rect = CGRectMake(0.0, 0.0, new_width, new_height);
    
    UIGraphicsBeginImageContext(rect.size);
    [aImage drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;
}

+ (UIImage *)squareThumbnailWithOrgImage:(UIImage *)image
                           andSideLength:(CGFloat)aLength
{
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratio = aLength*[UIScreen mainScreen].scale;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    
    if (ratio >= clippedRect.size.width) {
        return [UIImage imageWithCGImage:imageRef];
    }
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;
}

@end
