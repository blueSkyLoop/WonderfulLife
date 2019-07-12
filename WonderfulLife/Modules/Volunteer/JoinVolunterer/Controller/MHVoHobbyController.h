//
//  MHVoHobbyController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHVoHobbyControllerTypeFill,
    MHVoHobbyControllerTypeModify
} MHVoHobbyControllerType;

@interface MHVoHobbyController : UIViewController
@property (nonatomic,assign) MHVoHobbyControllerType type;
@property (nonatomic,copy) void (^refreshBlock)();
@end
