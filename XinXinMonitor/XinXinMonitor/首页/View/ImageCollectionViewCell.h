//
//  ImageCollectionViewCell.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorListRows.h"

@interface ImageCollectionViewCell : UICollectionViewCell

- (void)loadCellWithModel:(MonitorListRows *) model;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

@end
