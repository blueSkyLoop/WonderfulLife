//
//  MHMineMerWithDrawViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"
#import "MHMinMerWithdrawMainModel.h"

@interface MHMineMerWithDrawViewModel : MHBaseViewModel

@property (nonatomic,copy)NSString *withdraw_no;

@property (nonatomic,assign)BOOL refreshFlag;

//提现模块-主页
@property (nonatomic,strong,readonly)RACCommand *widthDrawMainCommand;
//申请提现
@property (nonatomic,strong,readonly)RACCommand *applyWidthDraCommand;

@property (nonatomic,strong)MHMinMerWithdrawMainModel *withDrawModel;

@end
