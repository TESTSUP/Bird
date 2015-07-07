//
//  BModelInterface.m
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BModelInterface.h"
#import "BirdDB.h"
#import "BirdUtil.h"

@interface BModelInterface ()
{

}

@end

@implementation BModelInterface

static dispatch_once_t modelToken;
static BModelInterface *modelInstance = nil;
+ (BModelInterface *)shareInstance
{
    dispatch_once(&modelToken, ^{
        modelInstance = [[BModelInterface alloc] init];
    });
    
    return modelInstance;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (void)handleCategoryWithAction:(ModelAction)aAction andData:(BCategoryContent *)aCategory
{
    switch (aAction) {
        case ModelAction_update:
        {
            aCategory.updateTime = [[NSDate date] timeIntervalSince1970];
            [[BirdDB share] updateCategoryDesc:aCategory];
        }
            break;
        case ModelAction_create:
        {
            aCategory.createTime = [[NSDate date] timeIntervalSince1970];
            aCategory.updateTime = aCategory.createTime;
            [[BirdDB share] insertCategory:aCategory];
        }
            break;
        case ModelAction_delete:
        {
            [[BirdDB share] deleteCateGoryWithId:aCategory.categoryId];
        }
            break;
        default:
            break;
    }
}


- (void)handleItemWithAction:(ModelAction)aAction andData:(BItemContent *)aItem
{
    switch (aAction) {
        case ModelAction_create:
        {
            aItem.createTime = [[NSDate date] timeIntervalSince1970];
            aItem.updateTime = aItem.createTime;
            [aItem createImageIds];
            [[BirdDB share] insertItem:aItem];
        }
            break;
        case ModelAction_update:
        {
            aItem.updateTime = [[NSDate date] timeIntervalSince1970];
            [aItem updateImageIds];
            [[BirdDB share] insertItem:aItem];
        }
            break;
        case ModelAction_delete:
        {
            [aItem deleteImages];
            [[BirdDB share] deleteItmeWithId:aItem.itemID];
        }
            break;
        default:
            break;
    }
}

- (NSArray *)getCategoryList
{
    return [[BirdDB share] getAllCategory];
}

- (void)updateCategoryList:(NSArray *)categoryList
{
    [[BirdDB share] updateCategoryListOrder:categoryList];
}

- (NSArray *)getItemsWithCategoryId:(NSString *)aCategoryId
{
    return [[BirdDB share] getItemWithCategory:aCategoryId];
}

- (NSArray *)getUsuallyPropertyWithLimit:(NSInteger )aLimit
{
    return [[BirdDB share] getUsuallyPropertyWithLimit:aLimit];
}

@end
