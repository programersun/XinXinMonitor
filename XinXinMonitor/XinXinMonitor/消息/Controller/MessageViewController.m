
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

@interface MessageViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _pageNum;
}
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
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)toImageDetailView {
    ImageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    if (vc == nil) {
        vc = [[ImageDetailViewController alloc] init];
    }
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
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
