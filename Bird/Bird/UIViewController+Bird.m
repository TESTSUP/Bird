//
//  UIViewController+Bird.m
//  Bird
//
//  Created by 孙永刚 on 15-7-3.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "UIViewController+Bird.h"

@implementation UIViewController (Bird)

- (void)popToViewControllerNamed:(NSString *)aViewControllerName
{
    if ([aViewControllerName length] && self.navigationController) {
        
        for (UIViewController *subVC in self.navigationController.viewControllers) {
            NSString *subVCName = NSStringFromClass([subVC class]);
            if ([subVCName isEqualToString:aViewControllerName]) {
                [self.navigationController popToViewController:subVC animated:YES];
                break;
            }
        }
    }
}

@end
