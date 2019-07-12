//
//  MHMerchantOrderDetailReviewsCell.h
//  WonderfulLife
//
//  Created by zz on 25/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"
#import "MHMerchantOrderDelegate.h"

@interface MHMerchantOrderDetailReviewsCell : UITableViewCell<MHCellConfigDelegate>
@property (nonatomic,weak) id<MHMerchantOrderDelegate> delegate;
@end
