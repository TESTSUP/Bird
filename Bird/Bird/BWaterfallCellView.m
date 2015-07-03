//
//  BWaterfallCellView.m
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BWaterfallCellView.h"
#import "BirdUtil.h"

static const CGFloat labelHeight = 40;

@interface BWaterfallCellView ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    
    CGSize _imageSize;
    CGFloat _ratioHW;   //高宽比例
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
        make.height.equalTo(self.width).multipliedBy(_ratioHW);
    }];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(40);
    }];
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_titleLabel.bottom);
    }];
}

+ (CGSize)cellSizeWithImage:(UIImage *)aImage andWidth:(CGFloat)width
{
    CGFloat orgi_width = aImage.size.width;
    CGFloat orgi_height = aImage.size.height;
    
    return CGSizeMake(width, (orgi_height/orgi_width)*width + labelHeight);
}

#pragma mark -

- (void)setItemImage:(UIImage *)itemImage
{
    CGFloat orgi_width = itemImage.size.width;
    CGFloat orgi_height = itemImage.size.height;
    _ratioHW = orgi_height/orgi_width;
    
    [self layoutSubviews];
}

- (void)setItemTitle:(NSString *)itemTitle
{
    _titleLabel.text = itemTitle;
}

@end
