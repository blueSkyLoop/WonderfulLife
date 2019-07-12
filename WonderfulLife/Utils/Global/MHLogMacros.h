//
//  MHLogMacros.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NSLog(...)  NSLog(@"\n**** log begain ****\n%@  %@ 第%d行 \n%@\n**** log  end ****\n",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],[[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent],__LINE__, HLGetNSLogMessage(__VA_ARGS__))
#else
#define NSLog(...)  while(0){}
#endif

extern NSString * HLGetNSLogMessage(NSString *format, ...);
