//
//  MHVolDateSectionFooterView.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolNoDataSectionFooterView.h"

@implementation MHVolNoDataSectionFooterView

+ (instancetype)volNoDataFooterViewWithTableView:(UITableView *)tableView{
    static NSString *viewID = @"MHVolNoDataSectionFooterView";
    
    MHVolNoDataSectionFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewID];
    
    if (!view) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forHeaderFooterViewReuseIdentifier:viewID];
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewID];
    }
    view.contentView.backgroundColor = [UIColor whiteColor];
    return view ;
}

@end
