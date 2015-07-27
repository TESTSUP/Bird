//
//  Category ViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/6/18.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BCategoryListViewController.h"
#import "BSettingViewController.h"
#import "BCreateCategoryViewController.h"
#import "BModelInterface.h"
#import "BirdUtil.h"

@interface BCategoryListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_categoryTable;
    UIButton *_settingBtn;
    
    NSMutableArray *_categoryArray;
    BOOL _orderChanged;
}
@end

@implementation BCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getCategoryData];
    
    [self configNavBar];
    
    [self createSubView];
    
    [self layoutSubViews];
}

- (void)getCategoryData
{
    if (_categoryArray == nil) {
        _categoryArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_categoryArray removeAllObjects];
    NSArray *data = [[BModelInterface shareInstance] getCategoryList];
    
    if ([data count]) {
        [_categoryArray addObjectsFromArray:data];
    }
}

- (void)createFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"长按可排序";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#9a9a9a"];
    label.textAlignment = NSTextAlignmentRight;
    
    UIView *HLineView = [[UIView alloc] initWithFrame:CGRectZero];
    HLineView.backgroundColor = [UIColor separatorColor];
    [footView addSubview:HLineView];
    [footView addSubview:label];
    
    [HLineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HLineView.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0).offset(-20);
        make.bottom.equalTo(footView.bottom);
    }];
    
    _categoryTable.tableFooterView = footView;
}

- (void)createSubView
{
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [_settingBtn addTarget:self action:@selector(handleSettingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    _categoryTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _categoryTable.delegate = self;
    _categoryTable.dataSource = self;
    _categoryTable.showsVerticalScrollIndicator = NO;
    _categoryTable.showsHorizontalScrollIndicator = NO;
    _categoryTable.separatorColor = [UIColor colorWithRed:204.0/255.0
                                                    green:204.0/255.0
                                                     blue:204.0/255.0
                                                    alpha:1.0];
    
    [self createFooterView];
    
    if ([_categoryTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_categoryTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_categoryTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_categoryTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [_categoryTable addGestureRecognizer:longPress];
    
    [self.view addSubview:_settingBtn];
    [self.view addSubview:_categoryTable];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackAction)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:swipeRight];
}

- (void)configNavBar
{
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn.frame = CGRectMake(0, 0, 44, 44);
    [categoryBtn addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:categoryBtn];
    // 调整 leftBarButtonItem 在 iOS7 下面的位置
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    categoryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, leftBarItem] animated:YES];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 75, 44);
    [addBtn addTarget:self action:@selector(handleAddCategoryAction) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"新建分类" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor normalTextColor] forState:UIControlStateNormal];
//    [addBtn setImage:[UIImage imageNamed:@"nav_add_category"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)layoutSubViews
{
    [_settingBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(0);
        make.width.equalTo(44);
        make.height.equalTo(44);
    }];
    
    [_categoryTable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(_settingBtn.top);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getCategoryData];
    [_categoryTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title
{
    return nil;
}

#pragma mark - action

- (void)handleBackAction
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleAddCategoryAction
{
    BCategoryContent *content = [[BCategoryContent alloc] init];
    content.categoryId = [BirdUtil createCategoryID];
    
    BCreateCategoryViewController *createVC = [[BCreateCategoryViewController alloc] init];
    createVC.isCreate = YES;
    createVC.category = content;
    createVC.item = nil;
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)handleSettingButtonAction
{
    BSettingViewController *settingVC = [[BSettingViewController alloc] init];

    [self presentViewController:settingVC animated:YES completion:nil];
}

- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:_categoryTable];
    NSIndexPath *indexPath = [_categoryTable indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [_categoryTable cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [BirdUtil customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_categoryTable addSubview:snapshot];
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
                indexPath.row < [_categoryArray count]-1 &&
                sourceIndexPath.row != [_categoryArray count]-1) {
                
                // ... update data source.
                [_categoryArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [_categoryTable moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
                _orderChanged = YES;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [_categoryTable cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [_categoryTable reloadData];
            
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
                [[BModelInterface shareInstance] updateCategoryList:_categoryArray];
                _orderChanged = NO;
            }
            break;
        }
    }
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
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [_categoryArray count]-1) {
        return;
    }
    
    BCategoryContent *content = [_categoryArray objectAtIndex:indexPath.row];
    BCreateCategoryViewController *createVC = [[BCreateCategoryViewController alloc] init];
    createVC.isCreate = NO;
    createVC.category = content;
    [self.navigationController pushViewController:createVC animated:YES];;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
        UIImageView *editView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        editView.image = [UIImage imageNamed:@"category_edit"];
        cell.accessoryView = editView;
    }
    
    BCategoryContent *content = [_categoryArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [content.descr length]? content.descr:content.name;
    if (indexPath.row == [_categoryArray count]-1) {
        cell.accessoryView.hidden = YES;
    } else {
        cell.accessoryView.hidden = NO;
    }
    
    return cell;
}

@end
