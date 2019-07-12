//
//  MHMineMerTipView.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHMineMerTipView ;

typedef void(^tipViewDoSomeThing)(MHMineMerTipView * tipView);
typedef void(^attributedBlock)(MHMineMerTipView * tipView);

typedef NS_ENUM(NSInteger, MHMineMerTipViewType){
    
    /** 周边商家规则*/
    MerTipViewType_MerRules  = 0,
    
    /** 提示成为志愿者*/
    MerTipViewType_RegVolunteers
};

@interface MHMineMerTipView : UIView


+ (instancetype)mineMerTipView;

+ (instancetype)mineMerTipViewWithFrame:(CGRect)frame
                                Content:(NSString *)content
                               Attribut:(NSString *)attribut
                                TipType:(MHMineMerTipViewType)type
                           DostBtnTitle:(NSString *)btntitle
                     TipViewDoSomeThing:(tipViewDoSomeThing)blcok
                        AttributedBlock:(attributedBlock)attBlcok;

@end
