//
//  MHActivityModifyEditCell.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHActivityModifyIntroduceEditCell.h"

@interface MHActivityModifyIntroduceEditCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mh_textLabel;
@end

@implementation MHActivityModifyIntroduceEditCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHActivityModifyIntroduceEditCell";
    MHActivityModifyIntroduceEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHActivityModifyIntroduceEditCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    return cell;
}
- (IBAction)editEvent:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setIntroduce:(NSString *)introduce {
    _introduce = introduce;
    self.mh_textLabel.text = introduce;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
