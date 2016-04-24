//
//  SRBrowseLoadingView.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/24.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SRBrowseLoadingView.h"

@interface SRBrowseLoadingView ()

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation SRBrowseLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = NO;
}

- (void)transAnimation
{
    _angle += 6.0f;
    self.transform = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    if (_angle > 360.f) {
        _angle = 0;
    }
}

- (void)startAnimation
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(transAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    self.transform = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    self.hidden = NO;
}

- (void)stopAnimation
{
    [_timer invalidate];
    self.hidden = YES;
    self.transform = CGAffineTransformMakeRotation(0);
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"mss_browseLoading"];
    [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
}

@end
