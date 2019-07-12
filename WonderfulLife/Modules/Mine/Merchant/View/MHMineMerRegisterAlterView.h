//
//  MHMineMerRegisterAlterView.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHMineMerRegisterAlterView ;


typedef void(^RegisterAlterBlock)(MHMineMerRegisterAlterView * tipView);
@interface MHMineMerRegisterAlterView : UIView
typedef NS_ENUM(NSInteger, MHMineMerRegisterAlterViewType){
    
    /** 周边商家规则*/
    MerRegisterAlterViewType_MerRules  = 0,
    
    /** 提示成为志愿者*/
    MerRegisterAlterViewType_RegVolunteers
};

+ (instancetype)mineMerRegisterAlterView;

+ (instancetype)mineMerRegisterAlterViewWithFrame:(CGRect)frame
                                Content:(NSString *)content
                               Attribut:(NSString *)attribut
                                TipType:(MHMineMerRegisterAlterViewType)type
                        AttributedBlock:(RegisterAlterBlock)attBlcok;

@end
