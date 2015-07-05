//
//  BCreateItemViewController.h
//  Bird
//
//  Created by 孙永刚 on 15-7-3.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BItemContent.h"

@class BCreateItemViewController;

@protocol BCreateItemViewDelegate <NSObject>

- (void)BCreateItemViewController:(BCreateItemViewController *)aVC didCreateItem:(BItemContent *)aItem;
- (void)BCreateItemViewController:(BCreateItemViewController *)aVC didAddCategory:(BItemContent *)aItem;

@end

/**
 *  创建物品时选择分类页面
 */
@interface BCreateItemViewController : UIViewController

@property (nonatomic, weak) id<BCreateItemViewDelegate> delegate;
@property (nonatomic, strong) NSArray *imageArray;

- (void)refreshData;

@end
