//
//  MHStoreRefundOrderInforCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

@interface MHStoreRefundOrderInforCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *colorBgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *intergralPayLabel;

@end
