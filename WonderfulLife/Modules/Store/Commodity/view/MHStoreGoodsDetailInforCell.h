//
//  MHStoreGoodsDetailInforCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"
#import "XHStarRateView.h"

@interface MHStoreGoodsDetailInforCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIView *evaluateBgView;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UIView *merchantBgView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceTopLaout;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (nonatomic,strong)XHStarRateView *starView;

//点击商家
@property (nonatomic,copy)void(^merchantClikBlock)(void);


@end
