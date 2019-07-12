//
//  MHHomeViewModel.h
//  WonderfulLife
//
//  Created by zz on 22/11/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHHomeFunctionalModulesModel;
@interface MHHomeViewModel : NSObject
@property (nonatomic,copy,readonly) NSArray *nibCellNames;
@property (nonatomic,copy,readonly) NSArray *displayLimitNumbers;            //首页各个section显示的数量限制

///modules data source
//------------------------- array -----------------------------/
@property (nonatomic,strong) NSArray *dataSource_adsmodules;  //首页广告模块
@property (nonatomic,strong) NSMutableArray<MHHomeFunctionalModulesModel*> *dataSource_functionalmodules;  //首页功能模块
@property (nonatomic,copy,readonly) NSArray *dataSource_comcaremodules;  //首页社区关怀模块

- (NSString *)nextControllerFromUrl:(NSString *)url;
@end
