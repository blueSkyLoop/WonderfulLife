//
//  UIViewController+MHAddRightBarButtonItem.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MHAddRightBarButtonItem)

/**
 *  addRightBarButtonItem
 *  button 的方法，需要在VC里实现
 */

- (UIButton *)mh_addRightBarButtonItemWithTitle:(NSString *)title;

@end
