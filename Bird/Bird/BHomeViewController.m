//
//  ViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/6/16.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BHomeViewController.h"
#import "BCategoryListViewController.h"
#import "BHomeFloadView.h"
#import "ZYQAssetPickerController.h"
#import "BCreateCategoryViewController.h"
#import "BWaterfallView.h"
#import "BModelInterface.h"
#import "BCreateItemViewController.h"
#import "BItemDetailViewController.h"
#import "BSearchItemViewController.h"
#import "BirdUtil.h"

#define TAG_ADD     9999
#define TAG_LABEL   9998

static const CGFloat SideWidth = 75;
static const CGFloat SideCellHeight = 50;
static const CGFloat SideFooterHeight = 40;
static const NSTimeInterval animationDur3 = 0.3;

@interface BHomeViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ZYQAssetPickerControllerDelegate,
BCreateItemViewDelegate,
BWaterfallViewDelagate>
{
    BCreateItemViewController *_createItemVC;
    
    UIButton *_headerButton;
    UITableView *_categoryTableView;
    UIView *_tableFooter;
    BWaterfallView *_contentView;
    BHomeFloadView *_floadView;
    
    NSArray *_itemsData;
    NSMutableArray *_categoryData;
    NSString *_selectedCategoryId;
    
    BOOL _orderChanged;
}

@property (nonatomic, assign) BOOL showSideView;
@property (nonatomic, assign) BOOL showFloatView;
@property (nonatomic, strong) NSString *selectedCategoryId;

@end

@implementation BHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _showSideView = YES;
    _showFloatView = NO;
    
    [self configNavigationBar];
    
    [self createSideTableView];

    [self createContentView];
    
    [self createFloatView];
    
    [self createGestureSwipe];
    
    [self layoutSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self refreshCatagoryData];
    self.selectedCategoryId = _selectedCategoryId;
    [_createItemVC refreshData];
    [self setCreateItemViewAlpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.showFloatView = NO;
    [self setCreateItemViewAlpha:0.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config views

- (void)configLeftNavButtonTextColor
{
//    NSArray *items = self.navigationItem.leftBarButtonItems;
//    UIBarButtonItem *leftItem = [items lastObject];
//    UIButton *leftBtn = (UIButton *)leftItem.customView;
//    
//    if ([leftBtn isKindOfClass:[UIButton class]]) {
//        NSIndexPath *selected = [_categoryTableView indexPathForSelectedRow];
//        if(selected) {
//            [leftBtn setTitleColor:[UIColor normalTextColor]
//                          forState:UIControlStateNormal];
//            
//        } else {
//            [leftBtn setTitleColor:[UIColor selectedTextColor]
//                          forState:UIControlStateNormal];
//        }
//    }
}

- (void)createLeftNavigationBarItem
{
    UIButton *customView = nil;
    if (self.showSideView) {
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        homeBtn.frame = CGRectMake(0, 0, 65, 40);
        [homeBtn setTitle:@"星鸟" forState:UIControlStateNormal];
        [homeBtn setTitleColor:[UIColor normalTextColor] forState:UIControlStateNormal];
        [homeBtn setImage:[UIImage imageNamed:@"NavigationBar_home"] forState:UIControlStateNormal];
        customView = homeBtn;
    } else {
        UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.frame = CGRectMake(0, 0, 40, 40);
        [categoryBtn addTarget:self action:@selector(handleShowSideViewAction) forControlEvents:UIControlEventTouchUpInside];
        [categoryBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        customView = categoryBtn;
    }
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    // 调整 leftBarButtonItem 在 iOS7 下面的位置
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    customView.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, leftBarItem] animated:YES];
    
    [self configLeftNavButtonTextColor];
}

- (void)configNavigationBar
{
    [self createLeftNavigationBarItem];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"nav_add_item"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(handleAddButtonAction) forControlEvents:UIControlEventTouchUpInside];
    addBtn.frame = CGRectMake(0, 0, 40, 44);
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(handleSearchAction) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.frame = CGRectMake(0, 0, 40, 44);
    
    UIBarButtonItem *addBarItme = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    UIBarButtonItem *searchBarItme = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[addBarItme, searchBarItme];
}

- (void)layoutSubViews
{
    CGFloat offset = _showSideView? 0:(-SideWidth);
    
    [_categoryTableView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(_tableFooter.top);
        make.left.equalTo(self.view).offset(offset);
        make.width.equalTo(SideWidth);
    }];
    
    [_tableFooter remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_categoryTableView.left);
        make.right.equalTo(_categoryTableView.right);
        make.bottom.equalTo(self.view.bottom);
        make.top.equalTo(_categoryTableView.bottom);
        make.height.equalTo(SideFooterHeight);
    }];
    
    [_contentView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_categoryTableView.right).offset(0);
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(self.view.bottom);
        make.right.equalTo(self.view.right);
    }];
    
    [_floadView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(self.view.right).offset(-5);
        make.size.equalTo(FloatSize);
    }];
}

