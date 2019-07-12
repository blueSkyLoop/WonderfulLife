//
//  NSString+HLJudge.m
//  HLCategory
//
//  Created by hanl on 2017/5/2.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import "NSString+HLJudge.h"

@implementation NSString (HLJudge)

- (BOOL)hl_isEmpty {
    if ([self isKindOfClass:[NSNull class]]) return YES;
    if ([self isEqual:[NSNull null]]) return YES;
    if (self.length == 0) return YES;
    
    return ({
        [self stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0;
    });
}

- (BOOL)hl_isMobilePhone {
    return [self compareRegex:@"^1([3-57-8])\\d{9}$"];
}

- (BOOL)hl_isTelephone {
    return [self compareRegex:@"((\\+[0-9]{2,4})?\\(?[0-9]+\\)?-?)?[0-9]{7,8}|([\\d]{3,13})"];
}

- (BOOL)hl_isEmail {
    return [self compareRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)hl_containEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue =YES;
                }else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}



#pragma mark - execute regex

- (BOOL)compareRegex:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
