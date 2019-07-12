//
//  MHMineMerchantFuncCountruct.m
//  WonderfulLife
//
//  Created by Lucas on 17/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerchantFuncCountruct.h"

@implementation MHMineMerchantFuncCountruct

+ (NSArray *)merFuncWithSource:(MHMineMerchantInfoModel *)info {
    MHMineMerchantFunctiomModel *model_0 = [[MHMineMerchantFunctiomModel alloc] init];
    model_0.title = @"订单消费";
    model_0.imageName = @"Mine_mer_orderCost";
    model_0.type = MHMineMerchantType_orderCost;
    
    MHMineMerchantFunctiomModel *model_1 = [[MHMineMerchantFunctiomModel alloc] init];
    model_1.title = @"订单管理";
    model_1.imageName = @"Mine_mer_orderManagement";
    model_1.type = MHMineMerchantType_orderManagement;
    
    MHMineMerchantFunctiomModel *model_2 = [[MHMineMerchantFunctiomModel alloc] init];
    model_2.title = @"收款码";
    model_2.imageName = @"Mine_mer_QR";
    model_2.type = MHMineMerchantType_QR;
    
    MHMineMerchantFunctiomModel *model_3 = [[MHMineMerchantFunctiomModel alloc] init];
    model_3.title = @"处理退款";
    model_3.imageName = @"Mine_mer_reimburse";
    model_3.type = MHMineMerchantType_reimburse;
    
    MHMineMerchantFunctiomModel *model_4 = [[MHMineMerchantFunctiomModel alloc] init];
    model_4.title = @"财务报表";
    model_4.imageName = @"Mine_mer_financial";
    model_4.type = MHMineMerchantType_financial;
    
    MHMineMerchantFunctiomModel *model_5 = [[MHMineMerchantFunctiomModel alloc] init];
    model_5.title = @"扫码收款";
    model_5.imageName = @"Mine_mer_collection";
    model_5.type = MHMineMerchantType_collection;
    
    MHMineMerchantFunctiomModel *model_6 = [[MHMineMerchantFunctiomModel alloc] init];
    model_6.title = @"提现";
    model_6.imageName = @"Mine_mer_withdrawal";
    model_6.type = MHMineMerchantType_withdrawal;
    
    MHMineMerchantFunctiomModel *model_7 = [[MHMineMerchantFunctiomModel alloc] init];
    model_7.title = @"反馈意见";
    model_7.imageName = @"Mine_mer_idea";
    model_7.type = MHMineMerchantType_idea;
    
    MHMineMerchantFunctiomModel *model_8 = [[MHMineMerchantFunctiomModel alloc] init];
    model_8.title = @"客服电话";
    model_8.imageName = @"Mine_mer_call";
    model_8.type = MHMineMerchantType_call;
    

    return @[model_0,model_1,model_2,model_3,model_4,model_5,model_6,model_7];
    
    
}

@end



@implementation MHMineMerchantFunctiomModel

@end
