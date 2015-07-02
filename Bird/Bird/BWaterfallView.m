//
//  BWaterfallView.m
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//
//参考
//http://blog.csdn.net/shenjie12345678/article/details/26599929

#import "BWaterfallView.h"
#import "BWaterfallCellView.h"
#import "BItemContent.h"
#import "BirdUtil.h"

#define COORDINATE_X_LEFT 5
#define COORDINATE_X_MIDDLE MY_WIDTH/3 + 5
#define COORDINATE_X_RIGHT MY_WIDTH/3 * 2 + 5
#define PAGESIZE 21

@interface BWaterfallView ()<UIScrollViewDelegate>
{
    UIView *_leftView;
    UIView *_rightView;
}
@property (nonatomic, strong) NSMutableArray *loadedImageArray;
@property (nonatomic, assign) CGFloat leftColumHeight;
@property (nonatomic, assign) CGFloat rightColumHeight;
@property (nonatomic, assign) NSInteger imgTag;
@property (nonatomic, strong) NSMutableDictionary *imgTagDic;

@end

@implementation BWaterfallView

@synthesize imgTag = _imgTag;
@synthesize imgTagDic = _imgTagDic;


/*
 初始化scrollView的委托以及背景颜色，不显示它的水平，垂直显示条
 */
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.delegate = self;
        self.backgroundColor = [UIColor blackColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.loadedImageArray = [[NSMutableArray alloc] init];
        self.imgTagDic = [[NSMutableDictionary alloc] init];
        
        //初始化列的高度
        self.leftColumHeight = 3.0f;
        self.rightColumHeight = 3.0f;
        self.imgTag = 10086;
        
        [self initWithPhotoBox];
    }
    
    return self;
}

/*
 将scrollView界面分为大小相等的3个部分，每个部分为一个UIView, 并设置每一个UIView的tag
 */
- (void)initWithPhotoBox{
    _leftView = [[UIView alloc] initWithFrame:CGRectZero];
    _rightView = [[UIView alloc] initWithFrame:CGRectZero];

    //设置背景颜色
    [_leftView setBackgroundColor:[UIColor clearColor]];
    [_rightView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:_leftView];
    [self addSubview:_rightView];
    

}

- (void)layoutSubviews
{
    [_leftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left).offset(5);
        make.right.equalTo(_rightView.left).offset(-10);
        make.height.equalTo(_leftColumHeight);
    }];
    
    [_rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.right.equalTo(self.right).offset(-5);
        make.left.equalTo(_leftView.right).offset(10);
        make.height.equalTo(_rightColumHeight);
    }];
}

- (void)setItemArray:(NSArray *)aItemArray
{
    [self.loadedImageArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.loadedImageArray removeAllObjects];
    
    for (BItemContent *content in aItemArray) {
        BWaterfallCellView *cell = [[BWaterfallCellView alloc] initWithFrame:CGRectZero];
        
        UIImage *image = [BirdUtil getImageWithID:[content.imageIDs firstObject]];
        cell.itemImage = nil;
        cell.itemTitle = content.name;
        
        CGSize size = [cell cellSizeWithImage:image];
        [self addCell:cell withSize:size];
        [self checkImageIsVisible];
    }
    //第一次加载图片
    [self layoutSubviews];
    [self layoutIfNeeded];
    
    [self adjustContentSize:NO];
}

/*调整scrollview*/
- (void)adjustContentSize:(BOOL)isEnd{

    if( _leftColumHeight >= _rightColumHeight){
        self.contentSize = _leftView.frame.size;
    }else{
        self.contentSize = _rightView.frame.size;
    }
}

/*
 得到最短列的高度
 */
- (float)getTheShortColum{
    if( _leftColumHeight <= _rightColumHeight){
        return _leftColumHeight;
    }else{
        return _rightColumHeight;
    }
}

/*
 添加一张图片
 规则：根据每一列的高度来决定，优先加载列高度最短的那列
 重新设置图片的x,y坐标
 imageView:图片视图
 imageName:图片名
 */
- (void)addCell:(BWaterfallCellView *)cell withSize:(CGSize)aSize{
    [self.loadedImageArray addObject:cell];
    
    //图片添加事件响应
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithTag:)];
    cell.userInteractionEnabled = YES;
    [cell addGestureRecognizer:tapRecognizer];

    float width = aSize.width;
    float height = aSize.height;
    //判断哪一列的高度最低
    if( _leftColumHeight <= _rightColumHeight){
        [_leftView addSubview:cell];
        //重新设置坐标
        [cell setFrame:CGRectMake(2, _leftColumHeight, width, height)];
        _leftColumHeight = _leftColumHeight + height + 3;
    }else{
        [_rightView addSubview:cell];
        
        [cell setFrame:CGRectMake(2, _rightColumHeight, width, height)];
        _rightColumHeight = _rightColumHeight + height + 3;
    }
}

/*
 //若三列中最短列距离底部高度超过30像素，则请求加载新的图片
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //可视检查
    [self checkImageIsVisible];
}



/*
 检查图片是否可见，如果不在可见视线内，则把图片替换为nil
 */
- (void)checkImageIsVisible{
    for (BWaterfallCellView *cell in self.loadedImageArray) {
        if((self.contentOffset.y - cell.frame.origin.y) > cell.frame.size.height ||
           cell.frame.origin.y > (self.frame.size.height + self.contentOffset.y)){
            //不显示图片
            cell.itemImage = nil;
        }else{
            //重新根据tag值显示图片
            NSInteger index = [self.loadedImageArray indexOfObject:cell];
            BItemContent *content = [_itemArray objectAtIndex:index];
            cell.itemImage = [BirdUtil getImageWithID:[content.imageIDs firstObject]];
        }
    }
}

//点击图片事件响应
- (void)imageClickWithTag:(UITapGestureRecognizer *)sender{

    

}


- (void)dealloc{

}

@end