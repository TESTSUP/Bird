//
//  BModelInterface.m
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BModelInterface.h"
#import "BirdDB.h"

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
    
}


- (void)handleItemWithAction:(ModelAction)aAction andData:(BItemContent *)aItem
{
    
}

- (NSArray *)getCategoryList
{
    return nil;
}


- (NSArray *)getItemsWithCategoryName:(NSString *)aCategoryName
{
    return nil;
}

- (NSArray *)getUsuallyPropertyWithLimit:(NSInteger )aLimit
{
    return nil;
}

@end
