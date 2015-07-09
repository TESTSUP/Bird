//
//  BCollectionViewCell.h
//  Bird
//
//  Created by 孙永刚 on 15-7-9.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) NSString *itemTitle;

+ (CGSize)cellSizeWithImage:(UIImage *)aImage
                     titile:(NSString *)aTitle
                   andWidth:(CGFloat)width;

@end
