//
//  BWaterfallView.h
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWaterfallView;

@protocol BWaterfallViewDelagate <NSObject>

- (void)BWaterfallView:(BWaterfallView *)aWaterfall didSelectedItemAtIndex:(NSInteger)aIndex;

@end


@interface BWaterfallView : UIScrollView

@property (nonatomic, weak) id<BWaterfallViewDelagate> waterfallDelegate;

@property (nonatomic, strong) NSArray *itemArray;

@end
