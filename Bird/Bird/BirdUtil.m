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
    
//    NSData *imageData = UIImagePNGRepresentation(aImgae);
//    if (imageData == nil) {
//        imageData = UIImageJPEGRepresentation(aImgae, 1);
//    }
//    
//    NSString *filePath = [[BGlobalConfig shareInstance].imageSourcePath stringByAppendingPathComponent:aImageId];
//    if (imageData) {
//        [imageData writeToFile:filePath atomically:YES];
//    }
    
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
    CGFloat ratio = width*[UIScreen mainScreen].scale;
    
    //按照每列的宽度，以及图片的宽高来按比例压缩
    float new_width = ratio;
    float new_height = (ratio * orgi_height)/orgi_width;

    CGRect rect = CGRectMake(0.0, 0.0, new_width, new_height);
    
    UIGraphicsBeginImageContext(rect.size);
    [aImage drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;
}

+ (UIImage *)compressImageByMainScreen:(UIImage*)aImage
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    return [BirdUtil compressImage:aImage withWidth:width];
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

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage needCompress:(BOOL)aNeed; {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aNeed? [BirdUtil compressImageByMainScreen:aImage]:aImage;
    
    //resize
    CGFloat imageWidth = aImage.size.width;
    CGFloat imageHeight = aImage.size.height;
    if (aNeed) {
        float orgi_width = aImage.size.width;
        float orgi_height = aImage.size.height;
        CGFloat ratio = [UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].scale;
        //按照每列的宽度，以及图片的宽高来按比例压缩
        imageWidth = ratio;
        imageHeight = (ratio * orgi_height)/orgi_width;
    }

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, imageHeight);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imageHeight);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imageHeight, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, imageWidth, imageHeight,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imageHeight,imageWidth), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imageWidth,imageHeight), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (void)showAlertViewWithMsg:(NSString *)aMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:aMsg
                                                   delegate:nil cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
+ (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
