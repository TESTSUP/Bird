//
//  BWaterfallCellView.m
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BWaterfallCellView.h"
#import "BirdUtil.h"

static const CGFloat labelHeight = 27;

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
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2.0;
    self.clipsToBounds = YES;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor colorWithRed:68.0/255.0
                                            green:68.0/255.0
                                             blue:68.0/255.0
                                            alpha:1.0];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    
    _imageView.backgroundColor = [UIColor clearColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_titleLabel];
}

- (void)layoutCell
{
    [_imageView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(self.contentView.width).multipliedBy(_ratioHW);
    }];
    
    [_titleLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo([_titleLabel.text length]>0? labelHeight:0);
    }];
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_titleLabel.bottom);
    }];
}

+ (CGSize)cellSizeWithImage:(UIImage *)aImage titile:(NSString *)aTitle andWidth:(CGFloat)width
{
    CGFloat orgi_width = aImage.size.width;
    CGFloat orgi_height = aImage.size.height;
    
    return CGSizeMake(width, (orgi_height/orgi_width)*width + ([aTitle length]>0? labelHeight:0));
}

#pragma mark -

- (void)setItemImage:(UIImage *)itemImage
{
    if (!itemImage) {
        return;
    }
    CGFloat orgi_width = itemImage.size.width;
    CGFloat orgi_height = itemImage.size.height;
    _ratioHW = orgi_height/orgi_width;
    _imageView.image = [BirdUtil compressImage:itemImage withWidth:160];
    [self layoutCell];
}

- (void)setItemTitle:(NSString *)itemTitle
{
    if (itemTitle == nil) {
        return;
    }
    NSString *temp = @"    ";
    _titleLabel.text = [temp stringByAppendingString:itemTitle];
    [self layoutCell];
}

@end
