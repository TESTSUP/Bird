//
//  BSearchItemViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/7/5.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BSearchItemViewController.h"
#import "BWaterfallView.h"

@interface BSearchItemViewController () <UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    BWaterfallView *_contentView;
}
@end

@implementation BSearchItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithRed:231.0/255.0
                                                green:231.0/255.0
                                                 blue:231.0/255.0
                                                alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createSearchBar];
    
    [self createContentView];
    
    [self layoutSubViews];
}

- (void)createSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.barTintColor = self.view.backgroundColor;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"名字/描述/标签";
    _searchBar.showsCancelButton = YES;
    
    [self.view addSubview:_searchBar];
}

- (void)createContentView
{
    _contentView = [[BWaterfallView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor colorWithRed:231.0/255.0
                                                   green:231.0/255.0
                                                    blue:231.0/255.0
                                                   alpha:1.0];
    [self.view addSubview:_contentView];
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
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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
