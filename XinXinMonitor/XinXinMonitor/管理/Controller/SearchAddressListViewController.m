//
//  SearchAddressListViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/6/16.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SearchAddressListViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface SearchAddressListViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,BMKPoiSearchDelegate> {
    BMKPoiSearch* _poisearch;
    int _pageNumber;
}
@property (weak, nonatomic) IBOutlet UITableView *searchListTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchListArray;
@end

@implementation SearchAddressListViewController

- (NSMutableArray *)searchListArray {
    if (!_searchListArray) {
        _searchListArray = [NSMutableArray array];
    }
    return _searchListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 0, kkViewWidth - 50, 40)];
    self.searchBar.placeholder = @"请输入地址关键字";
    self.searchBar.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    _poisearch = [[BMKPoiSearch alloc]init];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    _poisearch.delegate = nil; // 不用时，置nil
}

- (void)poiAddressWithString:(NSString *)string {
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _pageNumber;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"";
    citySearchOption.keyword = string;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _pageNumber = 0;
    [self poiAddressWithString:searchBar.text];
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (_pageNumber == 0) {
            [self.searchListArray removeAllObjects];
        }
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            [self.searchListArray addObject:poi];
        }
        [self.searchListTableView reloadData];
    } else {
        // 各种情况的判断。。。
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchListArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serachCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"serachCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (当前)",[LocationManager sharedManager].detailAddress];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[LocationManager sharedManager].getMyCity,[LocationManager sharedManager].getMyDistrict];
    } else {
        BMKPoiInfo* poi = self.searchListArray[indexPath.row - 1];
        cell.textLabel.text = poi.address;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",poi.city,poi.name];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.searchAddressString = [LocationManager sharedManager].detailAddress;
        self.latitude = [NSString stringWithFormat:@"%f",[[LocationManager sharedManager].latitude doubleValue] - 1];
        self.longitude = [LocationManager sharedManager].longitude;
    } else {
        
        BMKPoiInfo* poi = self.searchListArray[indexPath.row - 1];
        self.searchAddressString = poi.address;
        self.latitude = [NSString stringWithFormat:@"%f",poi.pt.latitude];
        self.longitude = [NSString stringWithFormat:@"%f",poi.pt.longitude];
    }
    if (self.searchAddressInMapBlock) {
        self.searchAddressInMapBlock(self.searchAddressString,self.latitude,self.longitude);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
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
