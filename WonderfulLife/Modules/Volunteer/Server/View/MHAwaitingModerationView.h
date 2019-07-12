//
//  MHAwaitingModerationView.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MHAwaitingModerationViewResultType){
    /**
     *  审核中
     */
    MHAwaitingModerationViewResultTypAwaiting  = 0,
    /**
     *  已退出队伍
     */
    MHAwaitingModerationViewResultTypeLeave = 3
};
@interface MHAwaitingModerationView : UIView



+ (instancetype)awakeFromNib:(MHAwaitingModerationViewResultType)type;

@end
