//
//  BWaterfallCellView.h
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWaterfallCellView : UIView

@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) NSString *itemTitle;

- (CGSize)cellSizeWithImage:(UIImage *)aImage;

@end
