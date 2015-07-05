//
//  BItemDetailViewController.h
//  Bird
//
//  Created by 孙永刚 on 15-7-3.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BItemContent.h"

/**
 *  物品详情页面
 */
@interface BItemDetailViewController : UIViewController

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) BItemContent *itemContent;

@end
