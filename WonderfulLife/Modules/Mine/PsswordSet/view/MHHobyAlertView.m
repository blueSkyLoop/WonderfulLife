//
//  MHHobyAlertView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/29.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHobyAlertView.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "ReactiveObjC.h"

@interface MHHobyAlertView()
@property (nonatomic,assign)BOOL animating;
@end

@implementation MHHobyAlertView

+ (MHHobyAlertView *)loadViewFromXib{
    MHHobyAlertView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    return aview;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    self.hobyTextF.layer.cornerRadius = 4;
    self.hobyTextF.layer.masksToBounds = YES;
    self.hobyTextF.layer.borderColor = [MRGBColor(153, 168, 191) CGColor];
    self.hobyTextF.layer.borderWidth = 1;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 40)];
    leftView.backgroundColor = [UIColor whiteColor];
    self.hobyTextF.leftView = leftView;
    self.hobyTextF.leftViewMode = UITextFieldViewModeAlways;
    
    @weakify(self);
    [self.hobyTextF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if(x && x.length){
            self.sureButton.enabled = YES;
        }else{
            self.sureButton.enabled = NO;
        }
    }];
    
}
- (IBAction)cancelAction:(UIButton *)sender {
    
    if(self.buttonClikBlock){
        self.buttonClikBlock(0);
    }
    
    [self hiddenAlert];
}
- (IBAction)sureAction:(UIButton *)sender {
    if(self.buttonClikBlock){
        self.buttonClikBlock(1);
    }
     [self hiddenAlert];
}

- (void)show{
    if(self.animating) return;
    self.alpha = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        //        [self layoutIfNeeded];
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self.hobyTextF becomeFirstResponder];
    }];
}

- (void)hiddenAlert{
    if(self.animating) return;
    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        //        self.transform = CGAffineTransformScale(self.transform, .5, .5);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    UIView *aview = [touches anyObject].view;
    if(aview == self){
        if([self.hobyTextF isFirstResponder]){
            [self.hobyTextF resignFirstResponder];
        }else{
            [self hiddenAlert];
        }
    }
    
}


@end
