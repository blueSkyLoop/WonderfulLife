//
//  MHReportRepairPhotoPreviewCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

@interface MHReportRepairPhotoPreviewCell : UICollectionViewCell<MHCellConfigDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *ascrollView;
@property (weak, nonatomic) IBOutlet UIImageView *picTureView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

//有没有添加手势
@property (nonatomic,assign)BOOL isAddGes;

-(void)showIndicator;
-(void)hideIndicator;

@end
