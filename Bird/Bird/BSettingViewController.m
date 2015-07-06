//
//  SettingViewController.m
//  Bird
//
//  Created by 孙永刚 on 15-6-20.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BSettingViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <StoreKit/StoreKit.h>

static NSString *const Mail_Receiver = @"w15964236402@126.com";
static NSString *const App_ID = @"594467299";

@interface BSettingViewController () <UITableViewDataSource,
UITableViewDelegate,
MFMailComposeViewControllerDelegate,
SKStoreProductViewControllerDelegate>
{
    UIButton *_backBtn;
    UILabel *_titleLabel;
    UITableView *_settingTable;
    UIImageView *_bgView;
    
    NSArray *_dataArray;
}
@end

@implementation BSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:231.0/255.0
                                                green:231.0/255.0
                                                 blue:231.0/255.0
                                                alpha:1.0];
    _dataArray = @[@"请为我们评分", @"使用教程", @"意见反馈", @"关于我们"];
    
    [self configNavigationBar];
    
    [self createTableView];
    
    [self createBgView];
    
    [self layoutSubViews];
}

- (void)configNavigationBar
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectZero;
    [_backBtn addTarget:self action:@selector(handleDissmissAction) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"设置";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_titleLabel];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)createTableView
{
    _settingTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    _settingTable.showsVerticalScrollIndicator = NO;
    _settingTable.showsHorizontalScrollIndicator = NO;
    _settingTable.scrollEnabled = NO;
    _settingTable.layer.cornerRadius = 5;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    _settingTable.tableFooterView = footView;
    _settingTable.separatorColor = [UIColor colorWithRed:204.0/255.0
                                                   green:204.0/255.0
                                                    blue:204.0/255.0
                                                   alpha:1.0];
    if ([_settingTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_settingTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_settingTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_settingTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _settingTable.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:_settingTable];
}

- (void)createBgView
{
    _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_bg"]];
    [self.view addSubview:_bgView];
}

- (void)layoutSubViews
{
    [_backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(0);
        make.width.equalTo(44);
        make.height.equalTo(44);
    }];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(20);
        make.width.equalTo(50);
        make.height.equalTo(44);
    }];
    
    [_settingTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.bottom).offset(25);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(200);
//        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(148);
    }];
}

- (void)handleDissmissAction
{
//    [self.navigationController popoverPresentationController];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)title
{
    return @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - store

- (void)scoreSupport
{
    NSString* m_appleID = App_ID;    //tinyray 此处的appID是在iTunes Connect创建应用程序时生成的Apple ID
    //应用外打开
    if (1) {
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                         m_appleID ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        //NSLog(@"打分支持！！");
    }
    //应用内打开
    else
    {
//        //初始化控制器
//        SKStoreProductViewController *storeProductViewContorller =[[SKStoreProductViewController alloc] init];
//        //设置代理请求为当前控制器本身
//        storeProductViewContorller.delegate = self;
//        //加载一个新的视图展示
//        [storeProductViewContorller loadProductWithParameters:
//         @{SKStoreProductParameterITunesItemIdentifier:m_appleID}//appId唯一的
//                                              completionBlock:^(BOOL result, NSError *error) {
//                                                  //block回调
//                                                  if(error){
//                                                      NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
//                                                  }else{
//                                                      //模态弹出appstore
//                                                      [self presentViewController:storeProductViewContorller animated:YES completion:^{}];
//                                                  }
//                                              }
//         ];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - email

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:_title_
//                                                                     message:msg
//                                                              preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
//                                                     style:UIAlertActionStyleDefault
//                                                   handler:^(UIAlertAction *action) {
//                                                       [self dismissViewControllerAnimated:YES completion:nil];
//                                                   }];
//    [alertVC addAction:action];
//    [self presentViewController:alertVC animated:YES completion:nil];
}

//点击按钮后，触发这个方法
-(void)sendEMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}
//可以发送邮件的话
- (void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"意见反馈"];
    
    // 添加发送者
    NSArray *toRecipients = @[Mail_Receiver];
    [mailPicker setToRecipients: toRecipients];

    NSString *emailBody = @"请填写您的意见\n";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
}

- (void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            //评分
            [self scoreSupport];
        }
            break;
        case 1:
        {
            //教程
        }
            break;
        case 2:
        {
            //反馈
            [self sendEMail];
        }
            break;
        case 3:
        {
            //关于我们
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    
    
    NSString *title = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    
    return cell;
}


@end
