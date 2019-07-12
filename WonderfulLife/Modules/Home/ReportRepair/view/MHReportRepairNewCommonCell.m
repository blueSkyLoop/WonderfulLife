//
//  MHReportRepairNewCommonCell.m
//  WonderfulLife
//
//  Created by zz on 16/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairNewCommonCell.h"
#import "MHMacros.h"

#import "MHReportRepairNewModel.h"
#import "ReactiveObjC.h"

@interface MHReportRepairNewCommonCell ()
@property (nonatomic,assign)NSInteger limitCount;
@end
@implementation MHReportRepairNewCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)mh_configCellWithInfor:(id)model {
    
    NSDictionary *dic_item = model;
    
    self.itemTitle.text = dic_item[@"title"];
    NSString *content = dic_item[@"content"];
    BOOL isEnableEdit = [dic_item[@"isEnableEdit"] boolValue];
    ///limit Count
    self.limitCount = [dic_item[@"limitCount"] integerValue];
    if (isEnableEdit) {
        self.itemContentLabel.hidden = YES;
        self.itemContentTextField.hidden = NO;
        
        if (self.limitCount == 10) {
            self.itemContentTextField.text = [MHReportRepairNewModel share].contact_man;
            self.itemContentTextField.keyboardType = UIKeyboardTypeDefault;
        }else {
            self.itemContentTextField.text = [MHReportRepairNewModel share].contact_tel;
            self.itemContentTextField.keyboardType = UIKeyboardTypePhonePad;
        }
        self.itemContentTextField.textColor = self.itemTitle.textColor;
        self.itemContentTextField.placeholder = dic_item[@"placeholder"];
        [self.itemContentTextField setValue:MColorToRGB(0x99A9BF) forKeyPath:@"_placeholderLabel.textColor"];
        [self.itemContentTextField setValue:[UIFont systemFontOfSize:17] forKeyPath:@"_placeholderLabel.font"];
    }else {
        self.itemContentLabel.hidden = NO;
        self.itemContentTextField.hidden = YES;
        
        self.itemContentLabel.text = content;
        self.itemContentLabel.textColor = self.itemTitle.textColor;
        if (content.length == 0) {
            self.itemContentLabel.text = dic_item[@"placeholder"];
            self.itemContentLabel.textColor = MColorToRGB(0x99A9BF);
        }
    }
  
    self.arrowImageView.hidden = ![dic_item[@"hasArrow"] boolValue];
    
    ///bottomLineHidden
    self.bottomSegmentLine.hidden = [dic_item[@"bottomLineHidden"] boolValue];
    CGFloat topPadding = [dic_item[@"topLinePadding"] floatValue];
    self.topLineLeftConstraint.constant = topPadding;
    self.topLineRightConstraint.constant = topPadding;
    [self layoutIfNeeded];
    
   
    @weakify(self)
    [self.itemContentTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        NSString* text = [x stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.itemContentTextField.text = text;
        if (text.length > self.limitCount) {
            self.itemContentTextField.text = [self.itemContentTextField.text substringToIndex:self.limitCount];
        }
        if (self.limitCount == 10) {
            [MHReportRepairNewModel share].contact_man = self.itemContentTextField.text;
        }else if (self.limitCount == 12){
            [MHReportRepairNewModel share].contact_tel = self.itemContentTextField.text;
        }
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
