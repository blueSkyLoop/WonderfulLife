//
//  MHStoreRefundRemarkCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

#import "MHPlaceholderTextView.h"

@interface MHStoreRefundRemarkCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthLayout;

@property (weak, nonatomic) IBOutlet MHPlaceholderTextView *textView;

@end
