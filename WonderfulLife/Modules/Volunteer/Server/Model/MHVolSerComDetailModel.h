//
//  MHVolSerComDetailModel.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolSerComDetailModel : NSObject

/**  score	String	+522 | -24	积分 */
@property (nonatomic, copy)   NSString * score;

/** duration	String	+11 | -100	服务时长 */
@property (nonatomic, copy)   NSString * duration;

/**  score_intro	String	原有积分数，系统转移	积分说明 */
@property (nonatomic, copy)   NSString * score_intro;

/** team_name	String	治安巡逻队	服务队名称 */
@property (nonatomic, copy)   NSString * team_name;

/** release_time	String	2017-06-20 12:12 */
@property (nonatomic, copy)   NSString * release_time;

/** 是否属于兑换类，0：否，1：是 */
@property (nonatomic, assign) NSInteger is_redeem;

@end
