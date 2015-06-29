//
//  BModelInterface.h
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BItemContent.h"
#import "BCategoryContent.h"

typedef NS_ENUM(NSInteger, ModelAction) {
    ModelAction_update,
    ModelAction_create,
    ModelAction_delete
};

@interface BModelInterface : NSObject

+ (BModelInterface *)shareInstance;

/**
 *  处理分类数据
 *
 *  @param aAction   处理类型
 *  @param aCategory 数据
 */
- (void)handleCategoryWithAction:(ModelAction)aAction andData:(BCategoryContent *)aCategory;

/**
 *  处理物品数据
 *
 *  @param aAction 处理类型
 *  @param aItem   数据
 */
- (void)handleItemWithAction:(ModelAction)aAction andData:(BItemContent *)aItem;

/**
 *  获取分类列表
 *
 *  @return 内容为BCategoryContent的数组
 */
- (NSArray *)getCategoryList;

/**
 *  获取物品列表
 *
 *  @param aCategoryName 分类名，传nil则返回所有物品
 *
 *  @return 内容为BItemContent的数组
 */
- (NSArray *)getItemsWithCategoryName:(NSString *)aCategoryName;

/**
 *  获取常用属性列表
 *
 *  @param aLimit 数量限制
 *
 *  @return NSString的数组
 */
- (NSArray *)getUsuallyPropertyWithLimit:(NSInteger )aLimit;

@end
