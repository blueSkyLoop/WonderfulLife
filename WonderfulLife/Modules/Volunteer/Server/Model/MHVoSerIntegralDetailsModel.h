//
//  MHVoSerIntegralDetailsModel.h
//  WonderfulLife
//
//  Created by Lucas on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolunteerScorePerMonth,MHVolunteerScoreRecord;

@interface MHVoSerIntegralDetailsModel : NSObject

/** y表示查询已经到达最后一条记录，n表示尚未到达 */
@property (nonatomic, copy)   NSString * query_finished;

/**积分余额*/
@property (nonatomic, strong) NSNumber  *remaining_score;

/**总收入*/
@property (nonatomic, strong) NSNumber  *total_income;

/**总支出*/
@property (nonatomic, strong) NSNumber  *total_cost;

/**积分明细*/
@property (nonatomic, strong)NSMutableArray <MHVolunteerScorePerMonth *>* details;
@end





/**VolunteerScorePerMonth-志愿者每月积分信息*/
@interface MHVolunteerScorePerMonth : NSObject

/**时间*/
@property (nonatomic, copy)   NSString * month;

/**收入*/
@property (nonatomic, strong) NSNumber  *income;

/**支出*/
@property (nonatomic, strong) NSNumber  *cost;

@property (nonatomic, strong) NSArray  <MHVolunteerScoreRecord*> *records;


@end



/**VolunteerScoreRecord-志愿者积分明细*/
@interface MHVolunteerScoreRecord : NSObject

/**积分来源*/
@property (nonatomic, copy)   NSString * data_type;

/**时间*/
@property (nonatomic, strong) NSDate  *create_datetime;

/**积分*/
@property (nonatomic, copy)   NSString * change_score;

/** 积分ID*/
@property (nonatomic, strong) NSNumber *score_id;
@end

