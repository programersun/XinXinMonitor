//
//  ImageDetailViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "SRBrowseCollectionViewCell.h"
#import "UIImage+SRScale.h"

#import "ImageDetailCollectionViewCell.h"

@interface ImageDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    NSString *_telephoneNumber;
}

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *browseItemArray;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)NSMutableArray *verticalBigRectArray;
@property (nonatomic,strong)NSMutableArray *horizontalBigRectArray;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)SRBrowseRemindView *browseRemindView;

@end

@implementation ImageDetailViewController

- (NSArray *)browseItemArray {
    if (!_browseItemArray) {
        _browseItemArray = [NSMutableArray array];
    }
    return _browseItemArray;
}

- (NSMutableArray *)verticalBigRectArray {
    if (!_verticalBigRectArray) {
        _verticalBigRectArray = [NSMutableArray array];
    }
    return _verticalBigRectArray;
}

- (NSMutableArray *)horizontalBigRectArray {
    if (!_horizontalBigRectArray) {
        _horizontalBigRectArray = [NSMutableArray array];
    }
    return _horizontalBigRectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self setNavigationRightItemWithString:@"筛选"];
    _telephoneNumber = @"18513600046";
//    self.telephoneBtn.layer.masksToBounds = YES;
//    self.telephoneBtn.layer.cornerRadius = 44 * KASAdapterSizeWidth / 2;
//    self.telephoneBtnWidth.constant = 44 * KASAdapterSizeWidth;
    
    NSArray *smallUrlArray = @[@"http://7xjtvh.com1.z0.glb.clouddn.com/browse01_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse02_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse03_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse04_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse05_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse06_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse07_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse08_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse09_s.jpg"];
    NSArray *bigUrlArray = @[@"http://7xjtvh.com1.z0.glb.clouddn.com/browse01.jpg",
                             @"http://7xjtvh.com1.z0.glb.clouddn.com/browse02.jpg",
                             @"http://7xjtvh.com1.z0.glb.clouddn.com/browse03.jpg",
                             @"http://7xjtvh.com1.z0.glb.clouddn.com/browse04.jpg",
                             @"http://7xjtvh.com1.z0.glb.clouddn.com/browse05.jpg",
                             @"http://7xjtvh.com1.z0.glb.clouddn.com/browse06.jpg",
                             @"http://7xjtvh.com1.z0.glb.clouddn.com/browse07.jpg",
                             @"http://7xjtvh.com1.z0.glb.clouddn.com/browse08.jpg",
                             @"http://7xjtvh.com1.z0.glb.clouddn.com/browse09.jpg"];
    
    for(int i = 0;i < [smallUrlArray count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        SRBrowseModel *browseItem = [[SRBrowseModel alloc]init];
        browseItem.bigImageUrl = bigUrlArray[i];// 大图url地址
        browseItem.smallImageView = imageView;// 小图
        [self.browseItemArray addObject:browseItem];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",smallUrlArray[i]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self initData];
        }];
    }
    
//    [self initData];
    [self createBrowseView];
    
    [self addTelephoneBtn];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 添加拍照按钮
- (void)addTelephoneBtn {
    CGFloat btnWidth = 44 * KASAdapterSizeWidth;
    UIButton *telephoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, kkViewHeight - btnWidth - 104, btnWidth, btnWidth)];
//    telephoneBtn.layer.masksToBounds = YES;
//    telephoneBtn.layer.cornerRadius = btnWidth / 2;
//    [telephoneBtn setImage:[UIImage imageNamed:@"cameraImg"] forState:UIControlStateNormal];
    [telephoneBtn setBackgroundImage:[UIImage imageNamed:@"cameraImg"] forState:UIControlStateNormal];
    [telephoneBtn addTarget:self action:@selector(telephoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telephoneBtn];
}

- (void)initData
{
    _verticalBigRectArray = [[NSMutableArray alloc]init];
    _horizontalBigRectArray = [[NSMutableArray alloc]init];
    for (SRBrowseModel *browseItem in _browseItemArray)
    {
        CGRect verticalRect = [browseItem.smallImageView.image mss_getBigImageRectSizeWithScreenWidth:kkViewWidth screenHeight:kkViewHeight];
        NSValue *verticalValue = [NSValue valueWithCGRect:verticalRect];
        [_verticalBigRectArray addObject:verticalValue];
        
        CGRect horizontalRect = [browseItem.smallImageView.image mss_getBigImageRectSizeWithScreenWidth:kkViewHeight screenHeight:kkViewWidth];
        NSValue *horizontalValue = [NSValue valueWithCGRect:horizontalRect];
        [_horizontalBigRectArray addObject:horizontalValue];
    }
    [_collectionView reloadData];
}

- (void)createBrowseView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    _bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    // 布局方式改为从上至下，默认从左到右
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // Section Inset就是某个section中cell的边界范围
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 每行内部cell item的间距
    flowLayout.minimumInteritemSpacing = 0;
    // 每行的间距
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth + kBrowseSpace, kkViewHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
//    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor blackColor];
    [_collectionView registerClass:[SRBrowseCollectionViewCell class] forCellWithReuseIdentifier:@"SRBrowseCollectionViewCell"];
    [_bgView addSubview:_collectionView];
    
    _browseRemindView = [[SRBrowseRemindView alloc]initWithFrame:_bgView.bounds];
    [_bgView addSubview:_browseRemindView];
    
}

// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view
{
    // 改用[UIApplication sharedApplication].keyWindow.rootViewController.view，防止present新viewController坐标转换不准问题
    return [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

#pragma mark - 拍照
- (void)telephoneBtnClick:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@进行拍照",_telephoneNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    [alert show];
}

- (void)rightBtnClick:(UIButton *)sender {
    
}

- (void)showBigImage:(UIImageView *)imageView browseItem:(SRBrowseModel *)browseItem rect:(CGRect)rect
{
    // 取消当前请求防止复用问题
    [imageView sd_cancelCurrentImageLoad];
    // 如果存在直接显示图片
    imageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:browseItem.bigImageUrl];
    imageView.frame = rect;
}

#pragma mark - 加载大图
- (void)loadBigImageWithBrowseItem:(SRBrowseModel *)browseItem cell:(SRBrowseCollectionViewCell *)cell rect:(CGRect)rect
{
    UIImageView *imageView = cell.zoomScrollView.zoomImageView;
    // 加载圆圈显示
    [cell.loadingView startAnimation];
    // 默认为屏幕中间
    [imageView mss_setFrameInSuperViewCenterWithSize:CGSizeMake(browseItem.smallImageView.mssWidth, browseItem.smallImageView.mssHeight)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:browseItem.bigImageUrl] placeholderImage:browseItem.smallImageView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 关闭图片浏览view的时候，不需要继续执行小图加载大图动画
        if(_collectionView.userInteractionEnabled)
        {
            // 停止加载
            [cell.loadingView stopAnimation];
            if(error)
            {
                [self showBrowseRemindViewWithText:@"图片加载失败"];
            }
            else
            {
                // 图片加载成功
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.frame = rect;
                }];
            }
        }
    }];
}

#pragma mark RemindView Method
- (void)showBrowseRemindViewWithText:(NSString *)text
{
    [_browseRemindView showRemindViewWithText:text];
    _bgView.userInteractionEnabled = NO;
    [self performSelector:@selector(hideRemindView) withObject:nil afterDelay:0.7];
}

- (void)hideRemindView
{
    [_browseRemindView hideRemindView];
    _bgView.userInteractionEnabled = YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _browseItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SRBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SRBrowseCollectionViewCell" forIndexPath:indexPath];
    if(cell)
    {
        // 停止加载
        [cell.loadingView stopAnimation];
        
        SRBrowseModel *browseItem = [_browseItemArray objectAtIndex:indexPath.row];
        // 还原初始缩放比例
        cell.zoomScrollView.frame = CGRectMake(0, 0, kkViewWidth, kkViewHeight);
        cell.zoomScrollView.zoomScale = 1.0f;
        // 将scrollview的contentSize还原成缩放前
        cell.zoomScrollView.contentSize = CGSizeMake(kkViewWidth, kkViewHeight);
        cell.zoomScrollView.zoomImageView.contentMode = browseItem.smallImageView.contentMode;
        cell.zoomScrollView.zoomImageView.clipsToBounds = browseItem.smallImageView.clipsToBounds;
        [cell.loadingView mss_setFrameInSuperViewCenterWithSize:CGSizeMake(30, 30)];
        CGRect bigImageRect = [_verticalBigRectArray[indexPath.row] CGRectValue];
        // 判断大图是否存在
        if([[SDImageCache sharedImageCache]diskImageExistsWithKey:browseItem.bigImageUrl])
        {
            // 显示大图
            [self showBigImage:cell.zoomScrollView.zoomImageView browseItem:browseItem rect:bigImageRect];
        }
        // 如果大图不存在
        else
        {
            // 加载大图
            [self loadBigImageWithBrowseItem:browseItem cell:cell rect:bigImageRect];
        }
        __weak __typeof(self)weakSelf = self;
        [cell tapClick:^(SRBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf tap:browseCell];
        }];
        [cell longPress:^(SRBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if([[SDImageCache sharedImageCache]diskImageExistsWithKey:browseItem.bigImageUrl])
            {
                [strongSelf longPress:browseCell];
            }
        }];
        
        cell.addressLabel.text = @"设备地址";
        cell.timeLabel.text = @"2016.04.20 12:00:00";
        
        cell.ProblemBtnClickBlock = ^{
            NSLog(@"%ld",indexPath.row);
        };
    }
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kkViewWidth + kBrowseSpace, kkViewHeight);
}

#pragma mark 图片点击事件
- (void)tap:(SRBrowseCollectionViewCell *)browseCell
{

}

#pragma mark 图片长按事件
- (void)longPress:(SRBrowseCollectionViewCell *)browseCell {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除这张照片,删除后不可恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1002;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1001) {
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",_telephoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
        if (alertView.tag == 1002) {
            
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scollX = scrollView.contentOffset.x;
    
    if (scollX < -100) {
        NSLog(@"AAAA");
    }
    if (scollX > scrollView.contentSize.width + 100) {
        NSLog(@"BBBB");
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
