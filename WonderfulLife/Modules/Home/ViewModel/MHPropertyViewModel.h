//
//  MHPropertyViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2018/1/3.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"
#import "MHStoreGoodPayModel.h"

@interface MHPropertyViewModel : MHBaseViewModel

@property (nonatomic,strong)MHStoreGoodPayModel *payModel;

//支付密码
@property (nonatomic,copy)NSString *password;

//1-支付宝,2-微信 (混合支付或第三方支付必填)
@property (assign, nonatomic)NSInteger payWay;

//是否选中抵扣积分
@property (nonatomic,assign)BOOL isSelectDeduction;

//积分是否能够抵扣所有的金额
@property (nonatomic,assign)BOOL enableDeductionAllAmount;


//显示在APP上的文本,例如:可使用积分100抵扣100元
@property (nonatomic,copy)NSString *usable_text;
//可抵扣积分
@property (nonatomic,copy)NSString *available_score;
//勾选后的文本,例如:已使用100积分抵扣100元
@property (nonatomic,copy)NSString *used_text;


// 查询可抵扣积分
- (void)startQueryIntergralDeductionRequest;

//支付宝支付参数请求
- (void)alipayRequest;

//微信支付参数请求
- (void)wechatPayRequest;

//商城商品支付宝微信支付参数请求
- (void)couponPayRequest;


@end
