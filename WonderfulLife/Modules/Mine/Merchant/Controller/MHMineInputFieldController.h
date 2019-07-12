//
//  MHMineScanCodeColController.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//   商家，扫码收款,手动输码

#import <UIKit/UIKit.h>
@class MHMineMerchantPayModel ;
typedef NS_ENUM(NSInteger, MHMineInputFieldType){
    
    /** */
    MHMineInputFieldType_ScanQRCol  = 0, // 扫码收款
    
    /** */
    MHMineInputFieldType_InputQR  // 手动输码
};
@interface MHMineInputFieldController : UIViewController

@property (nonatomic, assign) MHMineInputFieldType type;

@property (nonatomic, strong) NSMutableDictionary  *parma;
/**
 *  initViewController
 *
 *  @parma   type : 扫码收款 or 手动输码
 *
 *  @return  instancetype
 */
- (instancetype)initWithInputType:(MHMineInputFieldType)type parma:(NSMutableDictionary *)parma;

@end
