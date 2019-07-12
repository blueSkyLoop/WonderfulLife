//
//  MHMineMerWithdrawApplyViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"
#import "MHMineMerWithDrawViewModel.h"

@interface MHMineMerWithdrawApplyViewController : MHBaseViewController

@property (nonatomic,strong)RACSubject *applySuccessSubject;

- (id)initWithWithdrawModel:(MHMinMerWithdrawMainModel *)model;

@end
