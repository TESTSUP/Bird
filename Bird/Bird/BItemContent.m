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

- (NSString *)itemID
{
    if (_itemID == nil) {
        _itemID = [BirdUtil createItemID];
    }
    return _itemID;
}

- (void)createImageIds
{
    NSMutableArray *imageIds = [[NSMutableArray alloc] initWithCapacity:0];
    for (UIImage *image in self.imageDatas) {
        NSString *imageId = [NSString stringWithFormat:@"%@_%lu", self.itemID, (unsigned long)[self.imageDatas indexOfObject:image]];
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

@end
