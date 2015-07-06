//
//  BCreateItemViewController.m
//  Bird
//
//  Created by 孙永刚 on 15-7-3.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BCreateItemViewController.h"
#import "BSelectCatrgoryViewController.h"
#import "BCategoryContent.h"
#import "BModelInterface.h"
#import "BirdUtil.h"

static const CGFloat Cell_Height = 50;
static const CGFloat Table_Width = 300;
static const CGFloat Table_Height = 405;
static const CGFloat CornerRadius = 5;
static const CGFloat CoverSide = 40;

@interface BCreateItemViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIView *_contentView;
    
    UIImageView *_iTemCover;
    UIView *_headerView;
    UIView *_lineView;
    UITableView *_categoryTable;
    
    NSArray *_categoryArray;
}
@end

@implementation BCreateItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0
                                                green:0
                                                 blue:0 alpha:0.3];
    
    [self createSubView];
    
    [self layoutSubViews];
    
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createSubView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.layer.cornerRadius = CornerRadius;
    _contentView.clipsToBounds = YES;
    [self.view addSubview:_contentView];
    
    [self createHeaderView];
    
    [self createTableView];
}

- (void)createHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Table_Width, Cell_Height)];
    _headerView.backgroundColor = [UIColor colorWithRed:247.0/255.0
                                                  green:247.0/255.0
                                                   blue:247.0/255.0
                                                  alpha:1.0];
    
    _iTemCover = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iTemCover.image = [_imageArray count]? [_imageArray firstObject]:nil;
    _iTemCover.backgroundColor = [UIColor clearColor];
    UIButton * _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(handleCloseAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"选择一个分类";
    titleView.textColor = [UIColor colorWithRed:68.0/255.0
                                          green:68.0/255.0
                                           blue:68.0/255.0
                                          alpha:1.0];
    titleView.font = [UIFont systemFontOfSize:16];
    
    [_headerView addSubview:titleView];
    [_headerView addSubview:_iTemCover];
    [_headerView addSubview:_closeBtn];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0
                                                green:204.0/255.0
                                                 blue:204.0/255.0
                                                alpha:1.0];
    [_contentView addSubview:_lineView];
    [_contentView addSubview:_headerView];
    
    [_iTemCover makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
        make.centerY.equalTo(_headerView);
        make.size.equalTo(CGSizeMake(CoverSide, CoverSide));
    }];
    
    [_closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-3);
        make.centerY.equalTo(_headerView);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.bottom.equalTo(0);
        make.centerX.equalTo(_headerView);
        make.width.equalTo(100);
    }];
}

- (void)createTableView
{
    _categoryTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _categoryTable.delegate = self;
    _categoryTable.dataSource = self;
    _categoryTable.showsVerticalScrollIndicator = NO;
    _categoryTable.showsHorizontalScrollIndicator = NO;
    _categoryTable.separatorColor = [UIColor colorWithRed:204.0/255.0
                                                    green:204.0/255.0
                                                     blue:204.0/255.0
                                                    alpha:1.0];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    _categoryTable.tableFooterView = footView;
    if ([_categoryTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_categoryTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_categoryTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_categoryTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [_contentView addSubview:_categoryTable];
}

- (void)layoutSubViews
{
    [_headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(0);
        make.left.equalTo(0);
        make.height.equalTo(Cell_Height);
    }];
    
    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(_headerView.bottom);
        make.height.equalTo(0.5);
    }];
    
    [_categoryTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(Table_Width);
        make.height.equalTo(Table_Height);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}

- (void)refreshData
{
    _categoryArray = [[BModelInterface shareInstance] getCategoryList];
    [_categoryTable reloadData];
    
    UIImage *orgImage = [_imageArray count]? [_imageArray firstObject]:nil;
    
    _iTemCover.image = [BirdUtil squareThumbnailWithOrgImage:orgImage andSideLength:CoverSide];
}

#pragma mark - action

- (void)handleCloseAction
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         self.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BItemContent *content = [[BItemContent alloc] init];
    content.itemID = [BirdUtil createItemID];
    content.imageDatas = self.imageArray;
    if (indexPath.row >= [_categoryArray count]) {
        //添加分类
        if (self.delegate && [self.delegate respondsToSelector:@selector(BCreateItemViewController:didAddCategory:)]) {
            [self.delegate BCreateItemViewController:self didAddCategory:content];
        }
    } else {
        //选中分类
        if (self.delegate && [self.delegate respondsToSelector:@selector(BCreateItemViewController:didCreateItem:)]) {
            BCategoryContent *category = [_categoryArray objectAtIndex:indexPath.row];
            content.categoryId = category.categoryId;
            [self.delegate BCreateItemViewController:self didCreateItem:content];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categoryArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const NSInteger addBtnTag = 9999;
    static NSString *cellId = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:68.0/255.0
                                                   green:68.0/255.0
                                                    blue:68.0/255.0
                                                   alpha:1.0];
        
        UIImageView *addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_add_category"]];
        addImage.tag = addBtnTag;
        [cell.contentView addSubview:addImage];
        [addImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.centerY.equalTo(cell.contentView);
            make.width.equalTo(22);
            make.height.equalTo(22);
        }];
    }
    
    UIImageView *addBtn = (UIImageView *)[cell.contentView viewWithTag:addBtnTag];
    addBtn.hidden = YES;
    cell.textLabel.text = nil;
    if (indexPath.row < [_categoryArray count]) {
        BCategoryContent *category = [_categoryArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [category.descr length]? category.descr:category.name;
    } else if (indexPath.row == [_categoryArray count]) {
        addBtn.hidden = NO;
    }
    
    return cell;
}


@end
