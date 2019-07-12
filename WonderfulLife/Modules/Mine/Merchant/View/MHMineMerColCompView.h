//
//  MHMineMerColCompView.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/2.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "MHMerPayIncomEnumResult.h"

@class MHMineMerchantPayModel ;
@interface MHMineMerColCompView : UIView
@property (nonatomic,strong)RACSubject *paySubject;

//@property (weak, nonatomic) IBOutlet UILabel *statusLab;
//
//@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

/** 收款时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
+ (MHMineMerColCompView *)loadViewFromXib:(MHMineMerchantPayModel *)model resultType:(MerColResultType)type;

@end
