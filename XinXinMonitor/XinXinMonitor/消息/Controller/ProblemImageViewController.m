//
//  ProblemImageViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ProblemImageViewController.h"
#import "UIView+SRLayout.h"

@interface ProblemImageViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@end

@implementation ProblemImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    if (self.enterType == 1) {
        [self setNavigationRightItemWithString:@"取消警报"];
    }
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 64)];
    self.mainScrollView.minimumZoomScale = 1.0f;
    self.mainScrollView.maximumZoomScale = 3.0f;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.backgroundColor = [UIColor blackColor];
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    self.image = [[UIImageView alloc] init];
    self.image.userInteractionEnabled = YES;
    [self.mainScrollView addSubview:self.image];
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/camera/picture/icon?pkid=%@",XinXinMonitorURL,self.pkid]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"%@",self.image.image.description);
        if (self.image.image) {
            CGFloat height = self.image.image.size.height * kkViewWidth / self.image.image.size.width;
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新
                self.image.frame = CGRectMake(0,(kkViewHeight - 64 - height) / 2 , kkViewWidth, height);
            });
        } else {
            [self showMessageWithString:@"图片加载失败" showTime:1.0];
        }
        
    }];
    [self setNavigationTitle:self.monitorCode TextColor:[UIColor whiteColor] Font:nil];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kkViewWidth, 20)];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.text = self.address;
    [self.view addSubview:addressLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kkViewWidth, 20)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = self.timeString;
    [self.view addSubview:timeLabel];
    
    [self addTelephoneBtn];
    
    // Do any additional setup after loading the view.
}

- (void)rightBtnClick:(UIButton *)sender {
    [self cancelProblem];
}

#pragma mark - 取消问题图片
- (void)cancelProblem {
    [self showSVProgressHUD];
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,cancelProblemImageAPI] params:[XinXinMonitorAPI CancelProblemImage:self.pkid] success:^(id responseObj) {
        
        NSDictionary *dict = responseObj;
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        [self showMessageWithString:[dict objectForKey:@"message"] showTime:1.0];
        
        
    } failure:^(NSError *error) {
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}


#pragma mark - 添加拍照按钮
- (void)addTelephoneBtn {
    CGFloat btnWidth = 44 * KASAdapterSizeWidth;
    UIButton *telephoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, kkViewHeight - btnWidth - 104, btnWidth, btnWidth)];
    [telephoneBtn setBackgroundImage:[UIImage imageNamed:@"cameraImg"] forState:UIControlStateNormal];
    [telephoneBtn addTarget:self action:@selector(telephoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telephoneBtn];
}

#pragma mark - 拍照
- (void)telephoneBtnClick:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@进行拍照",self.telephone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1001) {
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.telephone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.image;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 延中心点缩放
    CGRect rect = self.image.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    if (rect.size.width < self.mainScrollView.mssWidth) {
        rect.origin.x = floorf((self.mainScrollView.mssWidth - rect.size.width) / 2.0);
    }
    if (rect.size.height < self.mainScrollView.mssHeight) {
        rect.origin.y = floorf((self.mainScrollView.mssHeight - rect.size.height) / 2.0);
    }
    self.image.frame = rect;
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
