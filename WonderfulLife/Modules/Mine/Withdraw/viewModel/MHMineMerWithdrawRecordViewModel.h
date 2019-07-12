//
//  MHMineMerWithdrawRecordViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

@interface MHMineMerWithdrawRecordViewModel : MHBaseViewModel

@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger total_pages;
@property (nonatomic,assign)BOOL has_next;

//申请记录
@property (nonatomic,strong,readonly)RACCommand *widthdrawRecordCommand;

@end
