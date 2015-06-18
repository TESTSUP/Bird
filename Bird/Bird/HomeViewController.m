//
//  ViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/6/16.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryViewController.h"

@interface HomeViewController ()
{
    UITableView *_categoryTableView;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (NSString *)title
{
    return @"首页";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
