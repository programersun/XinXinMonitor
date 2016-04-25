//
//  ChooseCityViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "ChineseString.h"
#import "CityChooseTableViewCell.h"

@interface ChooseCityViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cityArray;            /**< 城市数组*/
@property (nonatomic, strong) NSMutableArray *indexArray;           /**< 索引数组*/
@property (nonatomic, strong) NSMutableArray *letterResultArray;    /**< 返回数组*/
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (nonatomic, strong) UIButton *locationBtn;

@end

@implementation ChooseCityViewController

- (NSMutableArray *)cityArray {
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

- (NSMutableArray *)indexArray {
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)letterResultArray {
    if (_letterResultArray == nil) {
        _letterResultArray = [NSMutableArray array];
    }
    return _letterResultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseCityTitleLabel.text = [NSString stringWithFormat:@"当前城市-%@",[[LocationManager sharedManager] getCity]];
    NSArray *provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    NSMutableArray *citys = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < provinces.count; i++) {
        NSString *province = [[provinces objectAtIndex:i] objectForKey:@"state"];
        if ([province isEqualToString:@"北京"] || [province isEqualToString:@"天津"] || [province isEqualToString:@"上海"] || [province isEqualToString:@"重庆"]) {
            continue;
        }
        
        [citys addObject:[[provinces objectAtIndex:i] objectForKey:@"cities"]];
    }
    
    for (int i = 0; i < citys.count; i++) {
        NSMutableArray *areas = [[NSMutableArray alloc] initWithArray:citys[i]];
        for (int j = 0; j < areas.count; j++) {
            [self.cityArray addObject:areas[j]];
        }
    }
    
    NSArray *bigcity = @[@"北京",@"上海",@"天津",@"重庆"];
    [self.cityArray addObjectsFromArray:bigcity];
    self.indexArray = [ChineseString IndexArray:self.cityArray];
    self.letterResultArray = [ChineseString LetterSortArray:self.cityArray];
    
    // Do any additional setup after loading the view.
}

//关闭按钮
- (IBAction)backBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)locationBtnClick:(UIButton *)sender {
    [[LocationManager sharedManager] setLocationAuthority];
    if (![sender.titleLabel.text isEqualToString:@"定位失败"]) {
        if (self.cityChangeBlock) {
            self.cityChangeBlock(sender.titleLabel.text);
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *returnArray;
    [returnArray addObject:@"#"];
    [returnArray addObjectsFromArray:self.indexArray];
    return returnArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"#";
    } else {
        NSString *key = [self.indexArray objectAtIndex:section - 1];
        return key;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.indexArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return [[self.letterResultArray objectAtIndex:section - 1] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
        }
        
        NSString *btnString;
        
        if ([CLLocationManager locationServicesEnabled] &&
            ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
             || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
            btnString = [[LocationManager sharedManager] getMyCity];
        } else {
            btnString = @"定位失败";
        }
        CGFloat btnWidth = [PublicUtil widthOfString:btnString withFont:15];
        
        self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, btnWidth + 20, 30)];
        self.locationBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.locationBtn setTitle:btnString forState:UIControlStateNormal];
        [self.locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.locationBtn.layer.masksToBounds = YES;
        self.locationBtn.layer.borderColor = [UIColor grayColor].CGColor;
        self.locationBtn.layer.borderWidth = 1;
        self.locationBtn.layer.cornerRadius = 4;
        [self.locationBtn addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:self.locationBtn];
        
        return cell;
    } else {
    
        CityChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityChooseTableViewCell"];
        if (cell == nil) {
            cell = [[CityChooseTableViewCell alloc] init];
        }
        cell.cityLabel.text = [[self.letterResultArray objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, 20)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, kkViewWidth - 40, 20)];
    
    headerView.backgroundColor = [ColorRequest BackGroundColor];
    
    if (section == 0) {
        lab.text = @"定位城市";
    } else {
        lab.text = [self.indexArray objectAtIndex:section - 1];
    }
    lab.textColor = [UIColor blackColor];
    [headerView addSubview:lab];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1 * KASAdapterSizeHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 0) {
        NSString *cityString = [NSString stringWithFormat:@"%@市",[[self.letterResultArray objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row]];
        if (self.cityChangeBlock) {
            self.cityChangeBlock(cityString);
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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
