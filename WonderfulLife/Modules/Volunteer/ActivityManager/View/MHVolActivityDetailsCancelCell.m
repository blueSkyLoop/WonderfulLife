//
//  MHVolActivityDetailsCancelCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDetailsCancelCell.h"
#import "MHMacros.h"
#import "UIView+Shadow.h"
@interface MHVolActivityDetailsCancelCell()
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end


@implementation MHVolActivityDetailsCancelCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString * cellID = @"MHVolActivityDetailsCancelCell";
    MHVolActivityDetailsCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.doneBtn setTitle:@"取消活动" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
    [self.doneBtn mh_setupContainerLayerWithContainerView];
}

- (IBAction)cancelAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCellCancelButton)]) {
        [self.delegate didClickCellCancelButton];
    }
}

@end
