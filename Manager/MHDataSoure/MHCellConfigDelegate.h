//
//  MHCellConfigDelegate.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MHCellConfigDelegate <NSObject>

@required
- (void)mh_configCellWithInfor:(id)model;

@end
