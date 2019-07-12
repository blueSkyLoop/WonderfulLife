//
//  MHVolDateSectionFooterView.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVolNoDataSectionFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *noDataLB;

+ (instancetype)volNoDataFooterViewWithTableView:(UITableView *)tableView;
@end
