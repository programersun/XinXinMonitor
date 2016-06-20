//
//  SearchAddressListViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/6/16.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SearchAddressListViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "ChooseCityViewController.h"

@interface SearchAddressListViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,BMKPoiSearchDelegate> {
    BMKPoiSearch* _poisearch;
    int _pageNumber;
}
@property (weak, nonatomic) IBOutlet UITableView *searchListTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchListArray;
@property (nonatomic, strong) UIButton *changeCityBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSString *chooseCity;

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
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, kkViewWidth - 50, 40)];
    self.chooseCity = [[[LocationManager sharedManager] getMyCity] stringByReplacingOccurrencesOfString:@"市" withString:@""];
    CGFloat btnWidth = [PublicUtil widthOfString:self.chooseCity withFont:16];
    self.changeCityBtn = [[UIButton alloc] initWithFrame:CGRectMake(FRAMNE_W(self.topView) - btnWidth - 5, 0, btnWidth + 10, 40)];
    self.changeCityBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.changeCityBtn setTitle:self.chooseCity forState:UIControlStateNormal];
    [self.changeCityBtn addTarget:self action:@selector(changeCityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, FRAMNE_W(self.topView) - btnWidth - 10, 40)];
    self.searchBar.placeholder = @"请输入地址关键字";
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:40.0f];
    //设置背景图片
    [self.searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    
    self.searchBar.delegate = self;
    
    [self.topView addSubview:self.searchBar];
    [self.topView addSubview:self.changeCityBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.topView];
    _poisearch = [[BMKPoiSearch alloc]init];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, 1)];
    footView.backgroundColor = RGBACOLOR(244, 245, 246, 1);
    self.searchListTableView.tableFooterView = footView;
    
    __weak SearchAddressListViewController *weakself = self;
    self.searchListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 0;
        if (self.searchBar.text.length > 0) {
            [weakself poiAddressWithString:self.searchBar.text];
        } else {
            [self.searchListArray removeAllObjects];
            self.searchListTableView.mj_footer = nil;
            [self.searchListTableView reloadData];
            [self endRefresh];
        }
    }];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    _poisearch.delegate = nil; // 不用时，置nil
    [self endRefresh];
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - 结束加载

- (void)endRefresh {
    [self.searchListTableView.mj_header endRefreshing];
    [self.searchListTableView.mj_footer endRefreshing];
    [self hideSVProgressHUD];
}

- (void)changeCityBtnClick:(UIButton *)sender {
    ChooseCityViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseCityViewController"];
    if (vc == nil) {
        vc = [[ChooseCityViewController alloc] init];
    }
    __weak SearchAddressListViewController *weakself = self;
    vc.cityChangeBlock = ^(NSString *chooseCityString){
        if (![weakself.chooseCity isEqualToString:chooseCityString]) {
            weakself.chooseCity = [chooseCityString stringByReplacingOccurrencesOfString:@"市" withString:@""];;
            CGFloat btnWidth = [PublicUtil widthOfString:weakself.chooseCity withFont:16];
            weakself.changeCityBtn.frame = CGRectMake(FRAMNE_W(weakself.topView) - btnWidth - 5, 0, btnWidth + 10, 40);
            weakself.searchBar.frame = CGRectMake(0, 0, FRAMNE_W(weakself.topView) - btnWidth - 10, 40);
            [self.changeCityBtn setTitle:weakself.chooseCity forState:UIControlStateNormal];
            _pageNumber = 0;
            [weakself.searchListArray removeAllObjects];
            weakself.searchListTableView.mj_footer = nil;
            [weakself.searchListTableView reloadData];
        }
    };
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

#pragma mark - 获取地址
- (void)poiAddressWithString:(NSString *)string {
    [self showSVProgressHUD];
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _pageNumber;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= self.chooseCity;
    citySearchOption.keyword = string;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
//        NSLog(@"城市内检索发送成功");
    }
    else
    {
//        NSLog(@"城市内检索发送失败");
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _pageNumber = 0;
    [self poiAddressWithString:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _pageNumber = 0;
    [self poiAddressWithString:searchBar.text];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *searchString;
    if (text.length > 0) {
        searchString = [searchBar.text stringByAppendingString:text];
    } else {
        searchString = [searchBar.text stringByReplacingCharactersInRange:NSMakeRange(searchBar.text.length - 1, 1) withString:@""];
    }
    NSLog(@"%@---%@",searchString,text);
    _pageNumber = 0;
    [self poiAddressWithString:searchString];
    return YES;
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        [self endRefresh];
        if (_pageNumber == 0) {
            [self.searchListArray removeAllObjects];
        }
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            [self.searchListArray addObject:poi];
        }
        if (self.searchListArray.count > 0) {
            __weak SearchAddressListViewController *weakself = self;
            self.searchListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _pageNumber ++;
                if (self.searchBar.text.length > 0) {
                    [weakself poiAddressWithString:self.searchBar.text];
                } else {
                    [self.searchListArray removeAllObjects];
                    self.searchListTableView.mj_footer = nil;
                    [self.searchListTableView reloadData];
                    [self endRefresh];
                }
            }];
        } else {
            self.searchListTableView.mj_footer = nil;
        }
        if (_pageNumber + 1 == result.pageNum) {
            [self.searchListTableView.mj_footer endRefreshingWithNoMoreData];
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
        self.latitude = [LocationManager sharedManager].latitude;
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
