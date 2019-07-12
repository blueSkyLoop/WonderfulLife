//
//  NSObject+AutoProperty.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoProperty)

/**
 *  自动生成属性列表
 *
 *  @param dict JSON字典/模型字典
 */
+(void)printPropertyWithDict:(NSDictionary *)dict allPropertyCode:(NSMutableString *)allPropertyCode;

@end
