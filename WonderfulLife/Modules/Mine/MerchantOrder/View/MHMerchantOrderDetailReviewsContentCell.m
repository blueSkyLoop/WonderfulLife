//
//  MHMerchantOrderDetailReviewsContentCell.m
//  WonderfulLife
//
//  Created by zz on 27/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailReviewsContentCell.h"
#import "MHMacros.h"

#import "ReactiveObjC.h"
#import "MHHUDManager.h"

@interface MHMerchantOrderDetailReviewsContentCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *textViewBaseView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *fontNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end
@implementation MHMerchantOrderDetailReviewsContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // holder place
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入评价描述";
    placeHolderLabel.textColor = MColorToRGB(0XC0CCDA);
    [self.textView addSubview:placeHolderLabel];
    
    // same font
    self.textView.font = [UIFont systemFontOfSize:17.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:17.f];
    
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];

    // text view's border line
    self.textViewBaseView.layer.borderColor = MColorSeparator.CGColor;
    self.textViewBaseView.layer.borderWidth = 1.f;
    self.textViewBaseView.layer.cornerRadius = 6;
    self.textViewBaseView.layer.masksToBounds = YES;
    // text view's shadow shape
    self.textViewBaseView.layer.shadowOffset = CGSizeMake(0, 3);
    self.textViewBaseView.layer.shadowRadius = 5;
    self.textViewBaseView.layer.shadowColor = MColorShadow.CGColor;
    self.textViewBaseView.layer.shadowOpacity = 1;
    self.textViewBaseView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    self.textView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = textView.text;
    if(text.length <= 150){
        self.fontNumberLabel.text = [NSString stringWithFormat:@"%lu/%d",text.length,150];
    }else{
        text = [text substringWithRange:NSMakeRange(0, 150)];
        self.textView.text = text;
        [MHHUDManager showText:@"最多输入150字"];
        self.fontNumberLabel.text = [NSString stringWithFormat:@"%ld/%d",(unsigned long)text.length,150];
    }
    
    if([self.delegate respondsToSelector:@selector(mh_touchedReviewContent:)]){
        [self.delegate mh_touchedReviewContent:text];
    }
    
    CGRect bounds = textView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    
    if (bounds.size.height > 78) {
        self.textViewHeightConstraint.constant = bounds.size.height;
        UITableView *tableView = [self tableView];
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)mh_configCellWithInfor:(id)model {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
