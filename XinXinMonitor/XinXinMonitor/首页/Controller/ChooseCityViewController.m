//
//  ChooseCityViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "ChineseString.h"

@interface ChooseCityViewController ()

@end

@implementation ChooseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseCityTitleLabel.text = [NSString stringWithFormat:@"当前城市-%@",[[LocationManager sharedManager] getCity]];
    // Do any additional setup after loading the view.
}

//关闭按钮
- (IBAction)backBtnClick:(id)sender {
    
    if (self.cityChangeBlock) {
        self.cityChangeBlock(@"淄博市");
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
