//
//  MHVoDataPhoneController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHVoDataPhoneControllerTypeRealName,
    MHVoDataPhoneControllerTypePhone,
    MHVoDataPhoneControllerTypeName,
    MHVoDataPhoneControllerTypeCompany,
    MHVoDataPhoneControllerTypeIdentity
} MHVoDataPhoneControllerType;

@interface MHVoDataPhoneController : UIViewController
@property (nonatomic,copy) NSString *string;
@property (nonatomic,copy) void (^confirmBlock)(NSString *);
@property (nonatomic,assign) MHVoDataPhoneControllerType type;
//12.04 需求，显示掩码手机号码，点击输入框，清空内容。
@property (nonatomic,assign) BOOL isMaskCode;
@end
