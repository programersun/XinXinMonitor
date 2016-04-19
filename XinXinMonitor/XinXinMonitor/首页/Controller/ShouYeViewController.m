//
//  ShouYeViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ShouYeViewController.h"
#import "HomeTopView.h"
#import "CityChangeView.h"
#import "ImageDetailViewController.h"

@interface ShouYeViewController () <HomeTopViewDelegate,CityChangeViewDelegate>

@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) CityChangeView *cityChangeView;

@end

@implementation ShouYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopView];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(toImageDetailView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.topView setAddressBtnTextWithString:@"北京"];
    
    // Do any additional setup after loading the view.
}

- (void)saveCityWithDict:(NSDictionary *)dict {
    NSArray *array = @[@"全城",@"朝阳区",@"东城区",@"海淀区",@"西城区",@"丰台区",@"平谷区",@"延庆县",@"密云县",@"石景山区",@"山头沟",@"顺义区",@"怀柔区",@"房山区",@"昌平区"];
    NSDictionary *cityDict = @{@"City":@"北京",@"District":array};
    NSMutableArray *cityArray;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CityArray"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"CityArray"] != nil) {
        
        BOOL exist = NO;
        for (NSDictionary *dict in cityArray) {
            if ([dict[@"City"] isEqualToString:[NSString stringWithFormat:@"%@",cityDict[@"City"]]]) {
                exist = YES;
            }
        }
        if (!exist) {
            [cityArray addObject:cityDict];
        }
    } else {
        cityArray = [[NSMutableArray alloc] initWithObjects:cityDict, nil];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:cityArray forKey:@"CityArray"];
    [[NSUserDefaults standardUserDefaults] setObject:@"北京" forKey:@"City"];
    [[NSUserDefaults standardUserDefaults] setObject:@"全城" forKey:@"District"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)toImageDetailView {
//    [self.topView setAddressBtnTextWithString:@"乌鲁木齐"];
    
}

/**
 *  设置顶部自定义导航
 */
- (void)addTopView {

    self.topView = [HomeTopView instance];
    self.topView.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.topView];
}

#pragma mark - HomeTopViewDelegate

- (void)addressBtnClick {
    
    self.cityChangeView = [CityChangeView instance];
    self.cityChangeView.delegate = self;
    //添加到window上  最顶层覆盖tabbar
    [[[UIApplication sharedApplication].delegate window] addSubview:self.cityChangeView];
    if (self.cityChangeView.hidden) {
        self.cityChangeView.hidden = NO;
        self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_up"];
    } else {
        self.cityChangeView.hidden = YES;
        self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
    }
}

- (void)mapBtnClick {

}

- (void)searchBtnClick {
    
}

#pragma mark - CityChangeViewDelegate

- (void)backgroundViewClick {
    self.cityChangeView.hidden = YES;
    self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
}

- (void)chooseDistrict:(UIButton *)button {
    NSLog(@"%ld",(long)button.tag);
    NSInteger index = button.tag - 1000;
    if (0 == index) {
        
        NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
        [self.topView setAddressBtnTextWithString:city];
        [[NSUserDefaults standardUserDefaults] setObject:@"全城" forKey:@"District"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self.topView setAddressBtnTextWithString:[NSString stringWithFormat:@"%@",button.titleLabel.text]];
        [[NSUserDefaults standardUserDefaults] setObject:button.titleLabel.text forKey:@"District"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.cityChangeView reloadView];
    self.cityChangeView.hidden = YES;
}

- (void)changeCityClick {
    
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
