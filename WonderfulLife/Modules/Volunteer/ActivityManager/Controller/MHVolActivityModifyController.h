//
//  MHActivityModifyController.h
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHActivityModifyType) {
    MHActivityModifyTypeNormal,
    MHActivityModifyTypePublish,
};

@interface MHVolActivityModifyController : UIViewController
@property (strong,nonatomic) NSNumber  *team_id;
@property (copy  ,nonatomic) NSString  *team_name;
@property (strong,nonatomic) NSNumber  *activity_team_id;


@property (strong,nonatomic) NSNumber  *action_id;
/**
 必传
 */
@property (nonatomic, assign) MHActivityModifyType type;
@end
