//
//  SelectCatrgoryViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/6/27.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BSelectCatrgoryViewController.h"
#import "BCreateCategoryViewController.h"

@interface BSelectCatrgoryViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_categoryTable;
    NSArray *_categoryArray;
}
@end

@implementation BSelectCatrgoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:231.0/255.0
                                                green:231.0/255.0
                                                 blue:231.0/255.0
                                                alpha:1.0];
    _categoryArray = [BGlobalConfig shareInstance].categoryList;
    
    [self configNavigationBar];
    
    [self createSubView];
    
    [self layoutSubViews];
}

- (void)configNavigationBar
{
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn addTarget:self action:@selector(handleBackbuttonAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
}

- (void)createSubView
{
    _categoryTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _categoryTable.delegate = self;
    _categoryTable.dataSource = self;
    _categoryTable.showsVerticalScrollIndicator = NO;
    _categoryTable.showsHorizontalScrollIndicator = NO;
    _categoryTable.backgroundColor = [UIColor clearColor];
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
    
    [self.view addSubview:_categoryTable];
}

- (void)layoutSubViews
{
    [_categoryTable makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)handleBackbuttonAction
{
    [self .navigationController popViewControllerAnimated:YES];
}

- (NSString *)title
{
    return self.isGuide? @"创建一个分类":@"选择";
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
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [_categoryArray objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BCategoryContent *content = [[BCategoryContent alloc] init];
    content.name = name;
    
    BCreateCategoryViewController *createVC = [[BCreateCategoryViewController alloc] init];
    createVC.isCreate = YES;
    createVC.category = content;
    createVC.item = self.item;
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
    }
    
    NSString *name = [_categoryArray objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    
    return cell;
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
