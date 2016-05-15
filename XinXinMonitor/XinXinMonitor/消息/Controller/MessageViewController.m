
//
//  MessageViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "MessageViewController.h"
#import "ImageDetailViewController.h"
#import "MessageTableViewCell.h"

@interface MessageViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSInteger _pageNum;
    NSInteger _count;
}
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation MessageViewController

- (NSMutableArray *)manageArray {
    if (_messageArray == nil) {
        _messageArray = [NSMutableArray array];
    }
    return  _messageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle:@"我的消息" TextColor:[UIColor whiteColor] Font:nil];
    _pageNum = 0;
    _count = 11;
    __weak MessageViewController *weakself = self;
    self.messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 0;
        _count = 11;
        [weakself loadMessageInfo];
    }];
//
//    self.messageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        _pageNum ++;
//        _count = 15;
//        [weakself loadMessageInfo];
//    }];
    
    [self showSVProgressHUD];
    [self loadMessageInfo];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 结束加载

- (void)endRefresh {
    [self.messageTableView.mj_header endRefreshing];
    [self.messageTableView.mj_footer endRefreshing];
    [self hideSVProgressHUD];
}

#pragma mark - 加载数据
- (void)loadMessageInfo {
    
    [self endRefresh];
    [self.messageTableView reloadData];
    if ((_count - 10 * _pageNum) < 10) {
        [self hideSVProgressHUD];
        [self.messageTableView.mj_footer endRefreshingWithNoMoreData];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] init];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000000001;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    if (vc == nil) {
        vc = [[ImageDetailViewController alloc] init];
    }
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不能恢复，是否确认删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)toImageDetailView {
    ImageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    if (vc == nil) {
        vc = [[ImageDetailViewController alloc] init];
    }
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"删除");
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
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
