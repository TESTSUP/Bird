//
//  BGlobalConfig.h
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DefaultUser = @"bird_guest";
static const NSInteger MAX_ItemImageCount = 9;

@interface BGlobalConfig : NSObject

+(BGlobalConfig *)shareInstance;

//预留字段，用户概念扩展
@property (nonatomic, strong) NSString *currentUser;
//cache路径
@property (nonatomic, readonly) NSString *userCacheDirectory;
//数据库路径
@property (nonatomic, readonly) NSString *DBPath;
//存储的图片路径
@property (nonatomic, readonly) NSString *imageSourcePath;
//默认属性列表,成员为NSString
@property (nonatomic, readonly) NSArray *propertyList;
//默认分类列表，成员为NSArray
@property (nonatomic, readonly) NSArray *categoryList;

@end
