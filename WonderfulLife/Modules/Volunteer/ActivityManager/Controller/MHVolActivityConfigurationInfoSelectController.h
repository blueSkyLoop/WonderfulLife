//
//  MHVolActivityTeamsSelectController.h
//  WonderfulLife
//
//  Created by zz on 16/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHVolActivityConfigurationInfoSelectType) {
    MHVolActivityConfigurationInfoSelectTypeTeams,
    MHVolActivityConfigurationInfoSelectTypeProject,
};
typedef void(^MHVolActivityModifyAddressBlock)(NSNumber *action_template_id,NSString *title);

@interface MHVolActivityConfigurationInfoSelectController : UIViewController
@property (assign, nonatomic) MHVolActivityConfigurationInfoSelectType type;
@property (strong, nonatomic) NSNumber *teamID;
@property (copy, nonatomic) MHVolActivityModifyAddressBlock block;
@end
