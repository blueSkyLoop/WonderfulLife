//
//  MHActivityModifyPeoplesCell.h
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHActivityModifyPeoplesCell : UITableViewCell
@property (strong,nonatomic) NSDictionary *model;
@property (assign,nonatomic) NSInteger  selectedNumber;
@property (nonatomic, copy) void(^clickBlock)(NSInteger selectedNumber);

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
