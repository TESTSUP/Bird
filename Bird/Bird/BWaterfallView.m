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

static const CGFloat edgeOffset = 5.0;
static const CGFloat itemSpace = 10.0;

@interface BWaterfallView ()<UIScrollViewDelegate>
{
    UIView *_contentView;
    UIView *_leftView;
    UIView *_rightView;
    
    BWaterfallCellView *_lastLeftCell;
    BWaterfallCellView *_lastRightCell;
}
@property (nonatomic, strong) NSMutableArray *loadedImageArray;
@property (nonatomic, assign) CGFloat leftColumHeight;
@property (nonatomic, assign) CGFloat rightColumHeight;
@property (nonatomic, assign) NSInteger imgTag;

@end

@implementation BWaterfallView

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

        //初始化列的高度
        self.leftColumHeight = 3.0f;
        self.rightColumHeight = 3.0f;
        
        [self initWithPhotoBox];
    }
    
    return self;
}

/*
 将scrollView界面分为大小相等的3个部分，每个部分为一个UIView, 并设置每一个UIView的tag
 */
- (void)initWithPhotoBox{
    _contentView = UIView.new;
    [self addSubview:_contentView];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
    
    _leftView = [[UIView alloc] initWithFrame:CGRectZero];
    _rightView = [[UIView alloc] initWithFrame:CGRectZero];

    //设置背景颜色
    _contentView.backgroundColor = [UIColor clearColor];
    [_leftView setBackgroundColor:[UIColor clearColor]];
    [_rightView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:_contentView];
    [_contentView addSubview:_leftView];
    [_contentView addSubview:_rightView];
}

- (void)layoutContentView
{
    [_leftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left).offset(edgeOffset);
        make.right.equalTo(_rightView.left).offset(-itemSpace);
        if (_lastLeftCell) {
            make.height.equalTo(_lastLeftCell.bottom).offset(edgeOffset);
        } else {
            make.height.equalTo(0);
        }
        
    }];
    
    [_rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.right.equalTo(self.right).offset(-edgeOffset);
        make.left.equalTo(_leftView.right).offset(itemSpace);
        if (_lastRightCell) {
            make.height.equalTo(_lastRightCell.bottom).offset(edgeOffset);
        } else {
            make.height.equalTo(0).offset(edgeOffset);
        }
    }];
}

- (void)setItemArray:(NSArray *)aItemArray
{
    [self.loadedImageArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.loadedImageArray removeAllObjects];
    
    for (BItemContent *content in aItemArray) {
        [self createCellWithData:content];
    }
    [self checkImageIsVisible];
    
    //第一次加载图片
    [self layoutContentView];
    
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
- (void)createCellWithData:(BItemContent *)content{
    
    BWaterfallCellView *cell = [[BWaterfallCellView alloc] initWithFrame:CGRectZero];
    
    UIImage *image = [BirdUtil getImageWithID:[content.imageIDs firstObject]];
    cell.itemImage = nil;
    cell.itemTitle = content.name;
    CGFloat width = (self.frame.size.width-edgeOffset*2-itemSpace)/2;
    CGSize size = [BWaterfallCellView cellSizeWithImage:image andWidth:width];
    
    [self.loadedImageArray addObject:cell];

    float height = size.height;
    //判断哪一列的高度最低
    if( _leftColumHeight <= _rightColumHeight){
        [_leftView addSubview:cell];
        //重新设置坐标
        _leftColumHeight = _leftColumHeight + height + itemSpace;
        
        if (_lastLeftCell == nil) {
            [cell makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(0);
                make.width.equalTo(_leftView.width);
            }];
        } else {
            [cell makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lastLeftCell.bottom).offset(itemSpace);
                make.left.equalTo(0);
                make.width.equalTo(_leftView.width);
            }];
        }
        _lastLeftCell = cell;
        
    }else{
        [_rightView addSubview:cell];

        _rightColumHeight = _rightColumHeight + height + itemSpace;
        
        if (_lastRightCell == nil) {
            [cell makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(0);
                make.width.equalTo(_leftView.width);
            }];
        } else {
            [cell makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lastRightCell.bottom).offset(itemSpace);
                make.left.equalTo(0);
                make.width.equalTo(_rightView.width);
            }];
        }
        _lastRightCell = cell;
    }
    
    //图片添加事件响应
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithTag:)];
    cell.userInteractionEnabled = YES;
    [cell addGestureRecognizer:tapRecognizer];
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