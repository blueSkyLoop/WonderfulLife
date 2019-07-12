//
//  MHVolSerDetailTableFooterView.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MHVolSerDetailFootButtonCallBack)(void);

@interface MHVolSerDetailTableFooterView : UIView
+ (instancetype)awakeFromNibWithButtonEvent:(MHVolSerDetailFootButtonCallBack)buttonEvent;


/** 退出 || 撤回*/
+ (instancetype)awakeFromNibExitWithBtnTitle:(NSString *)title buttonEvent:(MHVolSerDetailFootButtonCallBack)buttonEvent;

@end
