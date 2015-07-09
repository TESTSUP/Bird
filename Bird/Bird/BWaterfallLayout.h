//
//  BWaterfallLayout.h
//  Bird
//
//  Created by 孙永刚 on 15-7-9.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInteger const CollectionViewColCount = 2;

@interface BWaterfallLayout : UICollectionViewFlowLayout

@property(nonatomic,assign)id<UICollectionViewDelegateFlowLayout> delegate;
@property(nonatomic,assign)NSInteger cellCount;//cell的个数
@property(nonatomic,strong)NSMutableArray *colArr;//存放列的高度
@property(nonatomic,strong)NSMutableDictionary *attributeDict;//cell的位置信息

@end
