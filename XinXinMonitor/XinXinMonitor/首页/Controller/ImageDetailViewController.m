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
#import "TimeView.h"
#import "ImageDetailRows.h"
#import "ImageDetailBaseClass.h"

@interface ImageDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    NSInteger _pageNum;
    NSInteger _pageTotal;
    NSInteger _deleteIndex;
    NSInteger _cancelProblemIndex;
    BOOL _isRefresh;
}

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *browseItemArray;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSMutableArray *verticalBigRectArray;
@property (nonatomic,strong) NSMutableArray *horizontalBigRectArray;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) SRBrowseRemindView *browseRemindView;
@property (nonatomic,strong) TimeView *timeView;                        /**< 时间选择*/
@property (nonatomic,strong) ImageDetailBaseClass *imageDetalBaseClass;
@property (nonatomic,strong) NSMutableArray *imageListArray;
@property (nonatomic,strong) NSString *timeString;                      /**< 时间*/

@end

@implementation ImageDetailViewController

- (NSMutableArray *)browseItemArray {
    if (!_browseItemArray) {
        _browseItemArray = [NSMutableArray array];
    }
    return _browseItemArray;
}

- (NSMutableArray *)imageListArray {
    if (!_imageListArray) {
        _imageListArray = [NSMutableArray array];
    }
    return _imageListArray;
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
    
    _pageNum = 1;
    _pageTotal = 0;
    _isRefresh = NO;
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    self.timeString = [dateformatter stringFromDate:nowDate];
    [self setNavigationTitle:self.monitorCode TextColor:[UIColor whiteColor] Font:nil];
    
    [self createBrowseView];
    [self addTelephoneBtn];
    self.timeView = [[TimeView alloc] init];
    self.timeView.hidden = YES;
    __weak ImageDetailViewController *weakself = self;
    self.timeView.pickerBtnClickBlock = ^{
        [weakself chooseTime];
    };
    [self.view addSubview:self.timeView];
    
    [self loadImageList];
    // Do any additional setup after loading the view.
}

#pragma mark - 加载图片
- (void)showImage:(NSArray *)imageArray {
    
    [self showSVProgressHUD];
    
    [self.browseItemArray removeAllObjects];
    __block int num = 0;
    for(int i = 0; i < imageArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        SRBrowseModel *browseItem = [[SRBrowseModel alloc]init];
        browseItem.bigImageUrl = imageArray[i];// 大图url地址
        browseItem.smallImageView = imageView;// 小图
        [self.browseItemArray addObject:browseItem];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageArray[i]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            num ++;
            if (num >= imageArray.count) {
                [self initData];
            }
        }];
    }
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
    [self hideSVProgressHUD];
    [_collectionView reloadData];
}

#pragma mark - 获取图片列表
- (void)loadImageList {
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,ImageListAPI] params:[XinXinMonitorAPI ImageList:self.monitorId page:_pageNum startTime:self.timeString endTime:self.timeString] success:^(id responseObj) {
        
        NSDictionary *dic = responseObj;
        
        self.imageDetalBaseClass = [[ImageDetailBaseClass alloc] initWithDictionary:dic];
        _pageTotal = self.imageDetalBaseClass.pagenums;
        if (_pageNum == 1) {
            [self.imageListArray removeAllObjects];
        }
        for (ImageDetailRows *row in self.imageDetalBaseClass.rows) {
            [self.imageListArray addObject:row];
        }
        
        if (self.imageListArray.count == 0) {
            [self showMessageWithString:@"暂无图片" showTime:1.0];
        } else {
            NSMutableArray *imageArray = [NSMutableArray array];
            for (ImageDetailRows *row in self.imageListArray) {
                [imageArray addObject:[NSString stringWithFormat:@"%@%@",XinXinMonitorIMGURL,row.url]];
            }
            
            [self showImage:imageArray];
        }
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            _isRefresh = NO;
        });
    } failure:^(NSError *error) {
        _isRefresh = NO;
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}

