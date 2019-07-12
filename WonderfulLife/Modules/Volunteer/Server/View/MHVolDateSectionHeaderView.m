//
//  MHVolDateSectionHeaderView.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolDateSectionHeaderView.h"
#import "MHMacros.h"
@interface MHVolDateSectionHeaderView ()


@end

@implementation MHVolDateSectionHeaderView

+ (instancetype)volDateHeaderViewWithTableView:(UITableView *)tableView{
    static NSString *viewID = @"MHVolDateSectionHeaderView";
    
    MHVolDateSectionHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewID];
    
    if (!view) {
         [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forHeaderFooterViewReuseIdentifier:viewID];
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewID];
    }
    view.contentView.backgroundColor =MColorToRGB(0xF9FAFC);
    return view ;
}


@end
