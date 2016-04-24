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

@interface ManageViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSInteger _pageNum;
}
@property (weak, nonatomic) IBOutlet UITableView *manageTableView;
@property (nonatomic, strong) NSMutableArray *manageArray;

@end

@implementation ManageViewController

- (NSMutableArray *)manageArray {
    if (_manageArray == nil) {
        _manageArray = [NSMutableArray array];
    }
    return  _manageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"设备管理" TextColor:[UIColor whiteColor] Font:nil];
    [self setNavigationRightItemWithNormalImg:[UIImage imageNamed:@"arrows_up"] highlightedImg:[UIImage imageNamed:@"arrows_up"]];
    _pageNum = 0;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)rightBtnClick:(UIButton *)sender {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManageTableViewCell"];
    if (cell == nil) {
        cell = [[ManageTableViewCell alloc] init];
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"设备%ld",(long)indexPath.row];
    cell.addressLabel.text = [NSString stringWithFormat:@"地址%ld",(long)indexPath.row];
    [cell.cellRightBtn setTitle:@"设置隐患" forState:UIControlStateNormal];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1 * KASAdapterSizeWidth;
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"删除");
        [self.manageTableView reloadData];
    }
    
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
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
