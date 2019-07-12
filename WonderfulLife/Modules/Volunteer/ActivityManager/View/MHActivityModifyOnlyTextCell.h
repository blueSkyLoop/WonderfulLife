//
//  MHActivityModifyOnlyTextCell.h
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHActivityModifyOnlyTextCell : UITableViewCell
@property (strong,nonatomic) NSDictionary *model;
@property (assign,nonatomic) BOOL  boldFont;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
