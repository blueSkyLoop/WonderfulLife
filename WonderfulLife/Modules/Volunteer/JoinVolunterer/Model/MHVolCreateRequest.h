//
//  MHVolCreateRequest.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolSerItemManager ;
typedef void(^MHVolCreateActivteBlock)(MHVolSerItemManager *,NSString *);
typedef void(^MHVolCreateFinishCallBlock)(BOOL,NSString *);
typedef void(^MHApplyJoinActiveCallBack)(BOOL success,NSString *errmsg);
typedef void(^MHCheckCityCallBack)(BOOL success,BOOL is_serve_community,NSString *errmsg);
@interface MHVolCreateRequest : NSObject


+ (void)sendCommunityId:(NSNumber *)communityId
               callBack:(MHVolCreateActivteBlock)callBack;


+ (void)createdVolunterCallBack:(MHVolCreateFinishCallBlock)callBack;

+ (void)applyJoinActiveCallBack:(MHApplyJoinActiveCallBack)callBack;

/**
 *  检测 communityId 所属的id 是否为经营小区
 *
 *  @parma   communityId
 *
 *
 */
+ (void)checkHotCityCallBack:(MHCheckCityCallBack)callBack ;
@end
