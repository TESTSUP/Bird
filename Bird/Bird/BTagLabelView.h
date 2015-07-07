//
//  BTagLabelView.h
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BTagLabelView;

@protocol BTagLabelViewDelegate <NSObject>

- (void)BTagLabelView:(BTagLabelView *)aLabel didSetTagAtIndex:(NSInteger)aIndex;

- (void)BTagLabelView:(BTagLabelView *)aLabel didDeleteTagAtIndex:(NSInteger)aIndex;

@end

@interface BTagLabelView : UILabel

@property (nonatomic, weak) id<BTagLabelViewDelegate> delegate;
@property (nonatomic, strong) NSString *separateStr;    //默认为“|”
@property (nonatomic, strong) NSArray *tagArray;        //标签数组，NSString*

@end