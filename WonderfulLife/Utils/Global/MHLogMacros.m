//
//  MHLogMacros.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHLogMacros.h" 
inline NSString * HLGetNSLogMessage(NSString *format, ...)  {
    va_list args;
    va_start(args, format);
    NSString *msgString = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return msgString;
}
