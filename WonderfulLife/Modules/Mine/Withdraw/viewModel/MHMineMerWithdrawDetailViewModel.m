//
//  MHMineMerWithdrawDetailViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawDetailViewModel.h"
#import "MHMineMerWithDrawParameter.h"

@interface MHMineMerWithdrawDetailViewModel()
//提现详情
@property (nonatomic,strong,readwrite)RACCommand *widthdrawDetailCommand;

@end

@implementation MHMineMerWithdrawDetailViewModel

#pragma mark - lazyload

//提现详情
- (RACCommand *)widthdrawDetailCommand{
    if(!_widthdrawDetailCommand){
        @weakify(self);
        _widthdrawDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *isRefresh) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if([isRefresh boolValue]){
                    self.page = 1;
                }else{
                    self.page ++;
                }
                //提现详情
                NSDictionary *parameter = [MHMineMerWithDrawParameter merchantWithdrawRecordDetailWithWithdraw_no:self.withdraw_no page:self.page];
                
                
                [[MHNetworking shareNetworking] post:API_mall_merchant_withdraw_record_get params:parameter success:^(id data) {
                    if([self checkDataWithClass:[NSDictionary class] data:data subscriber:subscriber]){
                        
                        self.detailModel = [MHMineMerWithdrawDetailModel yy_modelWithJSON:data];
                        
                        
                        NSDictionary *finance_record_list = data[@"finance_record_list"];
                        
                        self.total_pages = [finance_record_list[@"total_pages"] integerValue];
                        
                        if([isRefresh boolValue]){
                            [self.dataSoure removeAllObjects];
                        }
                        NSArray *arr = [NSArray yy_modelArrayWithClass:MHMineMerWithdrawFinanceRecordModel.class json:finance_record_list[@"list"]];
                        if(arr && arr.count){
                            [self.dataSoure addObjectsFromArray:arr];
                        }
                        NSInteger paging_type = [finance_record_list[@"paging_type"] integerValue];
                        //page分页方式,以页码分页
                        if(paging_type == 0){
                            self.has_next = [finance_record_list[@"has_next"] boolValue];
                        }else if(paging_type == 1){//page_id分页方式,以记录id分页
                            if(self.dataSoure.count >= self.total_pages){
                                self.has_next = NO;
                            }else{
                                self.has_next = YES;
                            }
                        }
                        
                        [subscriber sendNext:@(self.has_next)];
                        [subscriber sendCompleted];
                    }else{
                        if(self.page > 1){
                            //还原page回去,不然再拉page就要跳页了
                            self.page --;
                        }
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
    return _widthdrawDetailCommand;
}
@end
