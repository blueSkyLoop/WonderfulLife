//
//  UITextField+HLSubText.m
//  HLCategory
//
//  Created by hanl on 2017/5/2.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import "UITextField+HLSubText.h"

@implementation UITextField (HLSubText)

- (void)hl_subTextToIndex:(NSInteger)index {
    NSString *lang = self.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *hightLightRange = [self markedTextRange];
        if (!hightLightRange) {
            if (self.text.length>index) {
                self.text = [self.text substringToIndex:index];
            }
        }
    }else if (self.text.length>index) {
        self.text = [self.text substringToIndex:index];
    } else {}
}

- (void)hl_resetSpace {
    if (!self.text) return;
    
    NSString *tmp = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    tmp = [tmp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (tmp.length==0) {
       self.text = nil;
    }
}

@end
