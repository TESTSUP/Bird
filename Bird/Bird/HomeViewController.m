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
static const CGFloat SideCellHeight = 50;
static const NSTimeInterval animationDur3 = 0.3;

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_categoryTableView;
    UIImageView *_tableFooter;
    UIView *_contentView;
    
    NSMutableArray *_categoryData;
}

@property (nonatomic, assign) BOOL showSideView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getCateGoryData];
    
    [self configNavigationBar];
    
    [self createSideTableView];

    [self createContentView];
    
    [self createGestureSwipe];
    
    [self layoutSubViews];
}

- (void)configNavigationBar
{
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(0, 0, 65, 40);
    [homeBtn setTitle:@"星鸟" forState:UIControlStateNormal];
    [homeBtn setImage:[UIImage imageNamed:@"NavigationBar_home"] forState:UIControlStateNormal];
    [homeBtn setTitleColor:[UIColor colorWithRed:68.0/255.0
                                           green:68.0/255.0
                                            blue:68.0/255.0
                                           alpha:1.0]
                  forState:UIControlStateNormal];
    [homeBtn setTitleColor:[UIColor colorWithRed:189.0/255.0
                                           green:8.0/255.0
                                            blue:28.0/255.0
                                           alpha:1.0]
                  forState:UIControlStateHighlighted];
    
    [homeBtn addTarget:self action:@selector(handleHomeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBarItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];

    UIBarButtonItem *addBarItme = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAddButtonAction)];
    UIBarButtonItem *searchBarItme = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(handleSearchAction)];
    
    self.navigationItem.leftBarButtonItem = homeBarItem;
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
        make.height.equalTo(50);
    }];
    
    [_contentView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_categoryTableView.right).offset(0);
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(self.view.bottom);
        make.right.equalTo(self.view.right);
    }];
}

- (void)createSideTableView
{
    _categoryTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
    _categoryTableView.delegate = self;
    _categoryTableView.dataSource = self;
    _categoryTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_categoryTableView];

    UIImage *image = [UIImage imageNamed:@"sidle"];
    _tableFooter = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_tableFooter];
    _tableFooter.backgroundColor = [UIColor greenColor];
}

- (void)createContentView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor colorWithRed:225.0/255.0
                                                   green:225.0/255.0
                                                    blue:225.0/255.0
                                                   alpha:1.0];
    [self.view addSubview:_contentView];
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
    
    [UIView animateWithDuration:animationDur3
                     animations:^{
                         [self.view layoutIfNeeded];
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
    self.showSideView = !self.showSideView;
}

- (void)handleShowSideViewAction
{
    
}

- (void)handleAddButtonAction
{
    
}

- (void)handleSearchAction
{
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SideCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categoryData count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
        UIView *selectedBgView =[[UIView alloc] init];
        selectedBgView.backgroundColor = _contentView.backgroundColor;
        cell.selectedBackgroundView = selectedBgView;
    }
    
    cell.textLabel.text = nil;
    if (indexPath.row < [_categoryData count]) {
        NSString *catStr = [_categoryData objectAtIndex:indexPath.row];
        cell.textLabel.text = catStr;
    } else if (indexPath.row == [_categoryData count]) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [cell.contentView addSubview:addBtn];
        [addBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.centerY.equalTo(cell.contentView);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
    }
    
    return cell;
}

@end
