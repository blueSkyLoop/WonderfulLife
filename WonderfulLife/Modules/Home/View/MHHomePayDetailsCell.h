//
//  MHHomePayDetailsCell.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHUnpaySubjectModel,MHHoPayExpensesModel;

@interface MHHomePayDetailsCell : UITableViewCell
/**
 模型
 */
@property (strong,nonatomic) MHUnpaySubjectModel *unpayModel;
@property (nonatomic,strong) MHHoPayExpensesModel *paidModel;
@end
