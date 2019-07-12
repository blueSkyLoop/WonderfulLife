//
//  UITableView+MHAutoHeaderAndFooterView.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTableHeaderFooterHander.h"

@interface UITableView (MHAutoHeaderAndFooterView)

/*
 这个不是view,是执行者，真正加载的view是执行者中的tableHeaderFooterView
 */
@property (nonatomic,strong)MHTableHeaderFooterHander *mh_tableHeader;
@property (nonatomic,strong)MHTableHeaderFooterHander *mh_tableFooter;

@end
