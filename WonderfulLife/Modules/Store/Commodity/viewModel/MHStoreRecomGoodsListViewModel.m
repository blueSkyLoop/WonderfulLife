//
//  MHStoreRecomGoodsListViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRecomGoodsListViewModel.h"
#import "MHStoreCommodityParameter.h"
#import "MHUserInfoManager.h"
#import "MHStoreGoodsHandler.h"

#import "MHStoreRecomGoodsListModel.h"
#import "NSObject+AutoProperty.h"

@interface MHStoreRecomGoodsListViewModel()

@property (nonatomic,strong,readwrite)RACCommand *goodsListCommand;
//搜索商品列表
@property (nonatomic,strong,readwrite)RACCommand *searchGoodListCommand;
@property (nonatomic,strong,readwrite)RACSubject *UIRefreshSubject;

@end

@implementation MHStoreRecomGoodsListViewModel

- (void)mh_initialize{
    
    @weakify(self);
    [self.goodsListCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.listRequesting = [x boolValue];
    }];
    [self.searchGoodListCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.listRequesting = [x boolValue];
    }];
    
}

- (BOOL)isExsitObjectWithCoupon_id:(NSInteger)coupon_id{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"coupon_id == %ld",coupon_id];
    NSArray *arr = [self.dataSoure filteredArrayUsingPredicate:predicate];
    return arr.count?YES:NO;
    
}

- (void)updateLocation{
    if([MHStoreGoodsHandler shareManager].current_gps_lat && [MHStoreGoodsHandler shareManager].current_gps_lng){
        self.current_gps_lng = [MHStoreGoodsHandler shareManager].current_gps_lng;
        self.current_gps_lat = [MHStoreGoodsHandler shareManager].current_gps_lat;
    }
}


#pragma mark - lazyLoad
//推荐商品列表
- (RACCommand *)goodsListCommand{
    if(!_goodsListCommand){
        @weakify(self);
        _goodsListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *isRefresh) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if([isRefresh boolValue]){
                    self.page = 1;
                    //刷新要更新定位信息
                    [self updateLocation];
                }else{
                    self.page ++;
                }
                //推荐商品列表
                NSDictionary *parameter = [MHStoreCommodityParameter recommendGoodsListWithCommunity_id:self.community_id
                                                                                                gps_lng:self.current_gps_lng?[NSString stringWithFormat:@"%@",@(self.current_gps_lng)]:nil
                                                                                                gps_lat:self.current_gps_lat?[NSString stringWithFormat:@"%@",@(self.current_gps_lat)]:nil
                                                                                                   page:self.page];
                
                
                [[MHNetworking shareNetworking] post:API_mall_coupon_recommend_list params:parameter success:^(id data) {
                    if([data isKindOfClass:[NSDictionary class]]){
                        
                        NSDictionary *coupon_list = data[@"coupon_list"];
//                        [NSObject printPropertyWithDict:coupon_list allPropertyCode:nil];
                        
                        self.total_pages = [coupon_list[@"total_pages"] integerValue];
                        
                        if([isRefresh boolValue]){
                            [self.dataSoure removeAllObjects];
                        }
                        NSArray *arr = [NSArray yy_modelArrayWithClass:MHStoreRecomGoodsListModel.class json:coupon_list[@"list"]];
                        if(arr && arr.count){
                            [self.dataSoure addObjectsFromArray:arr];
                        }
                        NSInteger paging_type = [coupon_list[@"paging_type"] integerValue];
                        //page分页方式,以页码分页
                        if(paging_type == 0){
                            self.has_next = [coupon_list[@"has_next"] boolValue];
                        }else if(paging_type == 1){//page_id分页方式,以记录id分页
                            if(self.dataSoure.count >= self.total_pages){
                                self.has_next = NO;
                            }else{
                                self.has_next = YES;
                            }
                        }
                       
                        [self.UIRefreshSubject sendNext:nil];
                        
                        [subscriber sendNext:@(self.has_next)];
                        [subscriber sendCompleted];
                    }else{
                        if(self.page > 1){
                            //还原page回去,不然再拉page就要跳页了
                            self.page --;
                        }
                        [self handleErrmsg:nil errorCodeNum:nil subscriber:subscriber];
                    }
                    
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    if(self.page > 1){
                        //还原page回去,不然再拉page就要跳页了
                        self.page --;
                    }
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                
                }];
                
                return nil;
            }];
        }];
    }
    return _goodsListCommand;
}
//商家商品列表
- (RACCommand *)searchGoodListCommand{
    if(!_searchGoodListCommand){
        @weakify(self);
        _searchGoodListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *isRefresh) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHHUDManager show];
                if([isRefresh boolValue]){
                    self.page = 1;
                    //刷新要更新定位信息
                    [self updateLocation];
                }else{
                    self.page ++;
                }
                NSDictionary *parameter = [MHStoreCommodityParameter searchGoodsListWithCommunity_id:self.community_id
                                                                                           longitude:self.current_gps_lng
                                                                                            latitude:self.current_gps_lat
                                                                                             keyword:self.keyWord
                                                                                                page:self.page];
                
                [[MHNetworking shareNetworking] post:API_mall_coupon_search params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    if([data isKindOfClass:[NSDictionary class]]){
                        
                        NSArray *coupon_list = data[@"list"];
                        
                        self.total_pages = [data[@"total_pages"] integerValue];
                        
                        if([isRefresh boolValue]){
                            [self.dataSoure removeAllObjects];
                        }
                        for(int i = 0;i<coupon_list.count;i++){
                            MHStoreRecomGoodsListModel *model = [[MHStoreRecomGoodsListModel alloc] initWithMerchantCouponDic:coupon_list[i]];
                            [self.dataSoure addObject:model];
                        }
                        NSInteger paging_type = [data[@"paging_type"] integerValue];
                        //page分页方式,以页码分页
                        if(paging_type == 0){
                            self.has_next = [data[@"has_next"] boolValue];
                        }else if(paging_type == 1){//page_id分页方式,以记录id分页
                            if(self.dataSoure.count >= self.total_pages){
                                self.has_next = NO;
                            }else{
                                self.has_next = YES;
                            }
                        }
                        
                        [self.UIRefreshSubject sendNext:nil];
                        
                        [subscriber sendNext:@(self.has_next)];
                        [subscriber sendCompleted];
                    }else{
                        if(self.page > 1){
                            //还原page回去,不然再拉page就要跳页了
                            self.page --;
                        }
                        [self handleErrmsg:nil errorCodeNum:nil subscriber:subscriber];
                    }
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    if(self.page > 1){
                        //还原page回去,不然再拉page就要跳页了
                        self.page --;
                    }
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                return nil;
            }];
        }];
    }
    return _searchGoodListCommand;
}

- (RACSubject *)UIRefreshSubject{
    if(!_UIRefreshSubject){
        _UIRefreshSubject = [RACSubject subject];
    }
    return _UIRefreshSubject;
}

@end