- (void)showCategoryView
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    
//    CATransition *transitionB = [CATransition animation];
//    transitionB.duration = 0.4;
//    transitionB.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transitionB.type = kCATransitionFade;
//    transitionB.subtype = kCATransitionFromLeft;
//    transitionB.delegate = self;
//    
//    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
//    group.animations = [NSArray arrayWithObjects:transition, transitionB, nil];
//    group.duration = 0.4;
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    BCategoryListViewController *cateVC = [[BCategoryListViewController alloc] init];
    
    [self.navigationController pushViewController:cateVC animated:NO];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

- (void)presentCreateItemViewWithImages:(NSArray *)aimages
{
    if (_createItemVC == nil) {
        _createItemVC = [[BCreateItemViewController alloc] init];
    }
    _createItemVC.delegate =self;
    _createItemVC.imageArray = aimages;
    _createItemVC.view.tag = TAG_CREATE_VC;
    [self.navigationController.view addSubview:_createItemVC.view];
//    [self.navigationController addChildViewController:_createItemVC];
    _createItemVC.view.alpha = 0.5;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         _createItemVC.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismissCreateItemView:(BOOL)needRelease
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         _createItemVC.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [_createItemVC.view removeFromSuperview];
                         [_createItemVC removeFromParentViewController];
                         _createItemVC = nil;
                     }];
}

- (void)setCreateItemViewAlpha:(CGFloat)aLpha
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         _createItemVC.view.alpha = aLpha;
                     }
                     completion:^(BOOL finished) {

                     }];
}

#pragma mark - create view

- (void)createSideFooterView
{
    _tableFooter = [[UIView alloc] initWithFrame:CGRectZero];
    _tableFooter.backgroundColor = [UIColor navBgColor];

    UIView *HLineView = [[UIView alloc] initWithFrame:CGRectZero];
    HLineView.backgroundColor = [UIColor separatorColor];
    
    UIButton *footerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    footerButton.backgroundColor = [UIColor clearColor];
    footerButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [footerButton setTitle:@"新建分类" forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(showCategoryView)
            forControlEvents:UIControlEventTouchUpInside];
    [footerButton setTitleColor:[UIColor colorWithHexString:@"#9a9a9a"]
                        forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor selectedTextColor]
                        forState:UIControlStateHighlighted];
    [footerButton setBackgroundImage:[BirdUtil imageWithColor:[UIColor viewBgColor]]
                             forState:UIControlStateHighlighted];
    
    [self.view addSubview:_tableFooter];
    [_tableFooter addSubview:footerButton];
    [_tableFooter addSubview:HLineView];
    
    [HLineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    [footerButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HLineView.bottom);
        make.bottom.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
}

- (UIView *)createTableHeaderView
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SideWidth, SideCellHeight)];
    footer.backgroundColor = [UIColor clearColor];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _headerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _headerButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [_headerButton setTitle:@"全部" forState:UIControlStateNormal];
    [_headerButton addTarget:self action:@selector(handleShowAllButtonAction)
            forControlEvents:UIControlEventTouchUpInside];
    [_headerButton setTitleColor:[UIColor normalTextColor]
                        forState:UIControlStateNormal];
    [_headerButton setTitleColor:[UIColor selectedTextColor]
                        forState:UIControlStateHighlighted];
    [_headerButton setTitleColor:[UIColor selectedTextColor]
                        forState:UIControlStateSelected];
    [_headerButton setBackgroundImage:[BirdUtil imageWithColor:[UIColor viewBgColor]]
                             forState:UIControlStateHighlighted];
    [_headerButton setBackgroundImage:[BirdUtil imageWithColor:[UIColor viewBgColor]]
                             forState:UIControlStateSelected];
    
    topLine.backgroundColor = [UIColor separatorColor];
    bottomLine.backgroundColor = [UIColor separatorColor];
    _headerButton.backgroundColor = [UIColor whiteColor];
    
    [footer addSubview:topLine];
    [footer addSubview:bottomLine];
    [footer addSubview:_headerButton];
    
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    [_headerButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.bottom);
        make.bottom.equalTo(bottomLine.top);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
    
    return footer;
    
}

