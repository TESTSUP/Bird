//
//  BEditItemViewController.m
//  Bird
//
//  Created by 孙永刚 on 15-7-3.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BEditItemViewController.h"
#import "BTagLabelView.h"
#import "BModelInterface.h"

static NSString *const placeHolder = @"输入";
static const CGFloat left_offset = 20;
static const CGFloat top_offset = 20;
static const CGFloat itemSpace10 = 10;
static const CGFloat itemSpace15 = 15;
static const CGFloat defaultHeight = 50;
static const CGFloat LineSpace = 15;

@interface BEditItemViewController () <UITextViewDelegate, BTagLabelViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    UIView *_itemDescView;
    UILabel *_itmeNameLabel;
    BTagLabelView *_itemTagLabel;
    UIView *_lineView;
    UITextView *_inputTextView;
    
    UIView *_bottomView;
    
    NSString *_itemName;
    NSMutableArray *_propertyArray;
    NSMutableArray *_defaultProperty;
}
@end

@implementation BEditItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:231.0/255.0
                                                green:231.0/255.0
                                                 blue:231.0/255.0
                                                alpha:1.0];
    [self configNavigationBar];
    
    [self createSubViews];
    
    [self loadData];
    
    [_inputTextView becomeFirstResponder];
}

- (void)configNavigationBar
{
    self.navigationItem.hidesBackButton = YES;
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame =  CGRectMake(0, 0, 44, 44);
    [confirmBtn addTarget:self action:@selector(handleConfirmAction) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - create

- (void)createSubViews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_scrollView addSubview:_contentView];
    [self.view addSubview:_scrollView];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    [self createItemDescView];
    
    [self createTagListView];
}

- (void)createItemDescView
{
    _itemDescView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _itmeNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _itmeNameLabel.textColor = [UIColor colorWithRed:189.0/255.0
                                               green:8.0/255.0
                                                blue:28.0/255.0
                                               alpha:1.0];
    _itmeNameLabel.font = [UIFont systemFontOfSize:15];
    _itmeNameLabel.text = self.itemContent.name;
    
    _itemTagLabel = [[BTagLabelView alloc] initWithFrame:CGRectZero];
    _itemTagLabel.delegate = self;
    _itemTagLabel.textColor = [UIColor colorWithRed:68.0/255.0
                                              green:68.0/255.0
                                               blue:68.0/255.0
                                              alpha:1.0];
    _itemTagLabel.font = [UIFont systemFontOfSize:15];
    _itemTagLabel.text = self.itemContent.name;
    _itemTagLabel.numberOfLines = 0;
    _itemTagLabel.canTap = NO;
    _itemTagLabel.canShowMenu = YES;
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0
                                                green:204.0/255.0
                                                 blue:204.0/255.0
                                                alpha:1.0];
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _inputTextView.showsHorizontalScrollIndicator = NO;
    _inputTextView.showsVerticalScrollIndicator = NO;
    _inputTextView.scrollEnabled = NO;
    _inputTextView.delegate = self;
    _inputTextView.text =  @"输入";
    _inputTextView.textColor = [UIColor lightGrayColor];
    _inputTextView.font = [UIFont systemFontOfSize:14];
    _inputTextView.textAlignment = NSTextAlignmentLeft;
    _inputTextView.returnKeyType = UIReturnKeyDone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _itemDescView.backgroundColor = [UIColor whiteColor];
    _itmeNameLabel.backgroundColor = [UIColor clearColor];
    _itemTagLabel.backgroundColor = [UIColor clearColor];
    _inputTextView.backgroundColor = [UIColor clearColor];
    
    [_itemDescView addSubview:_itmeNameLabel];
    [_itemDescView addSubview:_itemTagLabel];
    [_itemDescView addSubview:_lineView];
    [_itemDescView addSubview:_inputTextView];
    
    [_contentView addSubview:_itemDescView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction)];
    [_itemDescView addGestureRecognizer:tap];
}

