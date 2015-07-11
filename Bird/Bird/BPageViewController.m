//
//  BPageViewController.m
//  Bird
//
//  Created by 孙永刚 on 15/7/8.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BPageViewController.h"
#import "BimageViewController.h"

@interface BPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    UILabel *_pageLabel;
    UIButton *_setBtn;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *pageContent;

@end

@implementation BPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self createPageController];
    
    [self createButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createButtons
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.backgroundColor = [UIColor clearColor];
    [_setBtn setTitle:@"设为封面" forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_setBtn addTarget:self action:@selector(handleSetAction) forControlEvents:UIControlEventTouchUpInside];
    if (_currentIndex == 0) {
        _setBtn.hidden =YES;
    } else {
        _setBtn.hidden = NO;
    }
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(handleDeleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, [self.pageContent count]];
    
    [self.view addSubview:backBtn];
    [self.view addSubview:_setBtn];
    [self.view addSubview:deleteBtn];
    [self.view addSubview:_pageLabel];
    
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(0);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    [_setBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.bottom.equalTo(0);
        make.size.equalTo(CGSizeMake(80, 44));
    }];
    
    [deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.size.equalTo(CGSizeMake(60, 44));
    }];
    
    [_pageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(0);
        make.size.equalTo(CGSizeMake(60, 44));
    }];
    
    if (!_showToolbar) {
        _setBtn.hidden = YES;
        deleteBtn.hidden = YES;
    }
}

- (void)createPageController
{
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options: options];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    _pageController.delegate = self;
    BimageViewController *initialViewController =[self viewControllerAtIndex:_currentIndex];// 得到第一页
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    
    // 定义“这本书”的尺寸
    [[_pageController view] setFrame:[[self view] bounds]];
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
    [self.view sendSubviewToBack:_pageController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreaviewControllerAtIndexed.
}

#pragma mark - action

- (void)handleBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSetAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BPageViewController:didSetCoverAtIndex:)])
    {
        [self.delegate BPageViewController:self didSetCoverAtIndex:self.currentIndex];
    }
    
    [self.pageContent exchangeObjectAtIndex:0 withObjectAtIndex:self.currentIndex];
    self.currentIndex = 0;
}

- (void)handleDeleteAction
{
    if ([self.pageContent count] <=1) {
        NSLog(@"can not dlete");
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BPageViewController:didDeleteImageAtIndex:)])
    {
        [self.delegate BPageViewController:self didDeleteImageAtIndex:self.currentIndex];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.pageContent];
    [tempArray removeObjectAtIndex:self.currentIndex];
    _pageContent = tempArray;
    
    if (self.currentIndex >0) {
        self.currentIndex = self.currentIndex-1;
    } else {
        self.currentIndex = self.currentIndex+1;
    }
    

}

#pragma mark - data

// 得到相应的VC对象
- (BimageViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return nil;
    }
 
    id data = [self contentAtIndex:index];
    BimageViewController *dataViewController =[[BimageViewController alloc] init];
    dataViewController.imageData = data;

    return dataViewController;
}

// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(BimageViewController *)viewController {
    return [self.pageContent indexOfObject:viewController.imageData];
}

- (id)contentAtIndex:(NSUInteger) index
{
    if (self.pageContent)
    {
        return [self.pageContent objectAtIndex:index];
    }
    
    return nil;
}

#pragma mark - set

- (void)setCurrentIndex:(NSInteger)aCurrentIndex
{
    if (aCurrentIndex >= [self.pageContent count]) {
        return;
    }
    _currentIndex = aCurrentIndex;
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, [self.pageContent count]];
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    if (_pageController) {
        BimageViewController *initialViewController =[self viewControllerAtIndex:_currentIndex];// 得到第一页
        NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
        [_pageController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    }
    
    if (_currentIndex == 0) {
        _setBtn.hidden =YES;
    } else {
        _setBtn.hidden = NO;
    }
}

- (void)setImageDatas:(NSArray *)imageDatas
{
    self.pageContent = nil;
    if ([imageDatas count]) {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
        [temp addObjectsFromArray:imageDatas];
        self.pageContent = temp;
    }
}

- (void)setImageIds:(NSArray *)imageIds
{
    self.pageContent = nil;
    if ([imageIds count]) {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
        [temp addObjectsFromArray:imageIds];
        self.pageContent = temp;
    }
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        _currentIndex = [self indexOfViewController:(BimageViewController *)[self.pageController.viewControllers objectAtIndex:0]];
        
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, [self.pageContent count]];
        
        if (_showToolbar) {
            if (_currentIndex == 0) {
                _setBtn.hidden =YES;
            } else {
                _setBtn.hidden = NO;
            }
        }
    }
}

#pragma mark- UIPageViewControllerDataSource

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:(BimageViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:(BimageViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


@end
