//
//  MHLoPlotSltViewModel.h
//  WonderfulLife
//
//  Created by zz on 01/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface MHLoPlotSltViewModel : NSObject

@property (nonatomic, strong) RACSignal *singlePositionSignal;
@property (nonatomic, strong) RACSignal *hotCityListSignal;
@property (nonatomic, strong) RACSignal *hotPlotListSignal;
@property (nonatomic, strong) RACSignal *searchPlotListSignal;

@end
