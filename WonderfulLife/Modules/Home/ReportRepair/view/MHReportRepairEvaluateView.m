//
//  MHReportRepairEvaluateView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairEvaluateView.h"
#import "LCommonModel.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "IQKeyboardManager.h"

@interface MHReportRepairEvaluateView()

@property (nonatomic,assign)CGFloat keyBoardGap;

@end

@implementation MHReportRepairEvaluateView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [LCommonModel resetFontSizeWithView:self];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    
    self.textBigBgView.layer.cornerRadius = 2;
    self.textBigBgView.layer.masksToBounds = YES;
    self.textBigBgView.layer.borderColor = [MRGBColor(192, 204, 218) CGColor];
    self.textBigBgView.layer.borderWidth = .5;
    
    
    
    
    [self.startView addSubview:self.evaluateStartView];
    [_evaluateStartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.startView);
        make.width.equalTo(@(40 * 5 + 15 * 4));
        make.height.equalTo(@40);
    }];
    
    [self.textBgView addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textBgView);
        make.width.equalTo(self.textBgView.mas_width);
    }];
    @weakify(self);
    [RACObserve(self.textView, text)  subscribeNext:^(NSString *text) {
        @strongify(self);
        NSString *atext = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(atext.length <= 50){
            self.textView.text = atext;
            self.numLabel.text = [NSString stringWithFormat:@"%ld/%d",atext.length,50];
        }else{
            self.textView.text = [atext substringWithRange:NSMakeRange(0, 50)];
        }
    }];
    RACSignal *evaluateSignal = RACObserve(self.textView, text);
    RACSignal *scoreSignal = RACObserve(self, score);
    RACSignal * reduceSignal = [RACSignal combineLatest:@[evaluateSignal,scoreSignal] reduce:^id(NSString *evaluateStr,NSNumber *score){

        return @(evaluateStr.length && [score integerValue]);

    }];

   RAC(self.rightButton,enabled) = reduceSignal;
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    [self addNotification];
    
    
}
- (IBAction)buttonClikAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [self hiddenAlert];
    if(self.rightButton == sender){
        if(self.evaluateBlock){
            self.evaluateBlock(self.textView.text, self.score);
        }
    }
    
}


- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGRect buttonRect = [self convertRect:self.bgView.frame toView:self];

    CGFloat keyboardHeight = 271;
    if(MScreenW == 320){
        keyboardHeight = 253;
    }else if(MScreenW == 375){
        keyboardHeight = 258;
    }else if(MScreenW == 414){
        keyboardHeight = 271;
    }
    
    if(CGRectGetHeight(keyboardRect) < keyboardHeight){
        keyboardRect.size.height = keyboardHeight;
        
    }
    
    //超过了键盘
    if(buttonRect.origin.y + buttonRect.size.height > keyboardRect.origin.y){
        
        self.keyBoardGap = CGRectGetHeight(keyboardRect) - (MScreenH - buttonRect.origin.y - buttonRect.size.height);
        self.layoutCenterY.constant = -self.keyBoardGap;

    }
    
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    if(self.keyBoardGap){
        self.layoutCenterY.constant = 0;
    }
}

- (void)hiddenAlert{
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
      
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [IQKeyboardManager sharedManager].enable = YES;
        [self removeFromSuperview];
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *aview = [touches anyObject].view;
    if(aview == self){
        if([self.textView isFirstResponder]){
            [self.textView resignFirstResponder];
        }else{
            [self buttonClikAction:self.leftButton];
        }
    }else if(aview == self.bgView){
        [self endEditing:YES];
    }
}

- (XHStarRateView *)evaluateStartView{
    if(!_evaluateStartView){
        @weakify(self);
        _evaluateStartView = [[XHStarRateView alloc] initWithFrame:CGRectMake(16, 20, 40 * 5 + 15 * 4, 40) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:^(CGFloat currentScore) {
            @strongify(self);
            self.score = currentScore;
        }];
    }
    return _evaluateStartView;
}

- (YYTextView *)textView{
    if(!_textView){
        _textView = [[YYTextView alloc] init];
        _textView.placeholderFont = [UIFont systemFontOfSize:MScale * 14];
        _textView.placeholderTextColor = MRGBColor(153, 169, 191);
        _textView.placeholderText = @"请写下您对本次服务的评价吧";
        _textView.font = [UIFont systemFontOfSize:MScale * 14];
        _textView.textColor = MRGBColor(50, 64, 87);
    }
    return _textView;
}

@end
