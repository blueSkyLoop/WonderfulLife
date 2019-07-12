//
//  UILabel+isNull.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UILabel+isNull.h"
#import "NSObject+isNull.h"

@implementation UILabel (isNull)

- (void)mh_isNullText:(NSString *)text {
    if ([NSObject isNull:text]) {
        self.text = @"" ;
    }else {
        self.text = text ;
    }
}


- (void)mh_isNullWithDataSourceText:(NSString *)text allText:(NSString *)allText isNullReplaceString:(NSString *)replace{
    
    if ([NSObject isNull:text]) {
        self.text = replace ;
    }else {
        self.text = allText ;
    }
}

@end
