//
//  MHReportRepairDetailViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairDetailViewModel.h"

#import "MHNetworking.h"
#import "YYModel.h"

#import "MHHUDManager.h"



@interface MHReportRepairDetailViewModel()

@property (nonatomic,strong,readwrite)RACCommand *reportDetailCommand;
@property (nonatomic,strong,readwrite)RACSubject *UIRefreshSubject;

@end

@implementation MHReportRepairDetailViewModel

- (void)createSectionDataWith:(MHReportRepairDetailModel *)model{
    self.model = model;
    [self.dataArr removeAllObjects];
    if(self.model.repair_log_app_vos.count){
        [self.dataArr addObject:self.model.repair_log_app_vos];
        //第一个显示当前处理状态
        MHReportRepairLogModel *amodel = [self.model.repair_log_app_vos firstObject];
        amodel.isFirst = YES;
        
    }
    //未处理完成，则没有评价显示 或者已激活的也没有
    if(self.model.status != 0 && self.model.status != 1 && self.model.status != 4){
        [self.dataArr addObject:@[]];
    }
    [self.dataArr addObject:@[model]];
    
}

- (NSMutableArray <MHReportRepairPhotoPreViewModel *>*)allPhotos{
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:self.model.img_info_dtos.count];
    for(int i=0;i<self.model.img_info_dtos.count;i++){
        MHReportRepairInforModel *amodel = self.model.img_info_dtos[i];
        MHReportRepairPhotoPreViewModel *tempModel = [MHReportRepairPhotoPreViewModel new];
        tempModel.bigPicUrl = amodel.url?:amodel.s_url;
        tempModel.type = 1;
        [muArr addObject:tempModel];
    }
    return muArr;
}

#pragma mark - lazyload
- (RACCommand *)reportDetailCommand{
    if(!_reportDetailCommand){
        @weakify(self);
        _reportDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id x) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *parameter = @{@"repairment_id":@(self.repairment_id)};
                [MHHUDManager show];
                [[MHNetworking shareNetworking] post:@"repair/get" params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    if([data isKindOfClass:[NSDictionary class]]){
                        MHReportRepairDetailModel *amodel = [MHReportRepairDetailModel yy_modelWithJSON:data];
                        [self createSectionDataWith:amodel];
                        [subscriber sendNext:amodel];
                        [subscriber sendCompleted];
                    }else{
                        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":@"网络出错"}];
                        [subscriber sendError:error];
                        [subscriber sendCompleted];
                    }
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _reportDetailCommand;
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (RACSubject *)UIRefreshSubject{
    if(!_UIRefreshSubject){
        _UIRefreshSubject = [RACSubject subject];
    }
    return _UIRefreshSubject;
}

@end
