//
//  MHVoSeReviewCell.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHVoSeReviewCellType) {
    MHVoSeReviewCellTypeReview,
    MHVoSeReviewCellTypeReviewed
};
@class MHVolSerReviewModel;

@interface MHVoSeReviewCell : UITableViewCell
@property (nonatomic, assign) MHVoSeReviewCellType cellType;
@property (nonatomic, strong) MHVolSerReviewModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
