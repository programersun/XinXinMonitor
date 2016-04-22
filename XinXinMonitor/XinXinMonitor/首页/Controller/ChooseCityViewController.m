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

@end

@implementation ChooseCityViewController

- (NSArray *)cityArray {
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

- (NSArray *)indexArray {
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSArray *)letterResultArray {
    if (_letterResultArray == nil) {
        _letterResultArray = [NSMutableArray array];
    }
    return _letterResultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseCityTitleLabel.text = [NSString stringWithFormat:@"当前城市-%@",[[LocationManager sharedManager] getCity]];
    NSArray *array = @[@"北京",@"济南",@"淄博",@"青岛",@"烟台",@"潍坊",@"滨州",@"菏泽",@"枣庄",@"临沂",@"泰安",@"德州",@"东营",@"日照",@"聊城",@"莱芜",@"威海",@"济宁"];
    [self.cityArray setArray:array];
    self.indexArray = [ChineseString IndexArray:self.cityArray];
    self.letterResultArray = [ChineseString LetterSortArray:self.cityArray];
    
    // Do any additional setup after loading the view.
}

//关闭按钮
- (IBAction)backBtnClick:(id)sender {
    
//    if (self.cityChangeBlock) {
//        self.cityChangeBlock(@"淄博市");
//    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.letterResultArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityChooseTableViewCell"];
    if (cell == nil) {
        cell = [[CityChooseTableViewCell alloc] init];
    }
    cell.cityLabel.text = [[self.letterResultArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, 20)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, kkViewWidth - 40, 20)];
    
    headerView.backgroundColor = [ColorRequest BackGroundColor];
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = [UIColor blackColor];
    [headerView addSubview:lab];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cityString = [NSString stringWithFormat:@"%@市",[[self.letterResultArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    if (self.cityChangeBlock) {
        self.cityChangeBlock(cityString);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
