//
//  MHReportRepairCancelView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairCancelView.h"
#import "LCommonModel.h"

@implementation MHReportRepairCancelView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [LCommonModel resetFontSizeWithView:self];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    
}
- (IBAction)buttonClikAction:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    [self hiddenAlert];
    if(self.rightButton == sender){
        if(self.cacelSureBlock){
            self.cacelSureBlock();
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
        
        [self buttonClikAction:self.leftButton];
        
    }
}


@end
