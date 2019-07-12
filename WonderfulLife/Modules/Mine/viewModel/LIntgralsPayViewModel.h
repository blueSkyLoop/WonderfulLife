//
//  LIntgralsPayViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "LIntegralsGoodsModel.h"

@interface LIntgralsPayViewModel : NSObject


@property (nonatomic,strong,readonly)RACCommand *payCommand;

@property (nonatomic,strong)LIntegralsGoodsModel *goodsModel;
@property (nonatomic,copy)NSString *password;


@end
