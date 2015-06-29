//
//  BItemContent.h
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BItemContent : NSObject

@property (nonatomic, strong) NSString *name;       //名字
@property (nonatomic, strong) NSString *category;   //所属分类
@property (nonatomic, strong) NSArray *images;      //图片列表
@property (nonatomic, strong) NSArray *property;    //属性列表

@end