#pragma mark - 删除图片

- (void)deleteImage {
    [self showSVProgressHUD];
    ImageDetailRows *model = self.imageListArray[_deleteIndex];
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,DeleteImageAPI] params:[XinXinMonitorAPI deleteImage:model.pkid] success:^(id responseObj) {
        
        NSDictionary *dict = responseObj;
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            [self.imageListArray removeObjectAtIndex:_deleteIndex];
            NSMutableArray *imageArray = [NSMutableArray array];
            for (ImageDetailRows *row in self.imageListArray) {
                [imageArray addObject:[NSString stringWithFormat:@"%@%@",XinXinMonitorIMGURL,row.url]];
            }
            [self showImage:imageArray];
        }
        [self showMessageWithString:[dict objectForKey:@"message"] showTime:1.0];
        
    } failure:^(NSError *error) {
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}

#pragma mark - 取消问题图片
- (void)cancelProblem {
    [self showSVProgressHUD];
    ImageDetailRows *model = self.imageListArray[_cancelProblemIndex];
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,cancelProblemImageAPI] params:[XinXinMonitorAPI CancelProblemImage:model.pkid] success:^(id responseObj) {
        
        NSDictionary *dict = responseObj;
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            model.usersetResult = 1;
            [self.imageListArray replaceObjectAtIndex:_cancelProblemIndex withObject:model];
            [self.collectionView reloadData];
        }
        [self showMessageWithString:[dict objectForKey:@"message"] showTime:1.0];
        
    } failure:^(NSError *error) {
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}

#pragma mark - 时间筛选
- (void)chooseTime {
    if (self.timeView.hidden) {
        self.timeView.hidden = NO;
    }else {
        self.timeView.hidden = YES;
        //加载数据
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString *timeString = [dateformatter stringFromDate:self.timeView.datePicker.date];
        self.timeString = timeString;
        [self loadImageList];
    }
}

#pragma mark - 添加拍照按钮
- (void)addTelephoneBtn {
    CGFloat btnWidth = 44 * KASAdapterSizeWidth;
    UIButton *telephoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, kkViewHeight - btnWidth - 104, btnWidth, btnWidth)];
    [telephoneBtn setBackgroundImage:[UIImage imageNamed:@"cameraImg"] forState:UIControlStateNormal];
    [telephoneBtn addTarget:self action:@selector(telephoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telephoneBtn];
}

#pragma mark - 创建collectionView
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@进行拍照",self.telephone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    [alert show];
}

- (void)rightBtnClick:(UIButton *)sender {
    [self chooseTime];
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
        
        cell.tag = indexPath.row;
        cell.addressLabel.text = self.address;
        
        ImageDetailRows *model = self.imageListArray[indexPath.row];
        cell.timeLabel.text = model.pictureTime;
        
        if (model.usersetResult == 2) {
            cell.problemBtn.hidden = NO;
            cell.ProblemBtnClickBlock = ^{
                _cancelProblemIndex = indexPath.row;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认照片安全或排除故障后排除问题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 1003;
                [alert show];
            };
        } else {
            cell.problemBtn.hidden = YES;
        }
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
    _deleteIndex = browseCell.tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除这张照片,删除后不可恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1002;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1001) {
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.telephone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
        if (alertView.tag == 1002) {
            [self deleteImage];
        }
        if (alertView.tag == 1003) {
            [self cancelProblem];
        }

    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scollX = scrollView.contentOffset.x;
    
    if (scollX < -100 && !_isRefresh) {
        _isRefresh = YES;
        _pageNum = 1;
        [self loadImageList];
    }
    if (scollX > scrollView.contentSize.width + 50 - kkViewWidth && !_isRefresh ) {
        
        if ( _pageNum < _pageTotal) {
            _isRefresh = YES;
            _pageNum ++;
            NSLog(@"%ld",(long)_pageNum);
            [self loadImageList];
        } else {
            [self showMessageWithString:@"已加载全部图片" showTime:1.0];
        }
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
