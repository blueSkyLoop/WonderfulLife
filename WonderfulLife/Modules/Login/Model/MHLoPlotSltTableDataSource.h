//
//  MHLoPlotSltTableDataSource.h
//  WonderfulLife
//
//  Created by zz on 01/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

@class MHCommunityModel;
@interface MHLoPlotSltTableDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>

//搜索内容
@property (nonatomic,  copy) NSString *searchText;
//对应控制器的枚举，因为当前业务只是根据 MHLoPlotSltTypeChooseCommunity 这个情况判断cell的内容，故只添加了一个bool，后续可关联控制器的枚举来增加功能
@property (nonatomic,assign,getter=isChooseCommunity) BOOL chooseCommunity;

@property (nonatomic,strong) NSArray<MHCommunityModel *> *hotPlots;
@property (nonatomic,strong) NSMutableArray<MHCommunityModel *> *allPlots;
@property (nonatomic,strong) NSMutableArray<MHCommunityModel *> *searchPlots;
@property (nonatomic,strong) NSArray<MHCommunityModel *> *searchCities;

@property (nonatomic,strong) RACSubject  *resultSubject;

@end
