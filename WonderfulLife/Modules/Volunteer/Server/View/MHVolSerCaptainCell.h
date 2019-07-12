//
//  MHVolSerCaptainCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHVolSerCaptainCallDelegate <NSObject>

@optional
- (void)CaptainCellDidClickCallButtonAtIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)phoneBtn;
- (void)CaptainCellDidClickHeadViewAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface MHVolSerCaptainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mh_imageView;
@property (weak, nonatomic) IBOutlet UILabel *mh_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_subTitleLabel;
@property (copy,nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak,nonatomic) id<MHVolSerCaptainCallDelegate> delegate;
@end