- (UIView *)createTagCellViewWith:(NSArray *)aTagArray
{
    if ([aTagArray count] == 0) {
        return nil;
    }
    
    UIScrollView *tempScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    tempScroll.backgroundColor = [UIColor clearColor];
    tempScroll.showsHorizontalScrollIndicator = NO;
    tempScroll.showsVerticalScrollIndicator = NO;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    
    BTagLabelView *tempLabel = [[BTagLabelView alloc] initWithFrame:CGRectZero];
    tempLabel.textAlignment = NSTextAlignmentLeft;
    tempLabel.delegate = self;
    tempLabel.canTap = YES;
    tempLabel.canShowMenu = NO;
    tempLabel.tagArray = aTagArray;
    tempLabel.font = [UIFont systemFontOfSize:12];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.textColor = [UIColor colorWithRed:154.0/255.0
                                          green:154.0/255.0
                                           blue:154.0/255.0
                                          alpha:1.0];
    
    [contentView addSubview:tempLabel];
    [tempScroll addSubview:contentView];
    
    NSDictionary *attrDic = @{NSFontAttributeName:tempLabel.font};
    CGRect rect = [tempLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, defaultHeight)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attrDic
                                                   context:nil];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tempScroll);
        make.height.equalTo(tempScroll);
        make.right.equalTo(tempLabel.right).offset(top_offset);
    }];
    [tempLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tempScroll);
        make.left.equalTo(left_offset);
        make.height.equalTo(contentView.height).offset(-5);
        make.width.equalTo(rect.size.width);
    }];
    
//    tempScroll.contentSize = CGSizeMake(rect.size.width+left_offset*2, defaultHeight);
    return tempScroll;
}

- (void)createTagListView
{
    if (_defaultProperty == nil) {
        _defaultProperty = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //常用标签
    NSArray *usualArray = [[BModelInterface shareInstance] getUsuallyPropertyWithLimit:10
                                                                          byCateGoryId:self.itemContent.categoryId];
    if ([usualArray count]) {
        [_defaultProperty addObject:usualArray];
    }
    //默认标签
    NSArray *defaultP = [BGlobalConfig shareInstance].propertyList;
    if (defaultP) {
//        [_defaultProperty addObjectsFromArray:defaultP];
    }
    
    if ([_defaultProperty count] == 0) {
        return;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"常用描述";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [_contentView addSubview:titleLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemDescView.bottom).offset(itemSpace15);
        make.left.equalTo(left_offset);
        make.width.equalTo(80);
        make.height.equalTo(20);
    }];
    
    UIView *lastView = nil;
    for (NSArray *propertyArray in _defaultProperty) {
        NSLog(@"property = %@", propertyArray);
        
        UIView *cell = [self createTagCellViewWith:propertyArray];
        if (cell == nil) {
            continue;
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0
                                                   green:204.0/255.0
                                                    blue:204.0/255.0
                                                   alpha:1.0];
        [_contentView addSubview:cell];
        [_contentView addSubview:lineView];
        [cell makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.bottom);
            } else {
                make.top.equalTo(titleLabel.bottom).offset(0);
            }
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(defaultHeight);
        }];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(cell.bottom).offset(-1);
            make.height.equalTo(0.5);
        }];
        lastView = cell;
    }
    
    _bottomView = lastView;
}

#pragma mark - data

- (void)loadData
{
    _itemName = self.itemContent.name;
    if (_propertyArray == nil) {
        _propertyArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if ([self.itemContent.property count]) {
        [_propertyArray addObjectsFromArray:self.itemContent.property];
    }
    
    [self refreshData];
}

- (void)refreshData
{
    _itmeNameLabel.text = _itemName;
    
    _itemTagLabel.tagArray = _propertyArray;
    
    [self layoutSubViews];
}

#pragma mark - layout

- (void)layoutSubViews
{
    [self layoutDescView];
    
    [self layoutTagListView];

    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomView?  _bottomView.bottom:_itemDescView.bottom);
    }];
}

- (void)layoutInputView
{
    //输入框高度
    CGSize constraintSize = CGSizeMake(self.view.frame.size.width-2*left_offset, MAXFLOAT);
    CGSize size = [_inputTextView sizeThatFits:constraintSize];
    CGFloat descriptionH = size.height;
    
    [_inputTextView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.bottom).offset(itemSpace10);
        make.left.equalTo(left_offset);
        make.right.equalTo(-left_offset);
        make.height.equalTo(descriptionH);
    }];
}

