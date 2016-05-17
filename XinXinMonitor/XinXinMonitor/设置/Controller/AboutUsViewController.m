//
//  AboutUsViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/10.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"关于我们" TextColor:[UIColor whiteColor] Font:nil];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self loadAboutUsView];
    
    // Do any additional setup after loading the view.
}

- (void)loadAboutUsView {
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 64)];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kkViewWidth - 281 * KASAdapterSizeWidth)/2, 100, 281 * KASAdapterSizeWidth, 139 * KASAdapterSizeWidth)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoImageView.frame.origin.y + logoImageView.frame.size.height + 100, kkViewWidth, 21)];
    [copyrightLabel setTextAlignment:NSTextAlignmentCenter];
    copyrightLabel.text = @"济南鑫新东信科技有限公司";
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, copyrightLabel.frame.origin.y + copyrightLabel.frame.size.height + 20, kkViewWidth, 21)];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    //当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *VersionKey = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"当前版本:v%@",VersionKey];
    
    [mainScrollView addSubview:logoImageView];
    [mainScrollView addSubview:copyrightLabel];
    [mainScrollView addSubview:versionLabel];
    [self.view addSubview:mainScrollView];
    
    if ((versionLabel.frame.origin.y + versionLabel.frame.size.height) > kkViewHeight) {
        mainScrollView.contentSize = CGSizeMake(kkViewWidth, versionLabel.frame.origin.y + versionLabel.frame.size.height + 30);
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
