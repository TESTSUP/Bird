//
//  BSquareImageView.m
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BSquareImageView.h"

@interface BSquareImageView ()
{
    UIImageView *_imageView;
}

@end

@implementation BSquareImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
    }
    
    return self;
}

- (void)setImage:(UIImage *)aImage
{
    CGFloat sideLength = self.frame.size.width < self.frame.size.height ? self.frame.size.width:self.frame.size.height;
    
    float ratio = aImage.size.width /aImage.size.height;
    CGSize newSize = CGSizeZero;
    if (aImage.size.width < aImage.size.height ) {
        
        CGFloat newHeight = sideLength/ratio;
        newSize = CGSizeMake(sideLength, newHeight);
    } else {
        CGFloat newWidth = sideLength*ratio;
        newSize = CGSizeMake(newWidth, sideLength);
    }
    
    [_imageView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.size.equalTo(newSize);
    }];
    
    [_imageView layoutIfNeeded];
}


@end
