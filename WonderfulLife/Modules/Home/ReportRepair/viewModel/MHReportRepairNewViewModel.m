//
//  MHReportRepairNewViewModel.m
//  WonderfulLife
//
//  Created by zz on 16/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairNewViewModel.h"
#import "MHReportRepairNewModel.h"
#import "MHNetworking.h"
#import "YYModel.h"
#import "MHMacros.h"

#import "MHUserInfoManager.h"
#import "MHAliyunManager.h"
#import "MHHUDManager.h"

#import "NSObject+isNull.h"

@interface MHReportRepairNewViewModel()
@property (nonatomic,strong,readwrite)NSMutableArray *dataSource;
@property (nonatomic,strong,readwrite)RACCommand *reportNewCommand;
@property (nonatomic,strong,readwrite)RACSubject *refreshViewSubject;
@property (nonatomic,strong,readwrite)RACCommand *reportNewGetRoomInfoCommand;
@property (nonatomic,copy) NSString *roomInfo;
@property (nonatomic,copy) NSString *repair_room;
@property (nonatomic,copy) NSString *room_title;
@property (nonatomic,copy) NSString *room_placeholder;

@property (nonatomic,strong)NSDictionary *dic_item0;
@property (nonatomic,strong)NSDictionary *dic_item1;
@property (nonatomic,strong)NSDictionary *dic_item2;
@property (nonatomic,strong)NSDictionary *dic_item3;
@property (nonatomic,strong)NSDictionary *dic_item4;
@end

@implementation MHReportRepairNewViewModel

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.isEnableSubmit = YES;
    [self loadDataSource];
    [self bindNotificationCenter];
    return self;
}

- (void)loadDataSource {
    [MHReportRepairNewModel share].contact_man = @"";
    [MHReportRepairNewModel share].contact_tel = @"";
    self.repair_room = @"";
    
    self.controllerTitle = @"填写报修单";
    
    _dic_item0 = @{@"title":@"报修类型",
                   @"content":@"",
                   @"placeholder":@"请选择报修类型",
                   @"hasArrow":@1,
                   @"isEnableEdit":@0,
                   @"bottomLineHidden":@0};
    _dic_item1 = @{@"title":@"",
                   @"content":@""};
    _dic_item2 = @{@"title":@"报修房间",
                   @"content":@"",
                   @"placeholder":@"请选择报修房间",
                   @"hasArrow":@1,
                   @"isEnableEdit":@0,
                   @"bottomLineHidden":@1};
    _dic_item3 = @{@"title":@"联系人",
                   @"placeholder":@"请输入联系人姓名",
                   @"hasArrow":@0,
                   @"topLinePadding":@16,
                   @"limitCount":@10,
                   @"isEnableEdit":@1,
                   @"bottomLineHidden":@1};
    _dic_item4 = @{@"title":@"联系方式",
                   @"placeholder":@"请输入联系方式",
                   @"hasArrow":@0,
                   @"isEnableEdit":@1,
                   @"limitCount":@12,
                   @"topLinePadding":@16,
                   @"bottomLineHidden":@0};
    self.dataSource = [NSMutableArray arrayWithObjects:@[_dic_item0],@[_dic_item1],@[_dic_item2,_dic_item3,_dic_item4],nil];

    RACSignal *roomSignal = RACObserve([MHReportRepairNewModel share], room_json);
    RACSignal *repairmentCategoryIdSignal = RACObserve([MHReportRepairNewModel share], repairment_category_id);
    RACSignal *contacttelSignal = RACObserve([MHReportRepairNewModel share], contact_tel);
    RACSignal *repairmentcontSignal = RACObserve([MHReportRepairNewModel share], repairment_cont);
    RACSignal *contactmanSignal = RACObserve([MHReportRepairNewModel share], contact_man);

    RACSignal *indoorSignal = [RACSignal merge:@[roomSignal,repairmentCategoryIdSignal,contacttelSignal,contactmanSignal,repairmentcontSignal]];

    @weakify(self)
    [indoorSignal subscribeNext:^(id _Nullable x) {
        @strongify(self)
        NSMutableDictionary *dic = [[MHReportRepairNewModel share] yy_modelToJSONObject];
        [dic removeObjectForKey:@"images"];
        [dic removeObjectForKey:@"is_indoor"];
        [dic removeObjectForKey:@"community_id"];
        [dic removeObjectForKey:@"cache_room_json"];
        BOOL in_door = [MHReportRepairNewModel share].is_indoor;
        if([dic[@"repairment_cont"] isEqualToString:@""]){
            [dic removeObjectForKey:@"repairment_cont"];
        }
        if([dic[@"contact_man"] isEqualToString:@""]){
            [dic removeObjectForKey:@"contact_man"];
        }
        if([dic[@"contact_tel"] isEqualToString:@""]){
            [dic removeObjectForKey:@"contact_tel"];
        }
        if ([dic[@"room_json"] isEqualToString:@""]) {
            [dic removeObjectForKey:@"room_json"];
        }
        NSArray *keys = [dic allKeys];
        NSSet *set2 = [NSSet setWithArray:keys];
        NSSet *set1;
        if (in_door) {
            set1 = [NSSet setWithArray:@[@"room_json",@"repairment_category_id",@"contact_tel",@"repairment_cont",@"contact_man"]];
        }else {
            set1 = [NSSet setWithArray:@[@"repairment_category_id",@"contact_tel",@"repairment_cont",@"contact_man"]];
        }
        
        if ([set1 isSubsetOfSet:set2]) {
            self.isEnableSubmit = YES;
        }else {
            self.isEnableSubmit = NO;
        }
    }];
 }

