//
//  MHVolJoinSerMsgCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolJoinSerMsgCell.h"
#import "MHMacros.h"

@interface MHVolJoinSerMsgCell()
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation MHVolJoinSerMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.layer.borderWidth = 1;
    [self.lineView.layer setBorderColor:MColorSeparator.CGColor];
    self.lineView.layer.cornerRadius = 5;
    
}

- (IBAction)selectedEvent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTouchUpInsideSelectedButtonIndexPath:)]) {
        [self.delegate didTouchUpInsideSelectedButtonIndexPath:self.indexPath];
    }
}


@end
