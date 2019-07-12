//
//  MHVolSerRefuseAlertView.h
//  WonderfulLife
//
//  Created by Beelin on 17/8/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureBlock)(NSString *reason);
@interface MHVolSerRefuseAlertView : UIView
/**
 *
 *
 *  @parma   title : 标题
 *  @parma   tipStr : 提示内容
 *
 *  @return  nil
 */

+ (instancetype)volSerRefuseAlertViewWithTitle:(NSString *)title tipStr:(NSString *)tipStr clickSureButtonBlock:(sureBlock)block;
@end
