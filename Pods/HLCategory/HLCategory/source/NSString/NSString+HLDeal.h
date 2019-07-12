//
//  NSString+HLDeal.h
//  HLCategory
//
//  Created by hanl on 2017/5/2.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HLDeal)

// 将包含特殊字符的电话号码转为纯数字
- (NSString *)hl_dealPhone;

@end
