//
//  SR_SINOBaseViewController.m
//  BaseViewController
//
//  Created by 孙瑞 on 16/3/15.
//  Copyright © 2016年 孙瑞. All rights reserved.
//

#import "SR_SINOBaseViewController.h"

@interface SR_SINOBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation SR_SINOBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航不透明
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    //显示系统导航
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self setNavigationBarTintColor:[ColorRequest MainBlueColor]];
    [self setNavigationTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [AFNetworkingTools sharedManager].noNetworkBlock = ^{
        [self showMessageWithString:@"当前无网络!" showTime:1.0];
    };
}

- (void)setNavigationBarTintColor:(UIColor *)barTintColor {
    [self.navigationController.navigationBar setBarTintColor:barTintColor];
}

- (void)setNavigationTintColor:(UIColor *)tintColor {
    [self.navigationController.navigationBar setTintColor:tintColor];
}

- (void)setNavigationTitle:(NSString *)title
                 TextColor:(UIColor *)textColor
                      Font:(UIFont *)font {
    [self.navigationItem setTitle:title];
    [self.navigationController.navigationBar
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             textColor,
                             NSForegroundColorAttributeName,
                             font, NSFontAttributeName, nil]];
}

- (void)setNavigationLeftItemWithString:(NSString *)text {
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:text
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(leftBtnClick:)];
}

- (void)setNavigationLeftItemWithNormalImg:(UIImage *)normalImg
                            highlightedImg:(UIImage *)highlightedImg {
    UIBarButtonItem *leftItem =
    [self navigationItemWithImage:normalImg
                    highImageName:highlightedImg
                           target:self
                           action:@selector(leftBtnClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setNavigationRightItemWithString:(NSString *)text {
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:text
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(rightBtnClick:)];
}

- (void)setNavigationRightItemWithNormalImg:(UIImage *)normalImg
                             highlightedImg:(UIImage *)highlightedImg {
    UIBarButtonItem *rightItem =
    [self navigationItemWithImage:normalImg
                    highImageName:highlightedImg
                           target:self
                           action:@selector(rightBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIBarButtonItem *)navigationItemWithImage:(UIImage *)normalImage
                               highImageName:(UIImage *)highlightedImage
                                      target:(id)target
                                      action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage
                      forState:UIControlStateHighlighted];
    
    if (button.selected) {
        button.enabled = NO;
    } else {
        button.enabled = YES;
    }
    
    // 设置按钮的尺寸为背景图片的尺寸
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    
    // 监听按钮点击
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton *)sender {
}

- (void)popToViewControllerWithClassname:(NSString *)classname {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *viewController in viewControllers) {
        if ([NSStringFromClass([viewController class]) isEqualToString:classname]) {
            [self.navigationController popToViewController:viewController
                                                  animated:YES];
        }
    }
}

- (void)popToViewControllerWithNumber:(NSInteger)number {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > number) {
        [self.navigationController
         popToViewController:viewControllers[viewControllers.count - number - 1]
         animated:YES];
    }
}

- (void)showMessageWithString:(NSString *)string showTime:(NSTimeInterval)showTime{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showErrorWithStatus:string];
    [SVProgressHUD setMinimumDismissTimeInterval:showTime];
}

- (void)showSVProgressHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[ColorRequest MainBlueColor]];
    [SVProgressHUD show];
}

- (void)hideSVProgressHUD {
    [SVProgressHUD dismiss];
}

#pragma mark 设置leftBarButtonItem后保留左侧手势返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}

@end
