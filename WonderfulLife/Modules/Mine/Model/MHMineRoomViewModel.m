//
//  MHMineRoomViewModel.m
//  WonderfulLife
//
//  Created by 哈马屁 on 2018/1/3.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import "MHMineRoomViewModel.h"
#import "MHNetworking.h"
#import "MHMineRoomModel.h"
#import "YYModel.h"

@interface MHMineRoomViewModel ()

@property (nonatomic, strong) RACCommand *roomListCommand;
@property (nonatomic, strong) id subscriber;

@end

@implementation MHMineRoomViewModel

- (RACCommand *)roomListCommand{
    if (_roomListCommand == nil) {
        _roomListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                _subscriber = subscriber;
                [[MHNetworking shareNetworking] post:@"struct/myroom/list" params:nil success:^(NSDictionary *data) {
                    NSArray *array = [NSArray yy_modelArrayWithClass:[MHMineRoomModel class] json:data[@"room_list"]];
                    [subscriber sendNext:RACTuplePack(@1,array)];//元组（是否成功，数据列表）
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，数据列表）
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _roomListCommand;
}
@end
