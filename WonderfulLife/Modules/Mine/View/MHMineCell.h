//
//  MHMineCell.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHMineCell : UITableViewCell
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *detailLabel;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,weak) UIImageView *arrowView;
@property (nonatomic, strong) UISwitch *swi;

- (void)setIconWithUrl:(NSString *)user_s_img;

@end
