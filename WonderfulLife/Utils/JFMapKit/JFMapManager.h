//
//  JFMapManager.h
//  JFCommunityCenter
//
//  Created by hanl on 2017/5/4.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class CLLocation,JFMapLocationModel;
typedef void(^JFMapSinglePositionCompletedHandler)(CLLocation *location,NSString *city,NSError *error);
typedef void(^JFMapAlwaysPositionCallBackHandler)();
typedef void(^JFMapSearchResultCompletedHandler)(NSArray<JFMapLocationModel *> *array,NSError *error);


@interface JFMapManager : NSObject

+ (instancetype)manager;

/**
 *  单次定位
 */
- (void)singlePositioningCompletionBlock:(JFMapSinglePositionCompletedHandler)block;

/**
 *  持续定位
 */
- (void)alwaysPositioningCallBack:(JFMapAlwaysPositionCallBackHandler)block;

/**
 *  周边搜索: 关键字搜索
 *  @parma   keyWords: 关键字数组
 *  @parma   location: 参考点坐标
 *  @parma   radius: 搜索半径
 *  @parma   completed: 结果回调
 */
- (void)searchKeyWords:(NSArray *)keyWords
             Location:(CLLocation *)location
                radius:(CGFloat)radius
             completed:(JFMapSearchResultCompletedHandler)completed;

/**
 *  周边搜索: 全部搜索
 *  @parma   location: 参考点坐标
 *  @parma   radius: 搜索半径
 *  @parma   completed: 结果回调
 */
- (void)searchLocation:(CLLocation *)location
                radius:(CGFloat)radius
             completed:(JFMapSearchResultCompletedHandler)completed;


/**
 *  当前城市搜索: 关键字搜索
 *  @parma   keyWords: 关键字数组
 *  @parma   city: 当前城市
 *  @parma   completed: 结果回调
 */
- (void)searchKeyWords:(NSArray *)keyWords
                  city:(NSString *)city
             completed:(JFMapSearchResultCompletedHandler)completed;

- (void)searchCityWithLocation:(CLLocation *)location callBlock:(void(^)(NSString *))block;

/**
 *  当前定位到的坐标点
 */
@property (strong,nonatomic,readonly) CLLocation *currentLocation;

@end
