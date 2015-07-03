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
            [[BirdDB share] updateCategoryDesc:aCategory];
        }
            break;
        case ModelAction_create:
        {
            [[BirdDB share] insertCategory:aCategory];
        }
            break;
        case ModelAction_delete:
        {
            [[BirdDB share] delete:aCategory.name];
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
            [aItem createImageIds];
            [[BirdDB share] insertItem:aItem];
        }
            break;
        case ModelAction_update:
        {
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

- (NSArray *)getItemsWithCategoryName:(NSString *)aCategoryName
{
    return [[BirdDB share] getItemWithCategory:aCategoryName];
}

- (NSArray *)getUsuallyPropertyWithLimit:(NSInteger )aLimit
{
    return nil;
}

@end
