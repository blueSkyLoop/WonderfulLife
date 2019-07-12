//
//  LIntegralsPayViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"
#import "MHNavigationControllerManager.h"

@interface LIntegralsPayViewController : MHBaseViewController<MHNavigationControllerManagerProtocol>

@property (nonatomic,strong)id goodsInfor;

@property (nonatomic,assign)BOOL showPayAlert;

@end
