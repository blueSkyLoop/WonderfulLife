//
//  MHMineMerchantViewModel.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import <YYModel.h>

@class MHMineMerchantInfoModel ;
@interface MHMineMerchantViewModel : NSObject

@property (nonatomic,strong)NSMutableArray *dataSoure;

@property (nonatomic, strong) MHMineMerchantInfoModel  *infoModel;

/** 获取商家数据*/
@property (nonatomic,strong,readonly)RACCommand *serverCommand;

@property (nonatomic,strong,readonly)RACSubject *refreshSubject;


@end
