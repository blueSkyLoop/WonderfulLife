//
//  MHActivityModifyRulesEditCell.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHActivityModifyRulesEditCell.h"

@interface MHActivityModifyRulesEditCell ()
@property (weak, nonatomic) IBOutlet UILabel *mh_textLabel;

@end

@implementation MHActivityModifyRulesEditCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHActivityModifyRulesEditCell";
    MHActivityModifyRulesEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHActivityModifyRulesEditCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (IBAction)editEvent:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}


- (void)setText:(NSString *)text {
    _text = text;
    self.mh_textLabel.text = text;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
