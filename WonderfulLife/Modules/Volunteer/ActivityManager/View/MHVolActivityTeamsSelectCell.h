//
//  MHVolActivityTeamsSelectCell.h
//  WonderfulLife
//
//  Created by zz on 16/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVolActivityTeamsSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
