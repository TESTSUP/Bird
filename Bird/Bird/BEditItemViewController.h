//
//  BEditItemViewController.h
//  Bird
//
//  Created by 孙永刚 on 15-7-3.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BItemContent.h"

/**
 *  物品的名称，标签和描述编辑页面
 */
@interface BEditItemViewController : UIViewController

@property (nonatomic, strong) BItemContent *itemContent;

@end
