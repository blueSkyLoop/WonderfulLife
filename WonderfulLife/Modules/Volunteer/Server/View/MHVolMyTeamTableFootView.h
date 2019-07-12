//
//  MHVolMyTeamTableFootView.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MHVolTeamFootButtonCallBack)(void);
@interface MHVolMyTeamTableFootView : UIView
+ (instancetype)viewWithOutButton;
+ (instancetype)viewWithBtnTitle:(NSString *)text buttonAction:(MHVolTeamFootButtonCallBack)buttonAction;
@end
