//
//  ImageDetailViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "ImageDetailCollectionViewCell.h"

@interface ImageDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    NSString *_telephoneNumber;
}

@property (strong, nonatomic) IBOutlet UICollectionView *imageDetailCollectonView;
@property (weak, nonatomic) IBOutlet UIButton *telephoneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telephoneBtnWidth;

@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self setNavigationRightItemWithString:@"筛选"];
    
    _telephoneNumber = @"18513600046";
    
    self.telephoneBtn.layer.masksToBounds = YES;
    self.telephoneBtn.layer.cornerRadius = 44 * KASAdapterSizeWidth / 2;
    self.telephoneBtnWidth.constant = 44 * KASAdapterSizeWidth;

    // Do any additional setup after loading the view.
}

- (IBAction)telephoneBtnClick:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@",_telephoneNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)rightBtnClick:(UIButton *)sender {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageDetailCollectionViewCell" forIndexPath:indexPath];
    [cell loadCellWithModel:nil];
    if (indexPath.row % 2 == 0) {
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/faedab64034f78f0b00507c97e310a55b3191cf9.jpg"]];
    }
    __weak ImageDetailViewController *weakself = self;
    cell.problemBtnClickBlock = ^{
        
    };
    
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kkViewWidth - 20, kkViewHeight - 84);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);// top left bottom right  Cell边界范围
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",_telephoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
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
