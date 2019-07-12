//
//  MHMerchantOrderDetailStatusRefundingCell.h
//  WonderfulLife
//
//  Created by ikrulala on 2017/11/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"
#import "MHMerchantOrderDelegate.h"

@interface MHMerchantOrderDetailStatusRefundingCell : UITableViewCell<MHCellConfigDelegate>
@property (nonatomic,weak) id<MHMerchantOrderDelegate> delegate;
@end
