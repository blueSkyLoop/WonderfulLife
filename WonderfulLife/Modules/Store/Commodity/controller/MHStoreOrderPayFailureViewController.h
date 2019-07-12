//
//  MHStoreOrderPayFailureViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"

@interface MHStoreOrderPayFailureViewController : MHBaseViewController

@property (nonatomic,copy)void(^payFailureBlock)(NSInteger index);

@end
