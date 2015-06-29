//
//  BirdDB.h
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BirdDB : NSObject

+ (BirdDB *)share;

/**
 *  创建数据库，当用户变更时需要重新调用
 */
- (void)buildDB;


@end
