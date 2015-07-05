//
//  CreateCategoryViewController.h
//  Bird
//
//  Created by 孙永刚 on 15-6-23.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCategoryContent.h"
#import "BItemContent.h"

/**
 *  创建分类或者修改分类备足页面
 */
@interface BCreateCategoryViewController : UIViewController

@property (nonatomic, assign) BOOL isCreate;            //创建or修改分类
@property (nonatomic, strong) BCategoryContent *category;   //分类名

@property (nonatomic, strong) BItemContent *item;

@end
