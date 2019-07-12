//
//  MHVoMyCardCell.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/8/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerMyCardCell.h"
#import "MHVolSerMyCardModel.h"
#import "MHUserInfoManager.h"
#import "PYPhotosView.h"

@interface MHVolSerMyCardCell()
@property (weak, nonatomic) IBOutlet UILabel *titileLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet PYPhotosView *headImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailConstraint;
@end

@implementation MHVolSerMyCardCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVolSerMyCardCellId";
    MHVolSerMyCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVolSerMyCardCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)setModel:(MHVolSerMyCardModel *)model {
    self.titileLbl.text = model.title;

    switch (model.type) {
        case MHVoMyCardCellNormal:{
            self.headImg.hidden = YES;
            self.arrowImg.hidden = NO;
            self.detailLbl.hidden = NO;
            self.detailConstraint.constant = 36;
            self.detailLbl.text = [NSString stringWithFormat:@"%@",model.content];
            break;}
        case MHVoMyCardCellWithoutArrow:{
            self.headImg.hidden = YES;
            self.arrowImg.hidden = YES;
            self.detailLbl.hidden = NO;
            self.detailConstraint.constant = 20;
            self.detailLbl.text = [NSString stringWithFormat:@"%@",model.content];
            break;}
        case MHVoMyCardCellWithHeaderImg:{
            self.headImg.hidden = NO;
            self.arrowImg.hidden = NO;
            self.detailLbl.hidden = YES;
            
            if ([MHUserInfoManager sharedManager].volUserInfo.user_s_img) {
                self.headImg.thumbnailUrls = @[[MHUserInfoManager sharedManager].volUserInfo.user_s_img];
                self.headImg.originalUrls = @[[MHUserInfoManager sharedManager].volUserInfo.user_img];
            }
           
            break;
        }
    }
    
    [self layoutIfNeeded];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    //头像设置圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headImg.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.headImg.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headImg.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headImg.layer.mask = maskLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
