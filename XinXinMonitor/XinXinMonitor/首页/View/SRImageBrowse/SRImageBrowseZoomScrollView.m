//
//  SRImageBrowseZoomScrollView.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/24.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SRImageBrowseZoomScrollView.h"

@interface SRImageBrowseZoomScrollView ()

@property (nonatomic,copy)SRImageBrowseZoomScrollViewTapBlock tapBlock;
@property (nonatomic,assign)BOOL isSingleTap;

@end

@implementation SRImageBrowseZoomScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createZoomScrollView];
    }
    return self;
}

- (void)createZoomScrollView
{
    self.delegate = self;
    _isSingleTap = NO;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 3.0f;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    _zoomImageView = [[UIImageView alloc]init];
    _zoomImageView.userInteractionEnabled = YES;
    [self addSubview:_zoomImageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 延中心点缩放
    CGRect rect = _zoomImageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    if (rect.size.width < self.mssWidth) {
        rect.origin.x = floorf((self.mssWidth - rect.size.width) / 2.0);
    }
    if (rect.size.height < self.mssHeight) {
        rect.origin.y = floorf((self.mssHeight - rect.size.height) / 2.0);
    }
    _zoomImageView.frame = rect;
}

- (void)tapClick:(SRImageBrowseZoomScrollViewTapBlock)tapBlock
{
    _tapBlock = tapBlock;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    if(touch.tapCount == 1)
    {
        [self performSelector:@selector(singleTapClick) withObject:nil afterDelay:0.17];
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        // 防止先执行单击手势后还执行下面双击手势动画异常问题
        if(!_isSingleTap)
        {
            CGPoint touchPoint = [touch locationInView:_zoomImageView];
            [self zoomDoubleTapWithPoint:touchPoint];
        }
    }
}

- (void)singleTapClick
{
    _isSingleTap = YES;
    if(_tapBlock)
    {
        _tapBlock();
    }
}

- (void)zoomDoubleTapWithPoint:(CGPoint)touchPoint
{
    if(self.zoomScale > self.minimumZoomScale)
    {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else
    {
        CGFloat width = self.bounds.size.width / self.maximumZoomScale;
        CGFloat height = self.bounds.size.height / self.maximumZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - width / 2, touchPoint.y - height / 2, width, height) animated:YES];
    }
}

@end
