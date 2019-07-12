//
//  MHVolDateSectionHeaderView.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//   用于服务时长 & 查看考勤

#import <UIKit/UIKit.h>


@interface MHVolDateSectionHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLB;


+ (instancetype)volDateHeaderViewWithTableView:(UITableView *)tableView;
@end
