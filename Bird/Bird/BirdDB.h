//
//  BirdDB.h
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BItemContent.h"
#import "BCategoryContent.h"

@interface BirdDB : NSObject

+ (BirdDB *)share;

/**
 *  创建数据库，当用户变更时需要重新调用
 */
- (void)buildDB;

//物品操作
- (void)insertItem:(BItemContent *)aItem;
- (NSArray *)getItemWithCategory:(NSString *)category;
- (NSArray *)getItemsWithKeyWord:(NSString *)aKey;
- (void)deleteItmeWithId:(NSString *)aItemId;

//分类操作
- (void)insertCategory:(BCategoryContent *)aCategory;
- (void)updateCategoryDesc:(BCategoryContent *)aCategory;
- (BCategoryContent *)getCategoryWithId:(NSString *)aCategoryId;
- (NSArray *)getAllCategory;
- (void)updateCategoryListOrder:(NSArray *)aCategoryList;
- (void)deleteCateGoryWithId:(NSString *)aCategoryId;

//属性
- (void)insertPropertyList:(NSArray *)aProperty withCategoryId:(NSString *)aCategoryId;
- (NSArray *)getUsuallyPropertyWithLimit:(NSInteger)aLimit;
- (NSArray *)getUsuallyPropertyWithLimit:(NSInteger)aLimit byCateGoryId:(NSString *)aCategoryId;
@end
