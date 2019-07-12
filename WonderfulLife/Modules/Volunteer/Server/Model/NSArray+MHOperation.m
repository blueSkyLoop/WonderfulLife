//
//  NSArray+MHOperation.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSArray+MHOperation.h"

@implementation NSArray (MHOperation)

- (NSArray *)mh_mergeArray:(NSArray *)array {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self];
    for (NSObject *obj in array)
        [mArr addObject:obj];
    return [mArr copy];
}

@end
