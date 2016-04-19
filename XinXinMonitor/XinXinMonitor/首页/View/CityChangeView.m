//
//  CityChangeView.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/18.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "CityChangeView.h"
static CityChangeView *instance;

@interface CityChangeView ()

@end

@implementation CityChangeView

+ (id)instance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[CityChangeView alloc] initWithFrame:CGRectMake(0, 64, kkViewWidth, kkViewHeight - 64)];
            instance.backgroundColor = [UIColor clearColor];
            instance.hidden = YES;
            [instance greatBackgroundView];
            [instance greatDistrictView];
        }
    }
    return instance;
}

#pragma mark - 背景的view
- (void)greatBackgroundView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:instance.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:instance action:@selector(hideCityChangeView)];
    backgroundView.userInteractionEnabled = YES;
    [backgroundView addGestureRecognizer:tap];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    [instance addSubview:backgroundView];
}

#pragma mark - 创建区域选择的view
- (void)greatDistrictView {
    self.districtView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, 40)];
    self.districtView.backgroundColor = [ColorRequest BackGroundColor];
    
    [self addSubview:self.districtView];
    
    self.cityView = [[UIView alloc] initWithFrame:CGRectMake(0, self.districtView.frame.size.height, kkViewWidth, 60 * KASAdapterSizeWidth)];
    self.cityView.backgroundColor = [UIColor greenColor];
    
    UIView *changeView = [[UIView alloc] initWithFrame:CGRectMake(10, (self.cityView.frame.size.height/2 - 15), kkViewWidth - 20, 30)];
    changeView.backgroundColor = [UIColor whiteColor];
    UILabel *citylabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
    citylabel.font = [UIFont systemFontOfSize:15];
    citylabel.text = [NSString stringWithFormat:@"当前城市：%@",[[LocationManager sharedManager] getCity]];
    UILabel *cityChangelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cityView.frame.size.width - 110, 5, 80, 20)];
    cityChangelabel.font = [UIFont systemFontOfSize:15];
    cityChangelabel.textColor = [ColorRequest MainBlueColor];
    cityChangelabel.textAlignment = NSTextAlignmentRight;
    cityChangelabel.text = @"更换";
    [changeView addSubview:cityChangelabel];
    [changeView addSubview:citylabel];
    [self.cityView addSubview:changeView];
    [self addSubview:self.cityView];
    
    //添加选择的区域按钮
    [self reloadView];
    
    //关闭选择界面
    UITapGestureRecognizer *districtViewtap = [[UITapGestureRecognizer alloc] initWithTarget:instance action:@selector(hideCityChangeView)];
    self.districtView.userInteractionEnabled = YES;
    [self.districtView addGestureRecognizer:districtViewtap];
    UITapGestureRecognizer *cityViewtap = [[UITapGestureRecognizer alloc] initWithTarget:instance action:@selector(hideCityChangeView)];
    self.cityView.userInteractionEnabled = YES;
    [self.cityView addGestureRecognizer:cityViewtap];
    
    
    //改变城市点击时间
    UITapGestureRecognizer *changeViewtap = [[UITapGestureRecognizer alloc] initWithTarget:instance action:@selector(changeCity)];
    changeView.userInteractionEnabled = YES;
    [changeView addGestureRecognizer:changeViewtap];
}

#pragma mark - 关闭选择界面
- (void)hideCityChangeView {
    [self.delegate backgroundViewClick];
}

#pragma mark - 改变城市点击时间
- (void)changeCity {
    [self.delegate changeCityClick];
}

#pragma mark - 改变城市点击时间
- (void)changeDistrict:(UIButton *)button {
    [self.delegate chooseDistrict:button];
}

#pragma mark - 创建区域的view
- (void)reloadView {
    
    //移除所有区域按钮
    for(UIView *view in [self.districtView subviews])
    {
        [view removeFromSuperview];
    }
    
    NSArray *array = [NSArray array];
    
    NSArray *cityArray = [[LocationManager sharedManager] getCityArray];
    NSString *city = [[LocationManager sharedManager] getCity];
    NSString *district = [[LocationManager sharedManager] getDistrict];
    
    for (NSDictionary *dict in cityArray) {
        if ([dict[@"City"] isEqualToString:[NSString stringWithFormat:@"%@",city]]) {
            array = dict[@"DistrictArray"];
        }
    }
    
    if (array.count == 0) {
        UILabel *noDistrictLabel = [[UILabel alloc] initWithFrame:CGRectMake(kkViewWidth /2 - 50, 10, 100, 20)];
        noDistrictLabel.font = [UIFont systemFontOfSize:15];
        noDistrictLabel.textColor = [UIColor grayColor];
        noDistrictLabel.textAlignment = NSTextAlignmentCenter;
        noDistrictLabel.text = @"本市无区县";
        [self.districtView addSubview:noDistrictLabel];
    } else {
        
        CGFloat btnWidth = (kkViewWidth - 40 * KASAdapterSizeWidth)/3;
        CGFloat btnHeight = 25 * KASAdapterSizeHeight;
        CGFloat btnY = 25;
        
        for (int i = 0; i < array.count; i++) {
            CGFloat btnX = 10 * KASAdapterSizeWidth + (btnWidth + 10 * KASAdapterSizeWidth) * (i%3);
            if (i%3 == 0 && i >= 3) {
                btnY += btnHeight + 10 * KASAdapterSizeWidth;
            }
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)];
            btn.tag = 1000 + i;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = [UIColor grayColor].CGColor;
            btn.layer.cornerRadius = 2;
            btn.layer.borderWidth = 0.5;
            btn.titleLabel.font = [UIFont systemFontOfSize:15];;
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
            
            if ([array[i] isEqualToString:district] ) {
                btn.backgroundColor = [UIColor redColor];
            } else {
                btn.backgroundColor = [UIColor whiteColor];
            }
            
            [btn addTarget:self action:@selector(changeDistrict:) forControlEvents:UIControlEventTouchUpInside];
            [self.districtView addSubview:btn];
            if (i == array.count - 1) {
                self.districtView.frame = CGRectMake(0, 0, kkViewWidth, btn.frame.origin.y + btnHeight + 4);
            }
        }
    }
    self.cityView.frame = CGRectMake(0, self.districtView.frame.size.height, kkViewWidth, 60 * KASAdapterSizeWidth);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
