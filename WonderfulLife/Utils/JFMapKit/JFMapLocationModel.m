//
//  JFMapLocationModel.m
//  JFCommunityCenter
//
//  Created by hanl on 2017/5/5.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import "JFMapLocationModel.h"

#import <AMapSearchKit/AMapSearchKit.h>

@implementation JFMapLocationModel

+ (instancetype)modelWithAMapPOI:(AMapPOI *)poi {
    JFMapLocationModel *model = [[self alloc]init];
    model.locationName = poi.name;
    model.locationMessage = poi.address;
    model.latitude = poi.location.latitude;
    model.longitude = poi.location.longitude;
    return model;
}

- (CLLocation *)location {
    return [[CLLocation alloc]initWithLatitude:_latitude longitude:_longitude];
}

- (BOOL)isEqual:(id)object {
    if (![object isMemberOfClass:[JFMapLocationModel class]]) return NO;
    
    JFMapLocationModel  *model = (JFMapLocationModel *)object;
    
    if (![model.locationName isEqualToString:self.locationName]) return NO;
    if (model.latitude != self.latitude) return NO;
    if (model.longitude != self.longitude) return NO;
    
    return YES;
}

- (double)distanceFromLocation:(JFMapLocationModel *)locationModel {
    return [self.location distanceFromLocation:locationModel.location];
}

@end
