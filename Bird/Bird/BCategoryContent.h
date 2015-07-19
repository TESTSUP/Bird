//
//  BCategoryContent.h
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCategoryContent : NSObject

@property (nonatomic, strong) NSString *name;               //分类名
@property (nonatomic, strong) NSString *categoryId;         //分类id
@property (nonatomic, strong) NSString *descr;              //备注
@property (nonatomic, assign) BOOL fromDefault;             //是否是从常用分类中创建的
@property (nonatomic, assign) NSTimeInterval createTime;    //创建时间
@property (nonatomic, assign) NSTimeInterval updateTime;    //更新时间

@end
