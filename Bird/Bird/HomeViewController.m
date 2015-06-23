//
//  ViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/6/16.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryListViewController.h"

static const CGFloat SideWidth = 75;
static const NSTimeInterval animationDur3 = 0.3;

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_categoryTableView;
    UIImageView *_tableFooter;
}

@property (nonatomic, assign) BOOL showSideView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createSideTableView];

    [self createGestureSwipe];
}

- (void)configNavigationBar
{

}

- (void)layoutSideView
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
        make.height.equalTo(50);
    }];
}

- (void)createSideTableView
{
    _categoryTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
    _categoryTableView.delegate = self;
    _categoryTableView.dataSource = self;
//    _categoryTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_categoryTableView];

    UIImage *image = [UIImage imageNamed:@"sidle"];
    _tableFooter = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_tableFooter];
    _tableFooter.backgroundColor = [UIColor greenColor];
    
    [self layoutSideView];
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

- (NSString *)title
{
    return @"首页";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShowSideView:(BOOL)asShowSideView
{
    _showSideView = asShowSideView;
    [self layoutSideView];
    
    [UIView animateWithDuration:animationDur3
                     animations:^{
                         [_categoryTableView layoutIfNeeded];
                         [_tableFooter layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

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
