//
//  BItemDetailViewController.m
//  Bird
//
//  Created by 孙永刚 on 15-7-3.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BItemDetailViewController.h"
#import "UIViewController+Bird.h"
#import "BirdUtil.h"
#import "BTagLabelView.h"

static const CGFloat CoverSide = 230;
static const CGFloat AddBtnSide = 65;
static const CGFloat DefaultDescViewHeight = 50;
static const CGFloat ThumbnailSide = 70;
static const CGFloat topOffset = 5;
static const CGFloat leftOffset = 10;

@interface BItemDetailViewController ()
{
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    //封面和添加照片按钮
    UIImageView *_coverView;
    UIButton *_addImageBtn;
    
    //图片九宫格
    UIView *_thumbnailView;
    NSMutableArray *_imageViewArray;
    
    //物品描述
    UIView *_itemDescView;
    UIView *_topDescLine;
    UITextField *_titleView;
    UIImageView *_editeIcon;
    BTagLabelView *_tagView;
    UIView *_bottomDescLine;
}
@end

@implementation BItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configNavigationBar];
    
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)configNavigationBar
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    [backBtn addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:self.categoryName forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    backBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    backBtn.titleLabel.numberOfLines = 1;
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    // 调整 leftBarButtonItem 在 iOS7 下面的位置
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame =  CGRectMake(0, 0, 44, 44);
    [deleteBtn addTarget:self action:@selector(handleDeleteAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"nav_delete"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, leftBarItem] animated:YES];
    self.navigationItem.rightBarButtonItem = rightItme;
}

#pragma mark - create views

- (void)createSubViews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_scrollView addSubview:_contentView];
    [self.view addSubview:_scrollView];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    [self createTopView];
    [self createThumbnailView];
    [self createDescView];
}

- (void)createTopView
{
    _coverView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addImageBtn setImage:[UIImage imageNamed:@"item_addImage"] forState:UIControlStateNormal];
    [_addImageBtn addTarget:self action:@selector(handleAddImageAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_coverView];
    [_contentView addSubview:_addImageBtn];
}

- (void)createThumbnailView
{
    _thumbnailView = [[UIView alloc] initWithFrame:CGRectZero];
    _thumbnailView.backgroundColor = [UIColor greenColor];
    [_contentView addSubview:_thumbnailView];
}

- (void)createDescView
{
    _itemDescView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _topDescLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomDescLine = [[UIView alloc] initWithFrame:CGRectZero];
    _topDescLine.backgroundColor = [UIColor colorWithRed:204.0/255.0
                                              green:204.0/255.0
                                               blue:204.0/255.0
                                              alpha:1.0];
    _bottomDescLine.backgroundColor = [UIColor colorWithRed:204.0/255.0
                                                 green:204.0/255.0
                                                  blue:204.0/255.0
                                                 alpha:1.0];
    
    
    
    _titleView = [[UITextField alloc] initWithFrame:CGRectZero];
    _titleView.placeholder = @"物品/描述/标签";
    
    _editeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_editeIcon"]];
    _tagView = [[BTagLabelView alloc] initWithFrame:CGRectZero];
    
    [_itemDescView addSubview:_topDescLine];
    [_itemDescView addSubview:_titleView];
    [_itemDescView addSubview:_editeIcon];
    [_itemDescView addSubview:_tagView];
    [_itemDescView addSubview:_bottomDescLine];
    [_contentView addSubview:_itemDescView];
}

#pragma mark - layout

- (void)layoutThumbnailView
{
    for (UIImageView *imageView in _imageViewArray) {
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    NSInteger count = [_imageViewArray count];
    NSInteger line = count/4+ ((count%4)? 1:0);
    CGFloat height = line*ThumbnailSide +(line-1)*leftOffset;
    
    [_thumbnailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_coverView.bottom).offset(topOffset);
        make.left.equalTo(leftOffset);
        make.right.equalTo(-leftOffset);
        make.height.equalTo(height);
    }];
}

- (void)layoutDescView
{
    [_topDescLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    [_titleView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_editeIcon.centerY);
        make.left.equalTo(leftOffset);
        make.width.equalTo(CoverSide+10);
    }];
    
     [_editeIcon makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(14);
         make.size.equalTo(CGSizeMake(22, 22));
         make.right.equalTo(-(leftOffset+5));
     }];
    
    CGFloat tagHeight = 0;
    if ([_tagView.text length]) {
        CGRect rect = [_tagView.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-2*leftOffset, 99999)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:_tagView.font}
                                                  context:nil];
        tagHeight = rect.size.height;
    }
    [_tagView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DefaultDescViewHeight);
        make.left.equalTo(leftOffset);
        make.right.equalTo(-leftOffset);
        make.height.equalTo(tagHeight);
    }];
    
    [_bottomDescLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tagView.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    UIView *lastView = _thumbnailView;
     if ([_imageViewArray count] == 0) {
         lastView = _coverView;
     }
    [_itemDescView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.bottom).offset(topOffset);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(DefaultDescViewHeight);
//        make.bottom.equalTo(_bottomDescLine.bottom);
    }];
}

- (void)layoutsubViews
{
    [_coverView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topOffset);
        make.left.equalTo(leftOffset);
        make.size.equalTo(CGSizeMake(CoverSide, CoverSide));
    }];
    
    [_addImageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-leftOffset);
        make.bottom.equalTo(_coverView.bottom);
        make.size.equalTo(CGSizeMake(AddBtnSide, AddBtnSide));
    }];
    
    [self layoutThumbnailView];
    
    [self layoutDescView];
}

#pragma mark - data

- (void)loadImagesData
{
    if (_imageViewArray == nil) {
        _imageViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [_imageViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imageViewArray removeAllObjects];
    if ([self.itemContent.imageIDs count] <=1) {
        return;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.itemContent.imageIDs];
    [tempArray removeObjectAtIndex:0];
    
    for (NSString *imageId in tempArray) {
        UIImage *image = [self.itemContent imageWithId:imageId];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ThumbnailSide, ThumbnailSide)];
        imageView.image = [BirdUtil squareThumbnailWithOrgImage:image andSideLength:ThumbnailSide];
        
        [_thumbnailView addSubview:imageView];
        imageView.tag = [self.itemContent.imageIDs indexOfObject:imageId];
        [_imageViewArray addObject:imageView];
    }
}

- (void)loadData
{
    UIImage *cover = [self.itemContent imageWithId:[self.itemContent.imageIDs firstObject]];
    _coverView.image = [BirdUtil squareThumbnailWithOrgImage:cover andSideLength:CoverSide];

    [self loadImagesData];
    
    [self layoutsubViews];
}

#pragma mark - action 

- (void)handleBackAction
{
    [self popToViewControllerNamed:@"BHomeViewController"];
}

- (void)handleDeleteAction
{
    
}

- (void)handleAddImageAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end