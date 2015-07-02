//
//  BWaterfallCellView.m
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BWaterfallCellView.h"

@interface BWaterfallCellView ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

@end

@implementation BWaterfallCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)createSubViews
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor greenColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:_imageView];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(self.width);
        
    }];
}

#pragma mark -

- (void)setItemImage:(UIImage *)itemImage
{
    
}

- (void)setItemTitle:(NSString *)itemTitle
{
    
}

@end
