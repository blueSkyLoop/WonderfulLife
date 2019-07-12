//
//  MHPromptSuccessController.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  提示成功  

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHCertificationSuccessType) {
    MHCertificationSuccessTypeNone,
    
    /** 住户认证 */
    MHCertificationSuccessTypeHouseholdCommit,
    
    /** 志愿者认证 含服务项目*/
    MHCertificationSuccessTypeVolSer,
    
    /** 志愿者认证 不含服务项目*/
    MHCertificationSuccessTypeVolNoSer,
};
@interface MHCertificationSuccessController : UIViewController

@property (nonatomic, assign) MHCertificationSuccessType type;

- (instancetype)initWithType:(MHCertificationSuccessType)type;

@end
