//
//  SelectCatrgoryViewController.h
//  Bird
//
//  Created by 孙永刚 on 15/6/27.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BItemContent.h"

@class BSelectCatrgoryViewController;

@protocol BSelectCatrgoryViewControllerDelegate <NSObject>

- (void)BSelectCatrgoryViewController:(BSelectCatrgoryViewController*)vc didSlectedCategoryName:(NSString *)aName;

@end

/**
 *  创建新分类时选择默认的分类页面
 */
@interface BSelectCatrgoryViewController : UIViewController

@property (nonatomic, weak) id<BSelectCatrgoryViewControllerDelegate> delegate;
@property (nonatomic, strong) BItemContent *item;

@end
