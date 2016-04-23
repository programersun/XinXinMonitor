//
//  MainTabBarViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "ShouYeViewController.h"
#import "ManageViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"

@interface MainTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UINavigationController *firstViewController;
@property (nonatomic, strong) UINavigationController *secondViewController;
@property (nonatomic, strong) UINavigationController *thirdViewController;
@property (nonatomic, strong) UINavigationController *fourthViewController;

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    self.firstViewController = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateInitialViewController];
    self.secondViewController = [[UIStoryboard storyboardWithName:@"ManageStoryboard" bundle:nil] instantiateInitialViewController];
    self.thirdViewController = [[UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil] instantiateInitialViewController];
    self.fourthViewController = [[UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil] instantiateInitialViewController];
    
    [self setViewControllers:[NSArray arrayWithObjects:self.firstViewController,self.secondViewController,self.thirdViewController,self.fourthViewController, nil] animated:NO];
    
    //默认图片
    NSArray *imageName = @[@"tabbar_first",@"tabbar_second",@"tabbar_third",@"tabbar_fourth"];
    //选中图片
//    NSArray *imageSelectName = @[@"tabbar_first_select",@"tabbar_second_select",@"tabbar_third_select",@"tabbar_fourth_select"];
    NSArray *tabBarTitle = @[@"首页",@"管理",@"消息",@"设置"];
    
    //设置tabBar背景颜色和选中颜色
    self.tabBar.backgroundColor = [ColorRequest TabBarBackgroundColor];
    self.tabBar.tintColor = [ColorRequest MainBlueColor];
    
    CGRect rect = CGRectMake(0, 0, kkViewWidth, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [ColorRequest TabBarLineColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    for (int i = 0 ; i < 4 ; i++) {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        item.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName[i]]];
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        item.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageSelectName[i]]];
        [item setTitle:[NSString stringWithFormat:@"%@",tabBarTitle[i]]];
        
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorRequest MainBlueColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:10],NSFontAttributeName,nil] forState:UIControlStateSelected];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorRequest TabBarTextColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:10],NSFontAttributeName,nil] forState:UIControlStateNormal];
    }

  
    // Do any additional setup after loading the view.
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
