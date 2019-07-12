//
//  MHMerchantOrderPaidCell.h
//  WonderfulLife
//
//  Created by zz on 24/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"
#import "MHMerchantOrderCellContentView.h"

@protocol MHMerchantListOrderCellDelegate <NSObject>
@required
- (void)mh_merchantListOrderCell:(UITableViewCell*)cell didSelectRow:(id)data;
- (void)mh_merchantListOrderCell:(UITableViewCell*)cell didSelectDeleteButton:(id)data;

- (void)mh_merchantListOrderCell:(UITableViewCell*)cell didSelectRowToPaid:(id)data;
- (void)mh_merchantListOrderCell:(UITableViewCell*)cell didSelectToQRCode:(id)data;
@end

@interface MHMerchantOrderListCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) id<MHMerchantListOrderCellDelegate> delegate;
@property (strong,nonatomic) MHMerchantOrderCellContentView *goodsView;
@property (assign,nonatomic) BOOL isMerchantList;

@end
