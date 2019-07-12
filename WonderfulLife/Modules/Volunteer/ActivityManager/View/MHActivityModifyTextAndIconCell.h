//
//  MHActivityModifyTextAndIconCell.h
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHActivityModifyTextAndIconCell : UITableViewCell
@property (strong,nonatomic) NSDictionary *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
