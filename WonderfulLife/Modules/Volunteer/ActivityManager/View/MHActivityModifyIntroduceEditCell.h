//
//  MHActivityModifyEditCell.h
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHActivityModifyIntroduceEditCell : UITableViewCell
@property (copy,nonatomic)NSString *introduce;
@property (nonatomic, copy) void(^clickBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