- (void)bindNotificationCenter {
    RACSignal *notification = [[[NSNotificationCenter defaultCenter]
                                rac_addObserverForName:@"kMHReportRepairSelectedType" object:nil] takeUntil:self.rac_willDeallocSignal];
    RACSignal *room_notification = [[[NSNotificationCenter defaultCenter]
                                rac_addObserverForName:@"kReloadVolSerMyCardControllerAddressNotification" object:nil] takeUntil:self.rac_willDeallocSignal];

    @weakify(self)
    [notification subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSNotification *obj = x;
        NSDictionary *object = obj.object;
        
        NSNumber *parent_id = object[@"parent_id"];
        [MHReportRepairNewModel share].repairment_category_id = object[@"roomid"];

        NSString *type_title = @"报修类型";
        self.room_title = @"报修房间";
        self.room_placeholder = @"请选择报修房间";
        self.controllerTitle = @"填写报修单";

        if ([parent_id isEqualToNumber:@22]) {//填写投诉单修改更新页面标题为“填写投诉单”、原来的报修类型改成“类型”、原来的报修房间改成“房间号”，房间号为非必填项
            type_title = @"类型";
            self.room_title = @"房间号";
            self.room_placeholder = @"请选择房间号";
            self.controllerTitle = @"填写投诉单";
        }
        
        [self getLastRepairUserInfo:self.repair_room];
        
        self.dic_item2 = @{@"title":self.room_title,
                           @"content":self.repair_room,
                           @"placeholder":self.room_placeholder,
                           @"hasArrow":@1,
                           @"isEnableEdit":@0,
                           @"bottomLineHidden":@1};
        
        NSDictionary *dic_item = @{@"title":type_title,
                                    @"content":object[@"room"],
                                    @"placeholder":@"请选择报修类型",
                                    @"hasArrow":@1,
                                    @"isEnableEdit":@0,
                                    @"bottomLineHidden":@0};
        
        [self.dataSource replaceObjectAtIndex:2 withObject:@[self.dic_item2,self.dic_item3,self.dic_item4]];
        [self.dataSource replaceObjectAtIndex:0 withObject:@[dic_item]];
        [self.refreshViewSubject sendNext:nil];
    }];
    [room_notification subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSNotification *obj = x;
        NSMutableDictionary *object = [NSMutableDictionary dictionaryWithDictionary:obj.object];
        self.repair_room = [NSString stringWithFormat:@"%@-%@-%@",object[@"city"],object[@"community"],object[@"room"]];
        
        [MHReportRepairNewModel share].community_id = object[@"community_id"];
        [object removeObjectForKey:@"community_id"];
        [MHReportRepairNewModel share].cache_room_json = [object yy_modelToJSONString];
        object[@"room"] = [NSString stringWithFormat:@"%@-%@",object[@"community"],object[@"room"]];
        [MHReportRepairNewModel share].room_json = [object yy_modelToJSONString];

        [self getLastRepairUserInfo:self.repair_room];

        [self.dataSource replaceObjectAtIndex:2 withObject:@[self.dic_item2,self.dic_item3,self.dic_item4]];
        [self.refreshViewSubject sendNext:nil];
    }];
    
    [self.reportNewGetRoomInfoCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [MHHUDManager dismiss];
        [self handleRepairUserInfo:x];
    }];
}

