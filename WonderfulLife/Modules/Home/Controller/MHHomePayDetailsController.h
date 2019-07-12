//
//  MHHomePayDetailsController.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHHomePayControllerType) {
    MHHomePayControllerTypeDetails = 0,  // 缴费详情
    MHHomePayControllerTypePay  // 账单明细, 可以缴费
};

@interface MHHomePayDetailsController : UIViewController
/**
 *  控制器类型
 */
@property (assign,nonatomic) MHHomePayControllerType payControllerType;
@property (nonatomic,copy) NSString *property_id;
@property (nonatomic,copy) NSString *fee_date;

@end
