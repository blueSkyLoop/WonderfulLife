//
//  MHLoPlotSltCollectionDataSource.h
//  WonderfulLife
//
//  Created by zz on 01/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

@class MHCityModel;

@interface MHLoPlotSltCollectionDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) NSArray<MHCityModel *> *dataSource;
@property (strong,nonatomic) MHCityModel *mapCity;
@property (strong,nonatomic) RACSubject  *resultSubject;

@end
