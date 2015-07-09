//
//  BSearchItemViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/7/5.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BSearchItemViewController.h"
#import "BWaterfallView.h"
#import "BCollectionViewCell.h"
#import "BWaterfallLayout.h"
#import "BModelInterface.h"
#import "BirdUtil.h"
#import "BItemContent.h"
#import "BItemDetailViewController.h"

static const CGFloat leftOffset = 5;
static const CGFloat itemSpace = 10;

#define WIDTH (([UIScreen mainScreen].bounds.size.width-(leftOffset*2+itemSpace))/(CollectionViewColCount))

CGFloat const kImageCount = 16;
static NSString *identifier = @"collectionView";

@interface BSearchItemViewController () <UISearchBarDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UISearchBar *_searchBar;
    BWaterfallView *_contentView;
    UICollectionView *_collectionView;
    NSArray *_itemsData;
    
    UIButton *cancelButton;
    UIButton *_cancelBtn;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BSearchItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:231.0/255.0
                                                green:231.0/255.0
                                                 blue:231.0/255.0
                                                alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createSearchBar];
    
    [self createContentView];
    
    [self layoutSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)createSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.backgroundImage = [BirdUtil imageWithColor:self.view.backgroundColor];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"名字/描述/标签";
    _searchBar.showsCancelButton = YES;
    
    [self.view addSubview:_searchBar];
    
//    UIView *topView = _searchBar.subviews[0];
//    for (UIView *subView in topView.subviews) {
//        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
//            cancelButton = (UIButton*)subView;
//        }
//    }
//    if (cancelButton) {
//        //Set the new title of the cancel button
//        cancelButton.enabled = YES;
//        cancelButton.hidden = YES;
//        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cancelBtn.frame = cancelButton.frame;
//        _cancelBtn.backgroundColor = [UIColor clearColor];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:[cancelButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
//        _cancelBtn.titleLabel.font = cancelButton.titleLabel.font;
//        [_cancelBtn addTarget:self action:@selector(handleCancelAction) forControlEvents:UIControlEventTouchDragInside];
//        [topView addSubview:_cancelBtn];
//    }
}

- (void)createContentView
{
    BWaterfallLayout *flowLayout = [[BWaterfallLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[BCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:_collectionView];
    
}

- (void)layoutSubViews
{
    [_searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(44);
    }];
    
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
}

- (void)loadDataWithKeyWord:(NSString *)aKey
{
    _itemsData = [[BModelInterface shareInstance] getItemsWithKeyWord:aKey];
    
    [_collectionView reloadData];
}

#pragma mark -

- (void)handleCancelAction
{
    NSLog(@"search cancel");
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select index = %ld", (long)indexPath.row);
    if (indexPath.row < [_itemsData count]) {
        BItemContent *content = [_itemsData objectAtIndex:indexPath.row];
        BItemDetailViewController *detailVC = [[BItemDetailViewController alloc] init];
        detailVC.itemContent = content;
        detailVC.categoryName = content.name;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_itemsData count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BCollectionViewCell *cell = (BCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    BItemContent *content = [_itemsData objectAtIndex:indexPath.row];
    cell.itemImage = content.coverImage;
    cell.itemTitle = content.name;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    BItemContent *content = [_itemsData objectAtIndex:indexPath.row];

    CGSize size = [BCollectionViewCell cellSizeWithImage:content.coverImage titile:content.name andWidth:WIDTH];
    return size;
}

//边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets edgeInsets = {5, 5, 5, 5};
    return edgeInsets;
}

#pragma mark - UISearchBarDelegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if ([searchBar.text length]) {
        [self loadDataWithKeyWord:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
