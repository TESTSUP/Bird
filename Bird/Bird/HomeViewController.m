//
//  ViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/6/16.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryListViewController.h"
#import "BHomeFloadView.h"
#import "ZYQAssetPickerController.h"
#import "SelectCatrgoryViewController.h"

static const CGFloat SideWidth = 75;
static const CGFloat SideCellHeight = 50;
static const NSTimeInterval animationDur3 = 0.3;

@interface HomeViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ZYQAssetPickerControllerDelegate>
{
    UITableView *_categoryTableView;
    UIView *_tableFooter;
    UIView *_contentView;
    BHomeFloadView *_floadView;
    
    NSMutableArray *_categoryData;
}

@property (nonatomic, assign) BOOL showSideView;
@property (nonatomic, assign) BOOL showFloatView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _showSideView = YES;
    _showFloatView = NO;
    
    [self getCateGoryData];
    
    [self configNavigationBar];
    
    [self createSideTableView];

    [self createContentView];
    
    [self createFloatView];
    
    [self createGestureSwipe];
    
    [self layoutSubViews];
}

- (void)configLeftNavButtonTextColor
{
    NSArray *items = self.navigationItem.leftBarButtonItems;
    UIBarButtonItem *leftItem = [items lastObject];
    UIButton *leftBtn = (UIButton *)leftItem.customView;
    
    if ([leftBtn isKindOfClass:[UIButton class]]) {
        NSIndexPath *selected = [_categoryTableView indexPathForSelectedRow];
        if(selected) {
            [leftBtn setTitleColor:[UIColor colorWithRed:189.0/255.0
                                                   green:8.0/255.0
                                                    blue:28.0/255.0
                                                   alpha:1.0]
                          forState:UIControlStateNormal];
            
        } else {
            [leftBtn setTitleColor:[UIColor colorWithRed:68.0/255.0
                                                   green:68.0/255.0
                                                    blue:68.0/255.0
                                                   alpha:1.0]
                          forState:UIControlStateNormal];
        }
    }
}

- (void)createLeftNavigationBarItem
{
    UIButton *customView = nil;
    if (self.showSideView) {
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        homeBtn.frame = CGRectMake(0, 0, 65, 40);
        [homeBtn addTarget:self action:@selector(handleHomeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [homeBtn setTitle:@"星鸟" forState:UIControlStateNormal];
        [homeBtn setImage:[UIImage imageNamed:@"NavigationBar_home"] forState:UIControlStateNormal];
        customView = homeBtn;
    } else {
        UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.frame = CGRectMake(0, 0, 40, 40);
        [categoryBtn addTarget:self action:@selector(handleShowSideViewAction) forControlEvents:UIControlEventTouchUpInside];
        [categoryBtn setImage:[UIImage imageNamed:@"NavigationBar_category"] forState:UIControlStateNormal];
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
        make.height.equalTo(20);
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

- (void)createSideFooterView
{
    _tableFooter = [[UIView alloc] initWithFrame:CGRectZero];
    _tableFooter.backgroundColor = [UIColor colorWithRed:247.0/255.0
                                                   green:247.0/255.0
                                                    blue:247.0/255.0
                                                   alpha:1.0];
    UIImageView *left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_sideFooter_left"]];
    UIImageView *right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_sideFooter_right"]];
    
    [self.view addSubview:_tableFooter];
    [_tableFooter addSubview:left];
    [_tableFooter addSubview:right];
    
    [left makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.bottom.equalTo(0);
//        make.width.equalTo(SideWidth/2.0);
        make.width.equalTo(34);
    }];
    
    [right makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
//        make.width.equalTo(SideWidth/2.0);
         make.width.equalTo(34);
    }];
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
    _categoryTableView.separatorColor = [UIColor colorWithRed:204.0/255.0
                                                        green:204.0/255.0
                                                         blue:204.0/255.0
                                                        alpha:1.0];
    [self.view addSubview:_categoryTableView];

    if ([_categoryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_categoryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_categoryTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_categoryTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    [self createSideFooterView];
    
}

- (void)createContentView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor colorWithRed:231.0/255.0
                                                   green:231.0/255.0
                                                    blue:231.0/255.0
                                                   alpha:1.0];
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
    
    CategoryListViewController *cateVC = [[CategoryListViewController alloc] init];
    
    [self.navigationController pushViewController:cateVC animated:NO];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (void)getCateGoryData
{
    if (!_categoryData) {
        _categoryData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [_categoryData addObjectsFromArray:@[@"衬衫", @"裤子", @"外套", @"家电", @"家具"]];
}


#pragma mark - action

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)aGesture
{
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


- (void)handleHomeButtonAction
{
    NSIndexPath *selected = [_categoryTableView indexPathForSelectedRow];
    if(selected)
        [_categoryTableView deselectRowAtIndexPath:selected animated:YES];
    
    [self configLeftNavButtonTextColor];
}

- (void)handleShowSideViewAction
{
    self.showSideView = YES;
}

- (void)handleAddButtonAction
{
    self.showFloatView = !self.showFloatView;
}

- (void)handleSearchAction
{
    
}

- (void)handlePhotoButtonAction
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 5;
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
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image
{
    
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            dispatch_async(dispatch_get_main_queue(), ^{

                
            });
        }
    });
}


-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSLog(@"到达上限");
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [_categoryData count]) {
        return [tableView indexPathForSelectedRow];
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [_categoryData count]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [self configLeftNavButtonTextColor];
        
        //选中分类
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categoryData count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const NSInteger addBtnTag = 9999;
    static NSString *cellId = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
        UIView *selectedBgView =[[UIView alloc] init];
        selectedBgView.backgroundColor = _contentView.backgroundColor;
        cell.selectedBackgroundView = selectedBgView;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
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
    if (indexPath.row < [_categoryData count]) {
        NSString *catStr = [_categoryData objectAtIndex:indexPath.row];
        cell.textLabel.text = catStr;
    } else if (indexPath.row == [_categoryData count]) {
        addBtn.hidden = NO;
    }
    
    return cell;
}

@end
