//
//  NSString+HLJudge.h
//  HLCategory
//
//  Created by hanl on 2017/5/2.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HLJudge)

- (BOOL)hl_isEmpty; //判断字符串是否为空(YES:空、NO:非空)

- (BOOL)hl_isMobilePhone; //判断字符串是否是手机号(YES:是、NO:不是)

- (BOOL)hl_isTelephone; //判断字符串是否是固定电话(YES:是、NO:不是)

- (BOOL)hl_containEmoji; //判断字符串是否含有表情(YES:有、NO:无)

- (BOOL)hl_isEmail; //判断字符串是否是邮箱(YES:是、NO:不是)

@end
