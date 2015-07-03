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

+ (NSString *)createItemID
{
    static NSInteger magic = 0;
    NSString* timestamp = [NSString stringWithFormat:@"id%f%@", [[NSDate date] timeIntervalSince1970], @(magic)];
    ++magic;
    
    if ([BGlobalConfig shareInstance].currentUser)
    {
        NSString* str = [[BGlobalConfig shareInstance].currentUser stringByAppendingString:timestamp];
        return [BirdUtil MD5:str];
    }
    return [BirdUtil MD5:timestamp];
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
    NSString *filePath = [[BGlobalConfig shareInstance].imageSourcePath stringByAppendingString:aImageId];
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
        
        NSString *filePath = [[BGlobalConfig shareInstance].imageSourcePath stringByAppendingString:aImageId];
        if (imageData) {
            [imageData writeToFile:filePath atomically:YES];
        }
    });
}

+ (void)deleteImageWithId:(NSString *)aImageId
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    NSString *filePath = [[BGlobalConfig shareInstance].imageSourcePath stringByAppendingString:aImageId];
    [defaultManager removeItemAtPath:filePath error:nil];
}

+ (CGSize)compressImage:(UIImage*)aImage withWidth:(CGFloat)width
{
    float orgi_width = aImage.size.width;
    float orgi_height = aImage.size.height;
    
    //按照每列的宽度，以及图片的宽高来按比例压缩
    float new_width = width - 5;
    float new_height = (width * orgi_height)/orgi_width;

    return CGSizeMake(new_width, new_height);
}

@end
