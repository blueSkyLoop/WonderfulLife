//
//  MHVoSeReviewCell.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeReviewCell.h"
#import "MHVolSerReviewModel.h"
#import "UIView+MHFrame.h"
#import "MHMacros.h"
#import "UIImageView+WebCache.h"
@interface MHVoSeReviewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *applyDate;
@property (weak, nonatomic) IBOutlet UILabel *applySerTeam;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation MHVoSeReviewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVoSeReviewCellId";
    MHVoSeReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVoSeReviewCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    return cell;
}

- (void)setFrame:(CGRect)frame {
    CGRect f = frame;
    f.origin.x = 24;
    f.origin.y += 11;
    f.size.width -= 48;
    f.size.height -= 11;
    frame = f;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
    self.layer.borderColor = MColorSeparator.CGColor;
    self.layer.borderWidth = 1;
    
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.mh_h/2.0;
}

- (void)setCellType:(MHVoSeReviewCellType)cellType {
    _cellType = cellType;
  
    if (_cellType == MHVoSeReviewCellTypeReview) {
        
    } else {

    }
}

- (void)setModel:(MHVolSerReviewModel *)model {
    _model = model;
   
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:MAvatar];
    _name.text = _model.real_name;
    _applyDate.text = _model.apply_date;
    _applySerTeam.text = _model.activity_name;
    
    self.statusLabel.hidden = !self.cellType;
    self.line.hidden = self.cellType;
    if ([_model.status isEqualToNumber:@1]) {
        self.statusLabel.text = @"审核已通过";
        self.statusLabel.textColor = MColorToRGB(0x13ce66);
    } else if ([_model.status isEqualToNumber:@2]) {
        self.statusLabel.text = @"审核不通过";
        self.statusLabel.textColor = MColorToRGB(0xff4949);
    }else if ([_model.status isEqualToNumber:@3]){
        self.statusLabel.text = @"申请已撤回";
        self.statusLabel.textColor = MColorToRGB(0x99a9bf);
    }
}

@end
