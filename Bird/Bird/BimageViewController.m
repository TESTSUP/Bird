//
//  BimageViewController.m
//  Bird
//
//  Created by 孙永刚 on 15-7-8.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BimageViewController.h"

@interface BimageViewController ()
{
    UIScrollView *sv;
    UIImageView *iv;
    UIView *loadingView;
}

@end

@implementation BimageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:sv];
    iv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [sv addSubview:iv];
    
    sv.delegate = self;
    
    [self loadImage:self.image];
}
// 加载图片
- (void)loadImage:(UIImage *)aImage
{
    UIImage *image = aImage;
    // 重置UIImageView的Frame，让图片居中显示
    
    CGFloat origin_x = abs(sv.frame.size.width - image.size.width)/2.0;
    CGFloat origin_y = abs(sv.frame.size.height - image.size.height)/2.0;
    iv.frame = CGRectMake(origin_x, origin_y, sv.frame.size.width, sv.frame.size.width*image.size.height/image.size.width);
    [iv setImage:image];
    
    CGSize maxSize = sv.frame.size;
    CGFloat widthRatio = maxSize.width/image.size.width;
    CGFloat heightRatio = maxSize.height/image.size.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    /*
     
     ** 设置UIScrollView的最大和最小放大级别（注意如果MinimumZoomScale == MaximumZoomScale，
     
     ** 那么UIScrllView就缩放不了了
     
     */
    [sv setMinimumZoomScale:initialZoom];
    [sv setMaximumZoomScale:5];
    // 设置UIScrollView初始化缩放级别
    
    [sv setZoomScale:initialZoom];
}

// 设置UIScrollView中要缩放的视图

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return iv;
    
}
// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    iv.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
