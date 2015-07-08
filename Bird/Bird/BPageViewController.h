//
//  BPageViewController.h
//  Bird
//
//  Created by 孙永刚 on 15/7/8.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BPageViewController;

@protocol BPageViewControllerDelegate <NSObject>

- (void)BPageViewController:(BPageViewController *)aVC didSetCoverAtIndex:(NSInteger)aIndex;
- (void)BPageViewController:(BPageViewController *)aVC didDeleteImageAtIndex:(NSInteger)aIndex;

@end

@interface BPageViewController : UIViewController

@property (nonatomic, assign) id<BPageViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *imageDatas;
@property (nonatomic, strong) NSArray *imageIds;

@end
