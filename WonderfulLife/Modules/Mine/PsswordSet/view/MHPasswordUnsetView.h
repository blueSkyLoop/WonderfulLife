//
//  MHPasswordUnsetView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

@interface MHPasswordUnsetView : UIView

@property (nonatomic,strong,readonly)RACSubject *passwordSetSubject;

@end
