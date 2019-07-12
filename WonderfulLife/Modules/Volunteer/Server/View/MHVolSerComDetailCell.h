//
//  MHVolSerComDetailCell.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVolSerComDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLB;
@property (weak, nonatomic) IBOutlet UILabel *rightLB;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end
