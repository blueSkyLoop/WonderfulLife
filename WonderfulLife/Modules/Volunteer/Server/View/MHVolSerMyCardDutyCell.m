//
//  MHVolSerMyCardDutyCell.m
//  WonderfulLife
//
//  Created by zz on 09/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerMyCardDutyCell.h"
#import "UIView+MHFrame.h"
#import "MHMacros.h"

@interface MHVolSerMyCardDutyCell ()
@property (nonatomic,strong) UIView *tagsView;
@end

@implementation MHVolSerMyCardDutyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVolSerMyCardDutyCell";
    MHVolSerMyCardDutyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVolSerMyCardDutyCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (CGFloat)tagsArray:(NSArray *)tagsArray {
    [self.tagsView removeFromSuperview];
    [self.contentView addSubview:self.tagsView];
    
    int width = 10;
    int j = 0;
    int row = 1;
    NSMutableArray *widthArray = [NSMutableArray array];
    for (int i = 0 ; i < tagsArray.count; i++) {
        NSString *tag_name = tagsArray[i];
        if ((isIPhone5()||isIPhone4())&&tag_name.length>=15) {//chch
            tag_name = [[tag_name substringToIndex:13] stringByAppendingString:@"..."];
        }
        int labWidth = [self widthForLabel:tag_name fontSize:16]+24;

        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(5*j+width,row*48-28,labWidth,32);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.text = tag_name;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 1;
        label.layer.cornerRadius = 16;
        label.layer.borderWidth = 1;
        label.textColor = MColorBlue;
        label.layer.borderColor = MColorBlue.CGColor;
        
        [self.tagsView addSubview:label];

        width = CGRectGetMaxX(label.frame);
        
        j++;
        
        if (width > 280) {
            j = 0;
            width = 10;
            row++;
            label.frame = CGRectMake(5*j + width,row*48-28, labWidth, 32);
            width = width + labWidth;
            j++;
        }
        [widthArray addObject:@(width)];
    }
    
    if (row == 1) {
         self.tagsView.frame = CGRectMake(MScreenW - width - 16, 0, width, 80);
        return 80;
    }else{
        int maxWidth = [[widthArray valueForKeyPath:@"@max.intValue"] intValue];
        self.tagsView.frame = CGRectMake(MScreenW - maxWidth - 16, 0, maxWidth, row*48+28);
    }
    return self.tagsView.frame.size.height;
}

-(CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil]];
    return size.width;
}

- (UIView*)tagsView {
    if (!_tagsView) {
        _tagsView = [UIView new];
    }
    return _tagsView;
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
