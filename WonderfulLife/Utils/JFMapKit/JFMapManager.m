//
//  JFMapManager.m
//  JFCommunityCenter
//
//  Created by hanl on 2017/5/4.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import "JFMapLocationModel.h"

#import "JFMapManager.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JFMapManager ()<AMapLocationManagerDelegate,AMapSearchDelegate>

/**
 *  gd Map location manager
 */
@property (strong,nonatomic) AMapLocationManager *locationManager;

/**
 *  gd search class
 */
@property (strong,nonatomic) AMapSearchAPI *mapSearch;

/**
 *  always updating call back block
 */
@property (strong,nonatomic) JFMapAlwaysPositionCallBackHandler alwaysBlock;

/**
 *  search reault call back block
 */
@property (strong,nonatomic) JFMapSearchResultCompletedHandler resultBlock;

@property (nonatomic, strong) NSString *currentCity;

@property(nonatomic,strong) CLGeocoder * geoCoder;
@property(nonatomic,strong) CLLocationManager *clManager;
@end

@implementation JFMapManager {
    CLLocation *_currentLocation;
}

+ (instancetype)manager {
    return [[self alloc]init];
}

#pragma marek - public

- (void)singlePositioningCompletionBlock:(JFMapSinglePositionCompletedHandler)block {
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (block) block(location,regeocode.city,error);
        _currentLocation = location;
    }];
}

- (void)alwaysPositioningCallBack:(JFMapAlwaysPositionCallBackHandler)block {
    [self.locationManager startUpdatingLocation];
    self.alwaysBlock = block;
}

- (void)searchCityWithLocation:(CLLocation *)location callBlock:(void(^)(NSString *))block{
    if (self.geoCoder.isGeocoding) {
        [self.geoCoder cancelGeocode];
    }
    [self.clManager requestWhenInUseAuthorization];
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                            if (placemarks.count > 0)
                            {
                                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                //获取城市
                                NSString *city = placemark.locality;
                                if (!city) {
                                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                                    city = placemark.administrativeArea;
                                }
                                block(city);
                            }
                        }];
}

#pragma mark -search

- (void)searchKeyWords:(NSArray *)keyWords
             Location:(CLLocation *)location
               radius:(CGFloat)radius
             completed:(JFMapSearchResultCompletedHandler)completed {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
    NSMutableString *keyWordsString = [NSMutableString string];
    for (NSString *keyWord in keyWords) {
        [keyWordsString appendString:keyWord];
        if ([keyWords indexOfObject:keyWord]<keyWords.count-1) {
           [keyWordsString appendString:@"|"];
        }
    }
    request.keywords = keyWordsString;
    request.radius = radius;
    request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [self.mapSearch AMapPOIAroundSearch:request];
    self.resultBlock = completed;
}

- (void)searchLocation:(CLLocation *)location
                radius:(CGFloat)radius
             completed:(JFMapSearchResultCompletedHandler)completed{
    [self searchKeyWords:nil Location:location radius:radius completed:completed];
}


- (void)searchKeyWords:(NSArray *)keyWords
                  city:(NSString *)city
             completed:(JFMapSearchResultCompletedHandler)completed
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    NSMutableString *keyWordsString = [NSMutableString string];
    for (NSString *keyWord in keyWords) {
        [keyWordsString appendString:keyWord];
        if ([keyWords indexOfObject:keyWord]<keyWords.count-1) {
            [keyWordsString appendString:@"|"];
        }
    }
    request.keywords = keyWordsString;
    request.city = city;
    request.cityLimit = YES;
    [self.mapSearch AMapPOIKeywordsSearch:request];
    self.resultBlock = completed;
}

#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager
          didUpdateLocation:(CLLocation *)location
                  reGeocode:(AMapLocationReGeocode *)reGeocode {
    _currentLocation = location;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.alwaysBlock) {
            self.alwaysBlock();
            self.alwaysBlock = nil;
        }
    });
}

- (void)amapLocationManager:(AMapLocationManager *)manager
           didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.alwaysBlock) {
            self.alwaysBlock();
            self.alwaysBlock = nil;
        }
    });
}



#pragma mark - AMapSearchDelegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request
               response:(AMapPOISearchResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.resultBlock) {
            NSMutableArray *array = [NSMutableArray array];
            for (AMapPOI *poi in response.pois) {
                [array addObject:[JFMapLocationModel modelWithAMapPOI:poi]];
            }
            self.resultBlock(array, nil);
            self.resultBlock = nil;
        }
    });
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.resultBlock) {
            self.resultBlock(nil, error);
            self.resultBlock = nil;
        }
    });
}



#pragma mark - get

- (AMapLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[AMapLocationManager alloc]init];
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为2s
        _locationManager.locationTimeout =2;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        _locationManager.reGeocodeTimeout = 2;
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 200;
        [_locationManager setLocatingWithReGeocode:YES];
    } return _locationManager;
}

- (AMapSearchAPI *)mapSearch {
    if (_mapSearch == nil) {
        _mapSearch = [[AMapSearchAPI alloc]init];
        _mapSearch.delegate = self;
    } return _mapSearch;
}


- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
       
    }
    return _geoCoder;
}

- (CLLocationManager *)clManager {
    if (!_clManager) {
        _clManager = [[CLLocationManager alloc] init];
    }
    return _clManager;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
