//
//  MHReportRepairDeletePictureView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairDeletePictureView.h"

#import "LCommonModel.h"

@implementation MHReportRepairDeletePictureView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [LCommonModel resetFontSizeWithView:self];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    
    self.cancelButton.layer.cornerRadius = 4;
    self.cancelButton.layer.masksToBounds = YES;
    
}
- (IBAction)buttonClikAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [self hiddenAlert];
    if(self.deleteButton == sender){
        if(self.deletePictureBlock){
            self.deletePictureBlock();
        }
    }
}

- (void)hiddenAlert{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *aview = [touches anyObject].view;
    if(aview == self){
        
        [self buttonClikAction:self.cancelButton];
        
    }
}


@end
