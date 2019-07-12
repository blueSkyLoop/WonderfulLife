//
//  JFRequestModel.h
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/6.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHChooseUrlModel : NSObject

+ (NSString *)getBaseHttpIP;


+ (void)setBaseHttpIP:(NSString *)ipStr;

/** 服务器地址集合*/
+ (NSArray *)requestArray;

@end
