//
//  BHomeFloadView.m
//  Bird
//
//  Created by 孙永刚 on 15-6-26.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BHomeFloadView.h"
#import "UIColor+Bird.h"

@interface BHomeFloadView()
{
    UIImageView *_sharpView;
    UIView *_lineView;
}

@end

@implementation BHomeFloadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, FloatSize.width, FloatSize.height)];
    [self createSubViews];
    
    [self layoutViews];
    
    return self;
}

- (void)createSubViews
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 5;
    _sharpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"float_sharp"]];
    
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _cameraButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _cameraButton.backgroundColor = [UIColor whiteColor];
    [_cameraButton setImage:[UIImage imageNamed:@"camera_btn_n"] forState:UIControlStateNormal];
    [_cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    [_cameraButton setTitleColor:[UIColor normalTextColor] forState:UIControlStateNormal];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor separatorColor];
    
    _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _photoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _photoButton.backgroundColor = [UIColor whiteColor];
    [_photoButton setImage:[UIImage imageNamed:@"photo_btn_n"] forState:UIControlStateNormal];
    [_photoButton setTitle:@"相册" forState:UIControlStateNormal];
    [_photoButton setTitleColor:[UIColor normalTextColor] forState:UIControlStateNormal];
    
    [self addSubview:_sharpView];
    [self addSubview:_cameraButton];
    [self addSubview:_lineView];
    [self addSubview:_photoButton];
}

- (void)layoutViews
{
    [_sharpView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(self.right).offset(-25);
        make.size.equalTo(CGSizeMake(13, 7));
    }];
    
    [_cameraButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sharpView.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(44);
    }];
    
    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cameraButton.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    [_photoButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(44);
    }];
}

@end
