
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
#import "MessageBaseClass.h"
#import "MessageRows.h"
#import "ProblemImageViewController.h"

@interface MessageViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSInteger _pageNum;
    NSInteger _deleteIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) MessageBaseClass *messageBaseClass;

@end

@implementation MessageViewController

- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return  _messageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle:@"我的消息" TextColor:[UIColor whiteColor] Font:nil];
    _pageNum = 1;
    __weak MessageViewController *weakself = self;
    self.messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [weakself loadMessageInfo];
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self showSVProgressHUD];
    [self loadMessageInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideSVProgressHUD];
    [self endRefresh];
}

#pragma mark - 结束加载

- (void)endRefresh {
    [self.messageTableView.mj_header endRefreshing];
    [self.messageTableView.mj_footer endRefreshing];
}

#pragma mark - 加载数据
- (void)loadMessageInfo {
    [self showSVProgressHUD];
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,MessageListAPI] params:[XinXinMonitorAPI MessageListWithPage:_pageNum] success:^(id responseObj) {
        
        NSDictionary *dict = responseObj;
        self.messageBaseClass = [[MessageBaseClass alloc] initWithDictionary:dict];
        if (_pageNum == 1) {
            [self.messageArray removeAllObjects];
        }
        for (MessageRows *row in self.messageBaseClass.rows) {
            [self.messageArray addObject:row];
        }
        
        if (self.messageArray.count > 0) {
            [self hideSVProgressHUD];
            __weak MessageViewController *weakself = self;
            self.messageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _pageNum ++;
                [weakself loadMessageInfo];
            }];
        } else {
            [self showMessageWithString:@"暂无数据" showTime:1.0];
            self.messageTableView.mj_footer = nil;
        }
        [self endRefresh];
        [self.messageTableView reloadData];
        if (_pageNum == self.messageBaseClass.pagenums) {
            [self.messageTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];

    }];
}

- (void)deleteMessage {
    [self showSVProgressHUD];
    MessageRows *model = self.messageArray[_deleteIndex];
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,DeleteMessageAPI] params:[XinXinMonitorAPI deleteMessageWithPkid:[NSString stringWithFormat:@"%@",model.pkid]] success:^(id responseObj) {
        
        NSDictionary *dict = responseObj;
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            [self.messageArray removeObjectAtIndex:_deleteIndex];
            [self.messageTableView reloadData];
        }
        [self showMessageWithString:[dict objectForKey:@"message"] showTime:1.0];
        
    } failure:^(NSError *error) {
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}

- (void)readMessageWithPkid:(NSString *)pkid index:(NSInteger )index{
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,ReadMessageAPI] params:[XinXinMonitorAPI ReadMessageWithPkid:pkid] success:^(id responseObj) {
        NSDictionary *dict = responseObj;
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            MessageRows *model = self.messageArray[index];
            model.readStatus = 1;
            [self.messageArray replaceObjectAtIndex:index withObject:model];
            [self.messageTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] init];
    }
    
    MessageRows *model = self.messageArray[indexPath.row];
    [cell loadCellWithModel:model];
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
    MessageRows *model = self.messageArray[indexPath.row];
    [self readMessageWithPkid:model.pkid index:indexPath.row];
    if (model.type == 0) {
        [self showMessageWithString:[NSString stringWithFormat:@"编号为%@的设备处于离线状态，请及时查看，并拍照解除离线状态",model.cameraCode] showTime:1.0];
    } else if (model.type == 1) {
        ProblemImageViewController *vc = [[ProblemImageViewController alloc] init];
        vc.pkid = model.picturePkid;
        vc.telephone = model.phone;
        vc.address = model.address;
        vc.timeString = model.pictureDateF;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.type == 2) {
        [self toImageDetailView:model];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _deleteIndex = indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不能恢复，是否确认删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)toImageDetailView:(MessageRows *)model {

    ImageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    if (vc == nil) {
        vc = [[ImageDetailViewController alloc] init];
    }
    if (model.type == 1) {
        vc.problemPictureId = model.picturePkid;
        vc.timeString = model.pictureDateF;
    }else {
        vc.problemPictureId = @"";
        vc.timeString = @"";
    }
    
    vc.monitorCode = model.cameraCode;
    vc.telephone = model.phone;
    vc.address = model.address;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteMessage];
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
