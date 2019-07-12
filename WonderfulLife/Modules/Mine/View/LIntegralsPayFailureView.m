//
//  LIntegralsPayFailureView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LIntegralsPayFailureView.h"
#import "LCommonModel.h"
#import "MHMacros.h"

@implementation LIntegralsPayFailureView

+ (LIntegralsPayFailureView *)loadViewFromXib{
    LIntegralsPayFailureView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    return aview;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.compleButton.layer.borderWidth = 1;
    self.compleButton.layer.borderColor = [MRGBColor(211, 220, 230) CGColor];
    self.compleButton.layer.cornerRadius = 3;
    self.compleButton.layer.masksToBounds = YES;
    
    [LCommonModel resetFontSizeWithView:self];
}
- (IBAction)payAction:(MHThemeButton *)sender {
    [self.failureSubject sendNext:@(1)];
}
- (IBAction)compleAction:(UIButton *)sender {
    [self.failureSubject sendNext:@(0)];
}

- (RACSubject *)failureSubject{
    if(!_failureSubject){
        _failureSubject = [RACSubject subject];
    }
    return _failureSubject;
}

@end
