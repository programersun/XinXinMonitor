//
//  HomeTopView.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/15.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTopViewDelegate <NSObject>

- (void)addressBtnClick;
- (void)mapBtnClick;
- (void)searchBtnClick;

@end

@interface HomeTopView : UIView

@property (weak, nonatomic) IBOutlet UIButton *addressArrowsBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressBtnWidth;
@property (weak, nonatomic) id<HomeTopViewDelegate>delegate;
+ (id)instance;
- (void)setAddressBtnTextWithString:(NSString *) addressText;
@end
