//
//  MHVolSlectedDataSource.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
@class MHCommunityModel;
@interface MHVolSlectedDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>
//搜索内容
@property (nonatomic,  copy) NSString *searchText;
@property (nonatomic,strong) NSMutableArray<MHCommunityModel *> *allPlots;
@property (nonatomic,strong) NSMutableArray<MHCommunityModel *> *searchPlots;
@property (nonatomic,strong) NSArray<MHCommunityModel *> *searchCities;

@property (nonatomic,strong) RACSubject  *resultSubject;


@end
