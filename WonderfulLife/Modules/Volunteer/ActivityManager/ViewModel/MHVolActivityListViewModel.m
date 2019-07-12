//
//  MHVolActivityListViewModel.m
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityListViewModel.h"
#import "MHVolActivityListModel.h"
#import "MHVolActivityRequestHandler.h"
#import "MHVolActivityListDataViewModel.h"
#import "MHVolunteerUserInfo.h"

@interface MHVolActivityListViewModel()
@property (assign ,nonatomic) NSInteger currentPage;
@property (nonatomic, readonly) dispatch_queue_t synchronizationQueue;
@end

@implementation MHVolActivityListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _synchronizationQueue = dispatch_queue_create([@"com.MH.synchronization" cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
        self.willUpdatePage = 1;
    }
    return self;
}


//遍历数据，处理数据逻辑
- (void)enumerateObjects:(NSArray*)array {
   
    dispatch_barrier_sync(self.synchronizationQueue, ^{
        NSMutableArray *cachArray = [NSMutableArray arrayWithArray:[self.dataSources objectAtIndex:0]];
        for (MHVolActivityListModel *obj in array) {
            MHVolActivityListDataViewModel *dataViewModel = [[MHVolActivityListDataViewModel alloc] init];
            dataViewModel.model = obj;
            if ([[MHVolunteerUserInfo sharedInstance].volunteer_is_captain isEqualToNumber:@1]){
                [dataViewModel handleCaptainList];
            }else if ([[MHVolunteerUserInfo sharedInstance].volunteer_is_captain isEqualToNumber:@0]){
                [dataViewModel handleTeammateList];
            }
            [cachArray addObject:dataViewModel];
        };
        [self.dataSources replaceObjectAtIndex:0 withObject:cachArray];
    });
}

- (void)enumerateEndActivityObjects:(NSArray*)array {
    
    dispatch_barrier_sync(self.synchronizationQueue, ^{
        NSMutableArray *cachArray = [NSMutableArray arrayWithArray:[self.dataSources objectAtIndex:1]];
        for (MHVolActivityListModel *obj in array) {
            MHVolActivityListDataViewModel *dataViewModel = [[MHVolActivityListDataViewModel alloc] init];
            dataViewModel.model = obj;
            [dataViewModel handleEndOfActivityList];
            [cachArray addObject:dataViewModel];
        };
        [self.dataSources replaceObjectAtIndex:1 withObject:cachArray];
    });
}
//更新成功重置页数&数组
- (void)resetTableviewDataSource {
    self.currentPage = 1;
    self.willUpdatePage = 1;
    [self.dataSources removeAllObjects];
    self.dataSources[0] = @[];
    self.dataSources[1] = @[];
}

- (void)resetDoingDataSource {
    self.currentPage = 1;
    self.willUpdatePage = 1;
    self.dataSources[0] = @[];
}

- (void)resetEndDataSource {
    self.currentPage = 1;
    self.willUpdatePage = 1;
    self.dataSources[0] = @[];
}

- (void)assignNewPage {
    self.currentPage = self.willUpdatePage;
}

- (void)resetToOldPage {
    self.willUpdatePage = self.currentPage;
}

#pragma mark - Getter

- (RACSubject *)modifyActivitySubject {
    if (!_modifyActivitySubject) {
        _modifyActivitySubject = [RACSubject subject];
    }
    return _modifyActivitySubject;
}

- (RACSubject *)attendanceRegistrationSubject {
    if (!_attendanceRegistrationSubject) {
        _attendanceRegistrationSubject = [RACSubject subject];
    }
    return _attendanceRegistrationSubject;
}

- (RACSubject *)enrollListManagerSubject {
    if (!_enrollListManagerSubject) {
        _enrollListManagerSubject = [RACSubject subject];
    }
    return _enrollListManagerSubject;
}

- (RACSubject *)reviewDetailSubject {
    if (!_reviewDetailSubject) {
        _reviewDetailSubject = [RACSubject subject];
    }
    return _reviewDetailSubject;
}

- (RACCommand *)enrollingCommand {
    if (!_enrollingCommand) {
        _enrollingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHVolActivityRequestHandler pushEnrollActivityId:input];
        }];
    }
    return _enrollingCommand;
}

- (RACCommand *)enrollCancelCommand {
    if (!_enrollCancelCommand) {
        _enrollCancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHVolActivityRequestHandler pushEnrollCancelActivityId:input];
        }];
    }
    return _enrollCancelCommand;
}

- (RACCommand *)getMyteamsCommand {
    if (!_getMyteamsCommand) {
        _getMyteamsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHVolActivityRequestHandler pullActivityTeamListWithVolunteer_id:[MHVolunteerUserInfo sharedInstance].volunteer_id ActivityDetailsBlock:^(id data) {
                    [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，数据模型）
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg) {
                    [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，数据模型）
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _getMyteamsCommand;
}

//------------------------- 优化请求 -----------------------------/
- (RACCommand *)doingActivityListDatasCommand {
    if (!_doingActivityListDatasCommand) {
        _doingActivityListDatasCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHVolActivityRequestHandler pullActivityListWithState:@2 page:@1];
        }];
    }
    return _doingActivityListDatasCommand;
}

- (RACCommand *)doneActivityListDatasCommand {
    if (!_doneActivityListDatasCommand) {
        _doneActivityListDatasCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHVolActivityRequestHandler pullActivityListWithState:@3 page:@1];
        }];
    }
    return _doneActivityListDatasCommand;
}

- (RACCommand *)updateActivityListDatasCommand {
    if (!_updateActivityListDatasCommand) {
        _updateActivityListDatasCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHVolActivityRequestHandler pullActivityListWithState:input page:@1];
        }];
    }
    return _updateActivityListDatasCommand;
}

- (RACCommand *)loadNewActivityListDatasCommand {
    if (!_loadNewActivityListDatasCommand) {
        _loadNewActivityListDatasCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHVolActivityRequestHandler pullActivityListWithState:input page:@1];
        }];
    }
    return _loadNewActivityListDatasCommand;
}

- (RACCommand *)updateActivityListDatasToTopCommand {
    if (!_updateActivityListDatasToTopCommand) {
        _updateActivityListDatasToTopCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHVolActivityRequestHandler pullActivityListWithState:input page:@1];
        }];
    }
    return _updateActivityListDatasToTopCommand;
}

- (RACCommand *)loadMoreActivityListDatasCommand {
    if (!_loadMoreActivityListDatasCommand) {
        @weakify(self)
        _loadMoreActivityListDatasCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            self.willUpdatePage++;
            return [MHVolActivityRequestHandler pullActivityListWithState:input page:@(self.willUpdatePage)];
        }];
    }
    return _loadMoreActivityListDatasCommand;
}

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray arrayWithArray:@[@[],@[]]];
    }
    return _dataSources;
}

@end
  
