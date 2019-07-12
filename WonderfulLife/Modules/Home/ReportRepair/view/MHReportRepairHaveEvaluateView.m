//
//  MHReportRepairHaveEvaluateView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairHaveEvaluateView.h"
#import "LCommonModel.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "ReactiveObjC.h"

@implementation MHReportRepairHaveEvaluateView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [LCommonModel resetFontSizeWithView:self];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    
    
    [self.startView addSubview:self.evaluateStartView];
    [_evaluateStartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.startView);
        make.width.equalTo(@(40 * 5 + 6 * 4));
        make.height.equalTo(@40);
    }];
    
    
}
- (IBAction)buttonClikAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [self hiddenAlert];

}

- (void)setScore:(CGFloat)score{
    _score = score;
    self.evaluateStartView.currentScore = _score;
}

- (void)hiddenAlert{
    //    if(self.animating) return;
    //    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *aview = [touches anyObject].view;
    if(aview == self){
        
        [self buttonClikAction:self.backButton];
        
    }
}

- (XHStarRateView *)evaluateStartView{
    if(!_evaluateStartView){
        _evaluateStartView = [[XHStarRateView alloc] initWithFrame:CGRectMake(16, 20, 40 * 5 + 6 * 4, 40) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:^(CGFloat currentScore) {
            
        }];
        _evaluateStartView.userInteractionEnabled = NO;
    }
    return _evaluateStartView;
}

@end
