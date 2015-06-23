//
//  Category ViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/6/18.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "CategoryListViewController.h"
#import "SettingViewController.h"

@interface CategoryListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_categoryTable;
    UIButton *_backBtn;
    UIButton *_settingBtn;
}
@end

@implementation CategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];

    [self configNavBar];
    
    [self createSubView];
    
    [self layoutSubViews];
}

- (void)createSubView
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popCategoryView) forControlEvents:UIControlEventTouchUpInside];
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_settingBtn addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
    
    _categoryTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _categoryTable.delegate = self;
    _categoryTable.dataSource = self;
    _categoryTable.showsVerticalScrollIndicator = NO;
    _categoryTable.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_backBtn];
    [self.view addSubview:_settingBtn];
    [self.view addSubview:_categoryTable];
    
     _backBtn.backgroundColor = [UIColor blueColor];
    _backBtn.backgroundColor = [UIColor yellowColor];
}

- (void)configNavBar
{
    self.navigationItem.hidesBackButton = YES;
}

- (void)popCategoryView
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

- (void)showSettingView
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    
    [self presentViewController:settingVC animated:YES completion:nil];
}

- (void)layoutSubViews
{
    [_backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.bottom.equalTo(0);
        make.width.equalTo(50);
        make.height.equalTo(50);
    }];
    
    [_settingBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(0);
        make.width.equalTo(50);
        make.height.equalTo(50);
    }];
    
    [_categoryTable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(_backBtn.top);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title
{
    return @"分类";
}


#pragma mark - UITableViewDelegate

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
