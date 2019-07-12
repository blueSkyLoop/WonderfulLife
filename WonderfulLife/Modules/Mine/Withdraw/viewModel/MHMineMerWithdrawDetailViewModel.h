//
//  MHMineMerWithdrawDetailViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"
#import "MHMineMerWithdrawDetailModel.h"

@interface MHMineMerWithdrawDetailViewModel : MHBaseViewModel

@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger total_pages;
@property (nonatomic,assign)BOOL has_next;

@property (nonatomic,copy)NSString *withdraw_no;

@property (nonatomic,strong)MHMineMerWithdrawDetailModel *detailModel;

//提现详情
@property (nonatomic,strong,readonly)RACCommand *widthdrawDetailCommand;

@end