- (void)handleRepairUserInfo:(NSDictionary *)result {
    NSString *roomInfo = result[@"room_json"];
    //认证住户
    if (![NSObject isNull:roomInfo]) {
        NSData *jsonData = [roomInfo dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *mu_dic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *city = dic[@"city"];
        NSString *community = dic[@"community"];
        NSString *room = dic[@"room"];
        
        NSString *community_repalce = [NSString stringWithFormat:@"%@-",community];
        room = [room stringByReplacingOccurrencesOfString:community_repalce withString:@""];
        mu_dic[@"room"] = room;
        [MHReportRepairNewModel share].cache_room_json = [mu_dic yy_modelToJSONString];

        self.repair_room = [NSString stringWithFormat:@"%@-%@-%@",city,community,room];
        mu_dic[@"room"] = [NSString stringWithFormat:@"%@-%@",community,room];
        [MHReportRepairNewModel share].room_json = [mu_dic yy_modelToJSONString];
    }
    
    NSString *username = @"";
    NSString *userphone = @"";
    
    NSString *temp_username = result[@"nick_name"];
    NSString *temp_userphone = result[@"phone_number"];
    if (temp_username) {
        username = temp_username;
    }
    if (temp_userphone) {
        userphone = temp_userphone;
    }
    
    [MHReportRepairNewModel share].contact_man = username;
    [MHReportRepairNewModel share].contact_tel = userphone;
    [MHReportRepairNewModel share].community_id = result[@"community_id"];

    [self getLastRepairUserInfo:self.repair_room];
  
    [self.dataSource replaceObjectAtIndex:2 withObject:@[self.dic_item2,self.dic_item3,self.dic_item4]];
    [self.refreshViewSubject sendNext:nil];

}
- (void)getLastRepairUserInfo:(NSString *)repair_room {
    self.dic_item2 = @{@"title":self.room_title,
                       @"content":repair_room,
                       @"placeholder":self.room_placeholder,
                       @"hasArrow":@1,
                       @"isEnableEdit":@0,
                       @"bottomLineHidden":@1};
    self.dic_item3 = @{@"title":@"联系人",
                       @"content":[MHReportRepairNewModel share].contact_man,
                       @"placeholder":@"请输入联系人姓名",
                       @"hasArrow":@0,
                       @"topLinePadding":@16,
                       @"limitCount":@10,
                       @"isEnableEdit":@1,
                       @"bottomLineHidden":@1};
    self.dic_item4 = @{@"title":@"联系方式",
                       @"content":[MHReportRepairNewModel share].contact_tel,
                       @"placeholder":@"请输入联系方式",
                       @"hasArrow":@0,
                       @"isEnableEdit":@1,
                       @"limitCount":@12,
                       @"topLinePadding":@16,
                       @"bottomLineHidden":@0};
}

- (void)submitRepairInfo {
    [MHHUDManager show];
    if ([MHReportRepairNewModel share].imgs) {
        [self.reportNewCommand execute:nil];
        return;
    }
    @weakify(self);
    [[MHAliyunManager sharedManager]uploadImageToAliyunWithArrayImage:[MHReportRepairNewModel share].images success:^(NSArray<MHOOSImageModel *> *imageModels) {
        @strongify(self)
        NSMutableArray *imgs = [NSMutableArray array];
        [imageModels enumerateObjectsUsingBlock:^(MHOOSImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"file_id"] = obj.file_id;
            dic[@"file_url"] = obj.file_url;
            dic[@"img_height"] = obj.img_height;
            dic[@"img_width"] = obj.img_width;
            [imgs addObject:dic];
        }];
        [MHReportRepairNewModel share].imgs = [imgs yy_modelToJSONString];
        [self.reportNewCommand execute:nil];
    } failed:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
    
  }

#pragma mark - Getter
- (RACCommand *)reportNewCommand {
    if (!_reportNewCommand) {
        _reportNewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSMutableDictionary *dic = [[MHReportRepairNewModel share] yy_modelToJSONObject];
                [dic removeObjectForKey:@"images"];
                [dic removeObjectForKey:@"is_indoor"];
                [dic removeObjectForKey:@"community_id"];
                [dic removeObjectForKey:@"cache_room_json"];
                [[MHNetworking shareNetworking] post:@"repair/add" params:dic success:^(id data) {
                    [subscriber sendNext:data];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [MHHUDManager showErrorText:errmsg];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _reportNewCommand;
}

- (RACCommand *)reportNewGetRoomInfoCommand {
    if (!_reportNewGetRoomInfoCommand) {
        _reportNewGetRoomInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            [MHHUDManager show];
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[MHNetworking shareNetworking] post:@"repair/getInfo" params:nil success:^(id data) {
                    [subscriber sendNext:data];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [MHHUDManager showErrorText:errmsg];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _reportNewGetRoomInfoCommand;
}

- (RACSubject*)refreshViewSubject {
    if (!_refreshViewSubject) {
        _refreshViewSubject = [RACSubject subject];
    }
    return _refreshViewSubject;
}


@end
