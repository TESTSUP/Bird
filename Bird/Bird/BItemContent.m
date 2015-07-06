//
//  BItemContent.m
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BItemContent.h"
#import "BirdUtil.h"

@implementation BItemContent

- (void)createImageIds
{
    NSMutableArray *imageIds = [[NSMutableArray alloc] initWithCapacity:0];
    for (UIImage *image in self.imageDatas) {
        NSString *imageId = [BirdUtil createImageID];
        [BirdUtil saveImage:image withId:imageId];
        [imageIds addObject:imageId];
    }
    self.imageIDs = imageIds;

}

- (void)updateImageIds
{
    [self deleteImages];
    
    [self createImageIds];
}

- (void)deleteImages
{
    for (NSString *imageId in self.imageIDs) {
        [BirdUtil deleteImageWithId:imageId];
    }
}

- (UIImage *)imageWithId:(NSString *)aImageId
{
    if ([self.imageDatas count] > 0 &&
        [self.imageDatas count] != [self.imageIDs count]) {
        NSLog(@"....item image data error");
        return [BirdUtil getImageWithID:aImageId];
    }
    
    for (NSString *imageid in self.imageIDs) {
        if ([imageid isEqualToString:aImageId]) {
            
            NSInteger index = [self.imageIDs indexOfObject:imageid];
            if (index < [self.imageDatas count]) {
                return [self.imageDatas objectAtIndex:index];
            } else {
                return [BirdUtil getImageWithID:aImageId];
            }
            
            break;
        }
    }

    return nil;
}

@end
