//
//  MHVolJoinSerLocationCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolJoinSerLocationCell.h"

#import "MHMacros.h"

@interface MHVolJoinSerLocationCell()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation MHVolJoinSerLocationCell
- (IBAction)changeEvent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTouchUpInsideChangeButton)]) {
        [self.delegate didTouchUpInsideChangeButton];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.layer.borderWidth = 1;
    [self.lineView.layer setBorderColor:MColorSeparator.CGColor];
    self.lineView.layer.cornerRadius = 5;
    
    self.lineView.layer.shadowOffset = CGSizeMake(0, 2);
    self.lineView.layer.shadowRadius = 5;
    self.lineView.layer.shadowColor = MColorShadow.CGColor;
    self.lineView.layer.shadowOpacity = 1;
    self.lineView.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

@end
