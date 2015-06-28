//
//  Category ViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/6/18.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "CategoryListViewController.h"
#import "SettingViewController.h"
#import "CreateCategoryViewController.h"
#import "SelectCatrgoryViewController.h"

@interface CategoryListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_categoryTable;
    UIButton *_settingBtn;
    
    
}
@end

@implementation CategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavBar];
    
    [self createSubView];
    
    [self layoutSubViews];
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
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    _categoryTable.tableFooterView = footView;
    if ([_categoryTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_categoryTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_categoryTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_categoryTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_settingBtn];
    [self.view addSubview:_categoryTable];
}

- (void)configNavBar
{
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn.frame = CGRectMake(0, 0, 40, 40);
    [categoryBtn addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn setImage:[UIImage imageNamed:@"NavigationBar_category"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:categoryBtn];
    // 调整 leftBarButtonItem 在 iOS7 下面的位置
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    categoryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, leftBarItem] animated:YES];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 40, 40);
    [addBtn addTarget:self action:@selector(handleAddCategoryAction) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"nav_add_category"] forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title
{
    return @"长按可排序";
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
    CreateCategoryViewController *createVC = [[CreateCategoryViewController alloc] init];
    createVC.isCreate = YES;
    
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)handleSettingButtonAction
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];

    [self presentViewController:settingVC animated:YES completion:nil];
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
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    
    return cell;
}

@end