- (void)createSideTableView
{
    _categoryTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
    _categoryTableView.delegate = self;
    _categoryTableView.dataSource = self;
    _categoryTableView.backgroundColor = [UIColor whiteColor];
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    _categoryTableView.tableFooterView = footView;
    _categoryTableView.separatorColor = [UIColor separatorColor];
    _categoryTableView.showsHorizontalScrollIndicator = NO;
    _categoryTableView.showsVerticalScrollIndicator = NO;
    
    if ([_categoryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_categoryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_categoryTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_categoryTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [_categoryTableView addGestureRecognizer:longPress];
    
    _categoryTableView.tableHeaderView = [self createTableHeaderView];
    
    [self.view addSubview:_categoryTableView];
    [self createSideFooterView];
}

- (void)createContentView
{
    _contentView = [[BWaterfallView alloc] initWithFrame:CGRectZero];
    _contentView.waterfallDelegate = self;
    _contentView.backgroundColor = [UIColor viewBgColor];
    [self.view addSubview:_contentView];
}

- (void)createFloatView
{
    _floadView = [[BHomeFloadView alloc] initWithFrame:CGRectZero];
    _floadView.alpha = 0.0;
    [self.view addSubview:_floadView];
    [self.view bringSubviewToFront:_floadView];
    
    [_floadView.photoButton addTarget:self action:@selector(handlePhotoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_floadView.cameraButton addTarget:self action:@selector(handleCameraButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createGestureSwipe
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}

- (UITableViewCell *)createCategoryTableCellWithId:(NSString *)aCellId
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:aCellId];
    UIView *selectedBgView =[[UIView alloc] init];
    selectedBgView.backgroundColor = _contentView.backgroundColor;
    cell.selectedBackgroundView = selectedBgView;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.tag = TAG_LABEL;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor normalTextColor];
    textLabel.highlightedTextColor = [UIColor selectedTextColor];
    
    [cell.contentView addSubview:textLabel];
    [textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //加号
//    UIImageView *addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_add_category"]];
//    addImage.tag = TAG_ADD;
//    addImage.userInteractionEnabled = YES;
//    [cell.contentView addSubview:addImage];
//    [addImage makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(cell.contentView);
//        make.centerY.equalTo(cell.contentView);
//        make.width.equalTo(22);
//        make.height.equalTo(22);
//    }];

    return cell;
}

#pragma mark - data

- (void)refreshCatagoryData
{
    if (_categoryData == nil) {
        _categoryData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_categoryData removeAllObjects];
    
    NSArray *temp = [[BModelInterface shareInstance] getCategoryList];
    if (temp) {
        [_categoryData addObjectsFromArray:temp];
    }
    [_categoryTableView reloadData];
}

#pragma mark - set

- (void)setShowSideView:(BOOL)asShowSideView
{
    _showSideView = asShowSideView;
    [self layoutSubViews];
    [self createLeftNavigationBarItem];
    [UIView animateWithDuration:animationDur3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)setShowFloatView:(BOOL)showFloatView
{
    _showFloatView = showFloatView;
    CGFloat alpha = 0.0;
    if (_showFloatView) {
        alpha = 1.0;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _floadView.alpha = alpha;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)setSelectedCategoryId:(NSString *)aSelectedCategoryId
{
    BOOL hasSelected = NO;
    _selectedCategoryId= aSelectedCategoryId;
    
    for (BCategoryContent *category in _categoryData) {
        if ([category.categoryId isEqualToString:_selectedCategoryId]) {
            hasSelected = YES;
            break;
        }
    }
    if (!hasSelected) {
        _selectedCategoryId = nil;
        _headerButton.selected = YES;
        
        NSIndexPath *selected = [_categoryTableView indexPathForSelectedRow];
        if(selected) {
            [_categoryTableView deselectRowAtIndexPath:selected animated:NO];
        }
    } else {
        _headerButton.selected = NO;
    }
    
    [self configLeftNavButtonTextColor];
    
    _itemsData = [[BModelInterface shareInstance] getItemsWithCategoryId:_selectedCategoryId];
    _contentView.itemArray = _itemsData;
}

#pragma mark - sort action

- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:_categoryTableView];
    NSIndexPath *indexPath = [_categoryTableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [_categoryTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [BirdUtil customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_categoryTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath &&
                ![indexPath isEqual:sourceIndexPath] &&
                indexPath.row < [_categoryData count]-1 &&
                sourceIndexPath.row != [_categoryData count]-1) {
                
                // ... update data source.
                [_categoryData exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [_categoryTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
                _orderChanged = YES;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [_categoryTableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [_categoryTableView reloadData];

            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            //列表有变动则保存
            if (_orderChanged) {
                [[BModelInterface shareInstance] updateCategoryList:_categoryData];
                _orderChanged = NO;
            }
            break;
        }
    }
}

#pragma mark - action

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)aGesture
{
    self.showFloatView = NO;
    
    if (aGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.showSideView = NO;
    } else if (aGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_showSideView) {
            [self showCategoryView];
        } else {
            self.showSideView = YES;
        }
    }
}

- (void)handleShowAllButtonAction
{
    self.showFloatView = NO;
    _headerButton.selected = YES;
    self.selectedCategoryId = nil;
}

- (void)handleShowSideViewAction
{
    self.showFloatView = NO;
    self.showSideView = YES;
}

- (void)handleAddButtonAction
{
    self.showFloatView = !self.showFloatView;
}

- (void)handleSearchAction
{
    self.showFloatView = NO;
    BSearchItemViewController *searchVC = [[BSearchItemViewController alloc] init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)handlePhotoButtonAction
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = MAX_ItemImageCount;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    self.showFloatView = NO;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)handleCameraButtonAction
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        //取景框全屏
        CGSize screenBounds = [UIScreen mainScreen].bounds.size;
        CGFloat cameraAspectRatio = 4.0f/3.0f;
        CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
        CGFloat scale = screenBounds.height / camViewHeight;
        imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        imagePickerController.cameraViewTransform = CGAffineTransformScale(imagePickerController.cameraViewTransform, scale, scale);
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"设备不支持拍照");
    }
    
    self.showFloatView = NO;
}

#pragma mark - BWaterfallViewDelagate

- (void)BWaterfallView:(BWaterfallView *)aWaterfall didSelectedItemAtIndex:(NSInteger)aIndex
{
    self.showFloatView = NO;
    
    if (aIndex < [_itemsData count]) {
        BItemContent *content = [_itemsData objectAtIndex:aIndex];
        BItemDetailViewController *detailVC = [[BItemDetailViewController alloc] init];
        detailVC.itemContent = content;
        detailVC.categoryName = content.name;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - BCreateItemViewDelegate

- (void)BCreateItemViewController:(BCreateItemViewController *)aVC didCreateItem:(BItemContent *)aItem
{
    [self dismissCreateItemView:YES];
    
    [[BModelInterface shareInstance] handleItemWithAction:ModelAction_create
                                                  andData:aItem];
    _selectedCategoryId = aItem.categoryId;
    BItemDetailViewController *detailVC = [[BItemDetailViewController alloc] init];
    detailVC.itemContent = aItem;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)BCreateItemViewController:(BCreateItemViewController *)aVC didAddCategory:(BItemContent *)aItem
{
    BCategoryContent *content = [[BCategoryContent alloc] init];
    content.categoryId = [BirdUtil createCategoryID];
    _selectedCategoryId = content.categoryId;
    
    BCreateCategoryViewController *createVC = [[BCreateCategoryViewController alloc] init];
    createVC.isCreate = YES;
    createVC.category = content;
    createVC.item = aItem;
    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //info中key值
//    NSString *const  UIImagePickerControllerMediaType ;指定用户选择的媒体类型（文章最后进行扩展）
//    NSString *const  UIImagePickerControllerOriginalImage ;原始图片
//    NSString *const  UIImagePickerControllerEditedImage ;修改后的图片
//    NSString *const  UIImagePickerControllerCropRect ;裁剪尺寸
//    NSString *const  UIImagePickerControllerMediaURL ;媒体的URL
//    NSString *const  UIImagePickerControllerReferenceURL ;原件的URL
//    NSString *const  UIImagePickerControllerMediaMetadata;当来数据来源是照相机的时候这个值才有效

    UIImage *pickImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    pickImage = [BirdUtil fixOrientation:pickImage needCompress:YES];
//    pickImage = [BirdUtil compressImageByMainScreen:pickImage];
    NSLog(@"%@", pickImage);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self presentCreateItemViewWithImages:@[pickImage]];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [imageArray addObject:tempImg];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentCreateItemViewWithImages:imageArray];
        });
    });
}

-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSLog(@"到达上限");
    [BirdUtil showAlertViewWithMsg:@"图片数量已达上限"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SideCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中分类
    BCategoryContent *content = [_categoryData objectAtIndex:indexPath.row];
    
    self.selectedCategoryId = content.categoryId;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categoryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [self createCategoryTableCellWithId:cellId];
    }
    
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:TAG_LABEL];
    textLabel.hidden = NO;
    textLabel.text = nil;
    if (indexPath.row < [_categoryData count]) {
        BCategoryContent *category = [_categoryData objectAtIndex:indexPath.row];
        textLabel.text = [category.descr length]? category.descr:category.name;
        
        //选中刷新
        if ([category.categoryId isEqualToString:_selectedCategoryId]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    return cell;
}

@end
