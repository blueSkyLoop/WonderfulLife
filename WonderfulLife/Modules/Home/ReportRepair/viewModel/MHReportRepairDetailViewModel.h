//
//  MHReportRepairDetailViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "MHReportRepairDetailModel.h"
#import "MHReportRepairPhotoPreViewModel.h"

@interface MHReportRepairDetailViewModel : NSObject

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong)MHReportRepairDetailModel *model;

@property (nonatomic,strong,readonly)RACCommand *reportDetailCommand;

@property (nonatomic,strong,readonly)RACSubject *UIRefreshSubject;

@property (nonatomic,assign)NSInteger repairment_id;

- (NSMutableArray <MHReportRepairPhotoPreViewModel *>*)allPhotos;

@end
