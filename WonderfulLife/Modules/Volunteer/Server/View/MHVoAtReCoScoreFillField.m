//
//  MHMHVoAtReCoScoreFillField.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAtReCoScoreFillField.h"
#import "MHMacros.h"
#import "NSString+Number.h"
#import "MHHUDManager.h"

@interface MHVoAtReCoScoreFillField ()

@end

@implementation MHVoAtReCoScoreFillField

#pragma mark - override
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        self.placeholder = @"积分";
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = MColorTitle.CGColor;
        self.keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

- (BOOL)becomeFirstResponder{
    if ([self.fiReDelegate respondsToSelector:@selector(voAtReCoScoreFillFieldbecomeFirstResponder:)]) {
        [self.fiReDelegate voAtReCoScoreFillFieldbecomeFirstResponder:self.text.floatValue];
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    if(![self.text isOnlyhasNumberAndpointWithString])
    {
        [MHHUDManager showText:@"警告:含非法字符，请输入纯数字！"];
        self.text = nil;
        return [super resignFirstResponder];
    }
    if ([self.fiReDelegate respondsToSelector:@selector(voAtReCoScoreFillFieldResignFirstResponder:IndexPath:)]) {
        [self.fiReDelegate voAtReCoScoreFillFieldResignFirstResponder:self.text.floatValue IndexPath:self.indexPath];
    }
    return [super resignFirstResponder];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}


#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







