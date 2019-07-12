//
//  MHMerchantOrderDetailPicturesCell.h
//  WonderfulLife
//
//  Created by ikrulala on 2017/11/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"
#import "MHMerchantOrderDelegate.h"

@interface MHMerchantOrderDetailPicturesCell : UITableViewCell<MHCellConfigDelegate>
@property (nonatomic,weak) id<MHMerchantOrderDelegate> delegate;

@end
