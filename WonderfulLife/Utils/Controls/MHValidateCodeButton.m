//
//  MHValidateCodeButton.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHValidateCodeButton.h"
#import "MHMacros.h"



@interface MHValidateCodeButton ()
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;
@end

@implementation MHValidateCodeButton

- (instancetype)init {
    if (self = [super init]) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:MColorRed forState:UIControlStateNormal];
        [self setTitleColor:MColorFootnote forState:UIControlStateDisabled];
        self.titleLabel.font = MFontContent;
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.enabled = NO;
    }
    return self;
}
+ (instancetype)validateCodeButton{
    MHValidateCodeButton *btn = [[self alloc] init];
    return btn;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:MColorRed forState:UIControlStateNormal];
        [self setTitleColor:MColorContent forState:UIControlStateDisabled];
        self.titleLabel.font = MFontContent;
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.enabled = NO;
    }
    return self;
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
    }
}

#pragma mark - Event
- (void)clickAction:(UIButton *)sender {
   BOOL shoot = !self.clickBlock ?: self.clickBlock();
    if (shoot) {
        self.seconds = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(p_timeFireAction) userInfo:nil repeats:YES];
         sender.enabled = NO;
    }
}

#pragma mark - Private
-(void)p_timeFireAction {
    self.seconds--;
    
    if(self.seconds <= 0){
        [self.timer invalidate];
        
        self.enabled = YES;
        [self setTitle:@"重新获取" forState:UIControlStateNormal];
    }else{
        [self setTitle:[NSString stringWithFormat:@"%2ld秒后获取",self.seconds] forState:UIControlStateNormal];
    }
}
@end
