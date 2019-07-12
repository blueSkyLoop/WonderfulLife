//
//  MHHomeViewModel.m
//  WonderfulLife
//
//  Created by zz on 22/11/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHHomeViewModel.h"
#import "MHHomeFunctionalModulesModel.h"
#import "MHMacros.h"

static NSString *const kMHHomeHostRouteUrl = @"wonderfullife://com.junfuns.wonderfullife/home/";

@implementation MHHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
         _nibCellNames = @[@"MHHomeCricleCell",@"MHHomeButtonCell",@"MHHomeItemCell",@"MHHomeVolunteerCell",@"MHHomeCollectionCommunityCell"];
        _displayLimitNumbers = @[@1,@8,@4,@1,@3];
        
        self.dataSource_functionalmodules = [NSMutableArray array];
        [@[@{@"title":@"美好财富",@"imageUrl":@"MHHomeButtonIcon_financial",@"function_code_ios":@"wonderfullife://com.junfuns.wonderfullife/home/MHHappyTreasureController"},
           @{@"title":@"物业缴费",@"imageUrl":@"MHHomeButtonIcon_pay",@"function_code_ios":@"wonderfullife://com.junfuns.wonderfullife/home/MHHomePayNoteController"},
           @{@"title":@"投诉报修",@"imageUrl":@"MHHomeButtonIcon_repair",@"function_code_ios":@"wonderfullife://com.junfuns.wonderfullife/home/MHReportRepairMainViewController"},
           @{@"title":@"扫一扫",@"imageUrl":@"MHHomeButtonIcon_QR",@"function_code_ios":@"wonderfullife://com.junfuns.wonderfullife/home/MHQRCodeController"}
           ] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
               MHHomeFunctionalModulesModel *model = [MHHomeFunctionalModulesModel new];
               model.function_name = obj[@"title"];
               model.is_under_construction = @0;
               model.function_code_ios = obj[@"function_code_ios"];
               model.function_icon_url = obj[@"imageUrl"];
               [self.dataSource_functionalmodules addObject:model];
           }];
        
        /**
         @[@"幸福食堂",
         @"童心课堂",
         @"智善书院",
         @"便民理发"]
         
         @[@"关怀社区老人",
         @"免费辅导孩子",
         @"开办兴趣课程",
         @"老人免费理发"]
         
         MHHomeItemIcon0,
         MHHomeItemIcon1,
         MHHomeItemIcon2,
         MHHomeItemIcon3
         */
        _dataSource_comcaremodules = @[@{@"title":@"幸福食堂",@"subtitle":@"关怀社区老人",@"imageUrl":@"MHHomeItemIcon0"},
                                       @{@"title":@"童心课堂",@"subtitle":@"免费辅导孩子",@"imageUrl":@"MHHomeItemIcon1"},
                                       @{@"title":@"智善书院",@"subtitle":@"开办兴趣课程",@"imageUrl":@"MHHomeItemIcon2"},
                                       @{@"title":@"便民理发",@"subtitle":@"老人免费理发",@"imageUrl":@"MHHomeItemIcon3"}];
        
    }
    return self;
}


- (void)setDataSource_functionalmodules:(NSMutableArray<MHHomeFunctionalModulesModel *> *)dataSource_functionalmodules {
    NSUInteger count = dataSource_functionalmodules.count;
    if (count>0 && count<4) {
        NSInteger addObjectsNum = 4 - count%4;
        for (int i = 0; i < addObjectsNum ; i ++) {
            [dataSource_functionalmodules addObject:[self addObjectEmptyModel]];
        }
    }else if (count > 4 && count < 8) {
        [dataSource_functionalmodules removeObjectsInRange:NSMakeRange(3, count - 3)];
        [dataSource_functionalmodules addObject:[self addObjectMoreFunctionalModel]];
    }else if (count > 8) {
        [dataSource_functionalmodules removeObjectsInRange:NSMakeRange(7, count-7)];
        [dataSource_functionalmodules addObject:[self addObjectMoreFunctionalModel]];
    }
    _dataSource_functionalmodules = dataSource_functionalmodules;
}

- (MHHomeFunctionalModulesModel *)addObjectMoreFunctionalModel {
    MHHomeFunctionalModulesModel *more_model = [MHHomeFunctionalModulesModel new];
    more_model.function_name = @"更多";
    more_model.is_under_construction = @0;
    more_model.function_code_ios = @"wonderfullife://com.junfuns.wonderfullife/home/MHHomeServiceController";
    more_model.function_icon_url = @"MHHomeButtonIcon_more";
    return more_model;
}

- (MHHomeFunctionalModulesModel *)addObjectEmptyModel {
    MHHomeFunctionalModulesModel *empty_model = [MHHomeFunctionalModulesModel new];
    empty_model.function_name = @"";
    empty_model.is_under_construction = @0;
    empty_model.function_code_ios = @"";
    empty_model.function_icon_url = @"";
    return empty_model;
}

- (NSString *)nextControllerFromUrl:(NSString *)url {
    return [url substringFromIndex:kMHHomeHostRouteUrl.length];
}

@end
