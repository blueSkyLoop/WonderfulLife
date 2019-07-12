//
//  MHMerPayIncomEnumResult.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#ifndef MHMerPayIncomEnumResult_h
#define MHMerPayIncomEnumResult_h
typedef NS_ENUM(NSInteger, MerColResultType){
    
    /** 收款成功 */
    MerColResultType_CompIncome  = 0,
    
    /** 收款失败 */
    MerColResultType_FailureIncome ,

    /** 支付成功 */
    MerColResultType_CompPay ,
    
    /** 支付失败 */
    MerColResultType_FailurePay
    

    
};
#endif /* MHMerPayIncomEnumResult_h */
