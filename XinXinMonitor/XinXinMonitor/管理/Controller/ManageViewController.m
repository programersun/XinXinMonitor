//
//  ManageViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ManageViewController.h"
#import "ImageDetailViewController.h"
#import "ManageTableViewCell.h"
#import "AddMonitorViewController.h"
#import "MonitorListBaseClass.h"
#import "MonitorListRows.h"
#import "ChooseMonitorTypeView.h"

@interface ManageViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSInteger _pageNum;
    NSInteger _deleteIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *manageTableView;

@property (nonatomic, strong) NSMutableArray *manageArray;
@property (nonatomic, strong) MonitorListBaseClass *monitorListBaseClass;
@property (nonatomic, strong) ChooseMonitorTypeView *chooseMonitorTypeView;
@property (nonatomic, strong) NSMutableArray *monitorTypeArray;
@property (nonatomic, strong) NSString *monitorType;

@end

@implementation ManageViewController

- (NSMutableArray *)manageArray {
    if (!_manageArray ) {
        _manageArray = [NSMutableArray array];
    }
    return  _manageArray;
}

- (NSMutableArray *)monitorTypeArray {
    if (!_monitorTypeArray) {
        _monitorTypeArray = [NSMutableArray array];
    }
    return _monitorTypeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"设备管理" TextColor:[UIColor whiteColor] Font:nil];
    if ([[UserInfoManager sharedManager].userType integerValue] == 1) {
        [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"addMonitor"] highlightedImg:[UIImage imageNamed:@"addMonitor"]];
    }
    
    [self setNavigationRightItemWithString:@"全部"];
    _pageNum = 1;
    __weak ManageViewController *weakself = self;
    
    self.manageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [weakself loadMonitorInfo];
    }];
    
    [self showSVProgressHUD];
    [self loadMonitorInfo];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    if (_pageNum == self.monitorListBaseClass.pagenums) {
        [self.manageTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.chooseMonitorTypeView.hidden = YES;
    [self endRefresh];
}

- (void)leftBtnClick:(UIButton *)sender {
    AddMonitorViewController *vc = [[UIStoryboard storyboardWithName:@"ManageStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"AddMonitorViewController"];
    if (vc == nil) {
        vc = [[AddMonitorViewController alloc] init];
    }
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBtnClick:(UIButton *)sender {
    if (self.chooseMonitorTypeView == nil) {
        [self createMonitorTypeView];
    }
    if (self.monitorTypeArray.count == 0) {
        [self loadMonitorType];
    } else {
        [self showAndHidechooseMonitorTypeView];
    }
}

- (void)showAndHidechooseMonitorTypeView {
    if (self.chooseMonitorTypeView.hidden) {
        self.chooseMonitorTypeView.hidden = NO;
    } else {
        self.chooseMonitorTypeView.hidden = YES;
    }
}

- (void)createMonitorTypeView {
    
    self.chooseMonitorTypeView = [[ChooseMonitorTypeView alloc] initWithFrame:CGRectMake(kkViewWidth - 110, 3, 100, 40)];
    self.chooseMonitorTypeView.MonitorTypeArray = self.monitorTypeArray;
    self.chooseMonitorTypeView.viewType = @"2";
    __weak ManageViewController *weakself = self;
    self.chooseMonitorTypeView.cellClickBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakself setNavigationRightItemWithString:@"全部"];
            weakself.monitorType = @"";
        } else {
            NSDictionary *dict = weakself.monitorTypeArray[index - 1];
            [weakself setNavigationRightItemWithString:[dict objectForKey:@"name"]];
            weakself.monitorType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        }
        weakself.chooseMonitorTypeView.hidden = YES;
        [weakself loadMonitorInfo];
    };
    self.chooseMonitorTypeView.hidden = YES;
    [self.view addSubview:self.chooseMonitorTypeView];
    
}

#pragma mark - 获取设备类型
- (void)loadMonitorType {
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,MyMonitorTypeAPI] params:[XinXinMonitorAPI MonitorTypes] success:^(id responseObj) {
        [self.monitorTypeArray removeAllObjects];
        for (NSDictionary *dict in responseObj) {
            [self.monitorTypeArray addObject:dict];
        }
        
        CGFloat viewHegiht;
        if ((self.monitorTypeArray.count + 1) * 40 > 200) {
            viewHegiht = 200;
        } else {
            viewHegiht = (self.monitorTypeArray.count + 1) * 40;
        }
        self.chooseMonitorTypeView.frame = CGRectMake(kkViewWidth - 110, 3, 100, viewHegiht);
        [self.chooseMonitorTypeView.chooseMonitorTypeTableView reloadData];
        [self showAndHidechooseMonitorTypeView];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 结束加载
- (void)endRefresh {
    [self.manageTableView.mj_header endRefreshing];
    [self.manageTableView.mj_footer endRefreshing];
}

#pragma mark - 加载数据
- (void)loadMonitorInfo {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum] forKey:@"page"];
    if (kkViewHeight > 568) {
        [dic setValue:@"10" forKey:@"rows"];
    }
    if (![self.monitorType isEqualToString:@""]) {
        [dic setValue:self.monitorType forKey:@"type"];
    }
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,MonitorListAPI] params:[XinXinMonitorAPI monitorListWithDic:dic] success:^(id responseObj) {
        
        NSDictionary *dict = responseObj;
        
        self.monitorListBaseClass = [[MonitorListBaseClass alloc] initWithDictionary:dict];
        if (_pageNum == 1) {
            [self.manageArray removeAllObjects];
        }
        for (MonitorListRows *row in self.monitorListBaseClass.rows) {
            [self.manageArray addObject:row];
        }
        if (self.manageArray.count > 0) {
            [self hideSVProgressHUD];
            __weak ManageViewController *weakself = self;
            self.manageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _pageNum ++;
                [weakself loadMonitorInfo];
            }];
        } else {
            [self showMessageWithString:@"暂无数据" showTime:1.0];
            self.manageTableView.mj_footer = nil;
        }
        
        [self endRefresh];
        [self.manageTableView reloadData];
        if (_pageNum == self.monitorListBaseClass.pagenums) {
            [self.manageTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}

- (void)deleteMonitorWithMonitorID:(NSString *)monitorID {
    [self showSVProgressHUD];
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,DeleteMonitorAPI] params:[XinXinMonitorAPI deleteMonitorWithMonitorID:monitorID] success:^(id responseObj) {
        NSDictionary *dict = responseObj;
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            [self hideSVProgressHUD];
            [self.manageArray removeObjectAtIndex:_deleteIndex];
            [self.manageTableView reloadData];
        } else {
            [self showSuccessWithString:[dict objectForKey:@"message"] showTime:1.0];
        }
        
    } failure:^(NSError *error) {
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    [self loadMonitorInfo];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManageTableViewCell"];
    if (cell == nil) {
        cell = [[ManageTableViewCell alloc] init];
    }
    MonitorListRows *model = self.manageArray[indexPath.row];
    [cell loadCellWithModel:model];
    __weak ManageTableViewCell *weakcell = cell;
    cell.cellRightBtnClickBlock = ^{
        weakcell.cellRightBtn.enabled = NO;
        [self showSVProgressHUD];
        NSMutableDictionary *params;
        if (model.yinhuanStatus == 0) {
            params = [XinXinMonitorAPI setMonitorWithMonitorID:model.pkid status:@"1"];
        } else if (model.yinhuanStatus == 1) {
            params = [XinXinMonitorAPI setMonitorWithMonitorID:model.pkid status:@"0"];
        }
        [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,SetYinHuanStatusAPI] params:params success:^(id responseObj) {
            NSDictionary *dict = responseObj;
            if ([[dict objectForKey:@"code"] integerValue] == 1) {
                
                if (model.yinhuanStatus == 0) {
                    model.yinhuanStatus = 1;
                } else if (model.yinhuanStatus == 1) {
                    model.yinhuanStatus = 0;
                }
                [self.manageArray replaceObjectAtIndex:indexPath.row withObject:model];
                [self.manageTableView reloadData];
                [self showSuccessWithString:[dict objectForKey:@"message"] showTime:1.0];
            }
            [self showSuccessWithString:[dict objectForKey:@"message"] showTime:1.0];
            weakcell.cellRightBtn.enabled = NO;
        } failure:^(NSError *error) {
            weakcell.cellRightBtn.enabled = NO;
            [self showMessageWithString:@"服务器开小差了" showTime:1.0];
        }];
    };
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UserInfoManager sharedManager].userType integerValue] == 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MonitorListRows *model = self.manageArray[indexPath.row];
    [self toImageDetailView:model];
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        MonitorListRows *model = self.manageArray[_deleteIndex];
        [self deleteMonitorWithMonitorID:[NSString stringWithFormat:@"%@",model.pkid]];
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)toImageDetailView:(MonitorListRows *)model {
    ImageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    if (vc == nil) {
        vc = [[ImageDetailViewController alloc] init];
    }
    NSTimeInterval time = (model.lastupdateTime + 28800)/1000;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    vc.timeString = [formatter stringFromDate:date];
    vc.problemPictureId = @"";
    vc.telephone = model.phone;
    vc.address = model.address;
    vc.monitorCode = model.code;
    vc.enterType = 1;
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
