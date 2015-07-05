//
//  BItemDetailViewController.m
//  Bird
//
//  Created by 孙永刚 on 15-7-3.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BItemDetailViewController.h"
#import "UIViewController+Bird.h"

@interface BItemDetailViewController ()
{
    
}
@end

@implementation BItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self configNavigationBar];
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

#pragma mark - action 

- (void)handleBackAction
{
    [self popToViewControllerNamed:@"BHomeViewController"];
}

- (void)handleDeleteAction
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
