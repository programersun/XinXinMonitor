//
//  SRBrowseCollectionViewCell.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/24.
//  Copyright © 2016年 瑞孙. All rights reserved.
//
#import "SRBrowseCollectionViewCell.h"

@interface SRBrowseCollectionViewCell ()

@property (nonatomic,copy)SRBrowseCollectionViewCellTapBlock tapBlock;
@property (nonatomic,copy)SRBrowseCollectionViewCellLongPressBlock longPressBlock;

@end

@implementation SRBrowseCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    _zoomScrollView = [[SRImageBrowseZoomScrollView alloc]init];
    __weak __typeof(self)weakSelf = self;
    [_zoomScrollView tapClick:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.tapBlock(strongSelf);
    }];
    [self.contentView addSubview:_zoomScrollView];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kkViewWidth, 20)];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_addressLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kkViewWidth, 20)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
    
    CGFloat btnWidth = 44 * KASAdapterSizeWidth;
    _problemBtn = [[UIButton alloc] initWithFrame:CGRectMake(kkViewWidth - btnWidth - 40, kkViewHeight - btnWidth - 104, btnWidth, btnWidth)];
    _problemBtn.layer.masksToBounds = YES;
    _problemBtn.layer.cornerRadius = btnWidth / 2;
    _problemBtn.backgroundColor = [UIColor redColor];
    [_problemBtn addTarget:self action:@selector(problemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_problemBtn];
    
    _loadingView = [[SRBrowseLoadingView alloc]init];
    [_zoomScrollView addSubview:_loadingView];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [self.contentView addGestureRecognizer:longPressGesture];
}

- (void)problemBtnClick {
    if (self.ProblemBtnClickBlock) {
        self.ProblemBtnClickBlock();
    }
}

- (void)tapClick:(SRBrowseCollectionViewCellTapBlock)tapBlock
{
    _tapBlock = tapBlock;
}

- (void)longPress:(SRBrowseCollectionViewCellLongPressBlock)longPressBlock
{
    _longPressBlock = longPressBlock;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if(_longPressBlock)
    {
        if(gesture.state == UIGestureRecognizerStateBegan)
        {
            _longPressBlock(self);
        }
    }
}

@end