- (void)layoutTagView
{
    //标签表高度
    CGFloat tagHeight = 0;
    if ([_itemTagLabel.text length])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LineSpace];//调整行间距
        NSDictionary *attrDic = @{NSFontAttributeName:_itemTagLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_itemTagLabel.text attributes:attrDic];
        _itemTagLabel.attributedText = attributedString;
        
        CGRect rect = [_itemTagLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-2*left_offset, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attrDic
                                                       context:nil];
        tagHeight = rect.size.height>0? rect.size.height+1:0;
    }
    
    [_itemTagLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itmeNameLabel.bottom).offset(0);
        make.left.equalTo(left_offset);
        make.right.equalTo(-left_offset);
        make.height.equalTo(tagHeight);
    }];
}

- (void)layoutDescView
{
    //物品名高度
    [_itmeNameLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(top_offset);
        make.right.equalTo(-left_offset);
        make.top.equalTo(0);
        make.height.equalTo(defaultHeight);
    }];
    
    [self layoutTagView];
    
    [_lineView remakeConstraints:^(MASConstraintMaker *make) {
        if ([_itemTagLabel.text length]>0) {
             make.top.equalTo(_itemTagLabel.bottom).offset(itemSpace10);
        } else {
             make.top.equalTo(_itmeNameLabel.bottom).offset(0);
        }
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    [self layoutInputView];
    
    [_itemDescView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(_inputTextView.bottom).offset(itemSpace10);
    }];
}

- (void)layoutTagListView
{
    
}

#pragma mark - action

- (void)handleBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleConfirmAction
{
    self.itemContent.name = _itemName;
    self.itemContent.property = _propertyArray;
    
    [[BModelInterface shareInstance] handleItemWithAction:ModelAction_update andData:self.itemContent];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTapAction
{
    [_inputTextView becomeFirstResponder];
}

#pragma mark -  BTagLabelViewDelegate

- (void)BTagLabelView:(BTagLabelView *)aLabel didTapTagAtIndex:(NSInteger)aIndex withString:(NSString *)aTapString
{
    if (_itemTagLabel != aLabel && [aTapString length]) {
        if (_itemName == nil) {
            _itemName = aTapString;
        } else {
            [_propertyArray addObject:aTapString];
            [[BModelInterface shareInstance] statisticsProperties:@[aTapString] withCategoryId:self.itemContent.categoryId];
        }

        [self refreshData];
        [self.view layoutIfNeeded];
    }
}

- (void)BTagLabelView:(BTagLabelView *)aLabel didSetTagAtIndex:(NSInteger)aIndex
{
    if (_itemTagLabel == aLabel) {
        if (aIndex <[_propertyArray count]) {
            NSString *temp = [_propertyArray objectAtIndex:aIndex];
            [_propertyArray replaceObjectAtIndex:aIndex withObject:_itemName];
            
            NSLog(@"set tag = %@", temp);
            _itemName = temp;
            [self refreshData];
            [self.view layoutIfNeeded];
        } else {
            NSLog(@"data error: %s", __func__);
        }
    }
}

- (void)BTagLabelView:(BTagLabelView *)aLabel didDeleteTagAtIndex:(NSInteger)aIndex
{
    if (_itemTagLabel == aLabel) {
        if (aIndex <[_propertyArray count]) {
            NSLog(@"delete tag = %@", [_propertyArray objectAtIndex:aIndex]);
            [_propertyArray removeObjectAtIndex:aIndex];
            
            _itemTagLabel.tagArray = _propertyArray;
            [self refreshData];
            [self.view layoutIfNeeded];
        } else {
            NSLog(@"data error: %s", __func__);
        }
    }
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
//    [self layoutSubViews];
    [self layoutInputView];
    
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
        if ([textView.text length] == 0) {
            [textView resignFirstResponder];
            return NO;
        }
        
        //去除空格和换行
        NSString* s1=[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString* s2=[s1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([s2 length] == 0) {
            [textView resignFirstResponder];
            return NO;
        }
        
        if (_itemName == nil) {
            _itemName = s2;
        } else {
            [_propertyArray addObject:s2];
        }
        [[BModelInterface shareInstance] statisticsProperties:@[s2] withCategoryId:self.itemContent.categoryId];
        
        textView.text = nil;
        
        [self refreshData];
        [self.view layoutIfNeeded];

        return NO;
    }
    return YES;
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
