//
//  CreateCategoryViewController.m
//  Bird
//
//  Created by 孙永刚 on 15-6-23.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BCreateCategoryViewController.h"
#import "UIViewController+Bird.h"
#import "BModelInterface.h"
#import "BirdUtil.h"

static const CGFloat left_offset = 20;
static const CGFloat top_offset = 20;
static const CGFloat itemSpace15 = 15;
static NSString *const placeHolder = @"备注名称";

@interface BCreateCategoryViewController () <UITextViewDelegate, UITextFieldDelegate>
{
    UIView *_contentView;
    UILabel *_catigoryName;
    UITextView *_categoryDescription;
    
    UIButton *_deleteButton;
}
@end

@implementation BCreateCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:231.0/255.0
                                                green:231.0/255.0
                                                 blue:231.0/255.0
                                                alpha:1.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDisappearKeybord)];
    [self.view addGestureRecognizer:tap];
    
    [self configNavigationBar];
    
    [self createSuViews];
    
    [self layoutSubviews];
}

- (void)configNavigationBar
{
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn addTarget:self action:@selector(handleBackbuttonAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame =  CGRectMake(0, 0, 44, 44);
    [confirmBtn addTarget:self action:@selector(handleConfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setImage:[UIImage imageNamed:@"nav_confirm"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    self.navigationItem.rightBarButtonItem = rightItme;
}

- (void)configContentView
{
    _catigoryName = [[UILabel alloc] initWithFrame:CGRectZero];
    _catigoryName.textColor = [UIColor blackColor];
    _catigoryName.font = [UIFont systemFontOfSize:17];
    _catigoryName.backgroundColor = [UIColor greenColor];
    _catigoryName.text = self.category.name;
    
    _categoryDescription = [[UITextView alloc] initWithFrame:CGRectZero];
    _categoryDescription.showsHorizontalScrollIndicator = NO;
    _categoryDescription.showsVerticalScrollIndicator = NO;
    _categoryDescription.scrollEnabled = NO;
    _categoryDescription.delegate = self;
    _categoryDescription.text =  self.category.descr? self.category.descr:placeHolder;
    _categoryDescription.textColor = [UIColor lightGrayColor];
    _categoryDescription.font = [UIFont systemFontOfSize:14];
    _categoryDescription.backgroundColor = [UIColor redColor];
    _categoryDescription.textAlignment = NSTextAlignmentLeft;
    _categoryDescription.returnKeyType = UIReturnKeyDone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_contentView addSubview:_catigoryName];
    [_contentView addSubview:_categoryDescription];
}

- (void)createSuViews
{
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 4.0;
    [self.view addSubview:_contentView];
    [self configContentView];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(handleDeleteAction) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setTitleColor:[UIColor colorWithRed:167.0/255.0
                                                 green:167.0/255.0
                                                  blue:167.0/255.0
                                                 alpha:1.0]
                        forState:UIControlStateNormal];
    _deleteButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_deleteButton];
    
    if (_isCreate) {
        _deleteButton.hidden = YES;
    }
}

- (void)layoutSubviews
{
    CGSize constraintSize = CGSizeMake(self.view.frame.size.width-2*left_offset, MAXFLOAT);
    CGSize size = [_categoryDescription sizeThatFits:constraintSize];
    CGFloat descriptionH = size.height;
    CGFloat titleHeight = 20;
    
    [_catigoryName remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(left_offset);
        make.right.equalTo(-left_offset);
        make.top.equalTo(top_offset);
        make.height.equalTo(titleHeight);
    }];
    
    [_categoryDescription remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_catigoryName.bottom).offset(itemSpace15);
        make.left.equalTo(left_offset);
        make.right.equalTo(-left_offset);
        make.height.equalTo(descriptionH);
    }];
    
    [_contentView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(22);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.right).offset(-5);
        make.height.equalTo(2*top_offset +titleHeight + itemSpace15 + descriptionH);
    }];
    
    [_deleteButton remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(left_offset);
        make.right.equalTo(-left_offset);
        make.top.equalTo(_contentView.bottom).offset(33);
        make.height.equalTo(44);
    }];
}

- (NSString *)title
{
    return _isCreate? @"创建":@"修改备注名";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)handleBackbuttonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleConfirmButtonAction
{
    if (_isCreate) {
        self.category.createTime = [[NSDate date] timeIntervalSince1970];
        self.category.updateTime = self.category.createTime;
        [[BModelInterface shareInstance] handleCategoryWithAction:ModelAction_create andData:self.category];
    } else {
        self.category.updateTime = [[NSDate date] timeIntervalSince1970];
        [[BModelInterface shareInstance] handleCategoryWithAction:ModelAction_update andData:self.category];
    }
    [self popToViewControllerNamed:@"BCategoryListViewController"];
}

- (void)handleDeleteAction
{
    [[BModelInterface shareInstance] handleCategoryWithAction:ModelAction_delete andData:self.category];
    
    [self popToViewControllerNamed:@"BCategoryListViewController"];
}

- (void)handleDisappearKeybord
{
    [_categoryDescription resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqual:placeHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        textView.text = placeHolder;
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self layoutSubviews];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
