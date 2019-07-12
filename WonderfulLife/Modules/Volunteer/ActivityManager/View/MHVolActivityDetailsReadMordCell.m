//
//  MHVolActivityDetailsReadMordCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDetailsReadMordCell.h"

#import "Masonry.h"
#import "MHMacros.h"
#import "YYLabel+LinesString.h"
#import "MHVolActivityDetailsModel.h"
#import "NSObject+isNull.h"
@interface MHVolActivityDetailsReadMordCell()
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

/** 文本内容 */
@property (strong,nonatomic) YYLabel *contentLB;

@end
@implementation MHVolActivityDetailsReadMordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * cellID = @"MHVolActivityDetailsReadMordCell";
    MHVolActivityDetailsReadMordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.contentLB];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSourceWithLabel];
}



- (void)setModel:(MHVolActivityDetailsModel *)model{
    _model = model;
    [self setSourceWithLabel];
}


- (void)setSourceWithLabel {
    if (self.readMoreType == MHVolActivityDetailsReadMordTypeIntro) {
        self.titleLB.text = @"活动内容";
        if (![NSObject isNull:self.model.intro]) {
            [self resetContentLBFrame:self.model.intro open:self.model.isOpenIntro];
        }else{
            [self resetContentLBFrame:@"" open:self.model.isOpenIntro];
        }
    }else if (self.readMoreType == MHVolActivityDetailsReadMordTypeRules){
        self.titleLB.text = @"活动规则";
        if (![NSObject isNull:self.model.rule]) {
            [self resetContentLBFrame:self.model.rule open:self.model.isOpenRules];
        }else{
            [self resetContentLBFrame:@"" open:self.model.isOpenRules];
        }
    }
}


- (void)resetContentLBFrame:(NSString *)text open:(BOOL)isOpen {
    self.contentLB.text = text ;
    NSMutableAttributedString *atrr = [self lableAttributedStringWithString:text];
    self.contentLB.numberOfLines = 0 ;
    self.contentLB.preferredMaxLayoutWidth = MScreenW - 48 ;
    if (!isOpen) { // 没有打开
        NSArray *lines = [self.contentLB mh_getLinesArrayOfStringInLabel:self.contentLB];
        if (lines.count > 3) {
            NSString *threeLineStr = lines[2] ;
            NSString *moreStr = @"...\t阅读更多";
            if (threeLineStr.length > moreStr.length) {
                NSRange range = NSMakeRange(threeLineStr.length - moreStr.length, moreStr.length);
                NSString *newText = [threeLineStr stringByReplacingCharactersInRange:range withString:moreStr];
                
                NSString *total = [NSString stringWithFormat:@"%@%@%@",lines[0],lines[1],newText];
                
                NSMutableAttributedString *moreAttr = [self lableAttributedStringWithString:total];
                
                [moreAttr yy_setTextHighlightRange:NSMakeRange(total.length - 4, 4) color:MColorBlue backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [self delegateAction];
                }];
                self.contentLB.attributedText = moreAttr ;
            }
        }else{
            self.contentLB.text = text ;
        }
        
    }else{
       self.contentLB.text = text ;
    }
    
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(24);
        make.left.right.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.equalTo(self.line.mas_top).offset(-24);
    }];
    
}



- (NSMutableAttributedString *)lableAttributedStringWithString:(NSString *)string{
    NSMutableAttributedString *atrr = [[NSMutableAttributedString alloc] initWithString:string];
    atrr.yy_color = MColorToRGB(0x475669);
    atrr.yy_lineSpacing = 2.0 ;
    atrr.yy_font = [UIFont systemFontOfSize:16.0];
    return atrr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (YYLabel *)contentLB{
    if(!_contentLB){
        _contentLB = [YYLabel new];
        _contentLB.textColor = MColorToRGB(0x475669);
    }return _contentLB ;
}


- (void)delegateAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReadMoreWithIndexPath:)]) {
        [self.delegate didClickReadMoreWithIndexPath:_indexPath];
    }
}

@end
