//
//  MHMineMerPayComView.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
@class MHMineMerchantPayModel ;
@interface MHMineMerPayComView : UIView

@property (nonatomic,strong)RACSubject *doneSubject;


+ (MHMineMerPayComView *)loadViewFromXib:(MHMineMerchantPayModel *)model;
@end
