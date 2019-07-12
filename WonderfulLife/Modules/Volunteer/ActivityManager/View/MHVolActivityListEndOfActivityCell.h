//
//  MHVolActivityListResultCell.h
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolActivityListViewModel,MHVolActivityListDataViewModel;
@interface MHVolActivityListEndOfActivityCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setModel:(MHVolActivityListDataViewModel*)model viewModel:(MHVolActivityListViewModel*)viewModel;
@end
