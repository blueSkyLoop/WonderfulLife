//
//  LPayPasswordFind.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface LPayPasswordFind : NSObject

@property (nonatomic,strong,readonly)RACCommand *codeGetCommand;
@property (nonatomic,strong,readonly)RACCommand *codeValiteCommand;

@end
