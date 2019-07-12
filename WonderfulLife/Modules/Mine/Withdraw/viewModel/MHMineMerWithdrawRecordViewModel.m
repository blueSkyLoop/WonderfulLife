//
//  MHMineMerWithdrawRecordViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawRecordViewModel.h"
#import "MHMineMerWithdrawRecordModel.h"
#import "MHMineMerWithDrawParameter.h"

@interface MHMineMerWithdrawRecordViewModel()

//申请记录
@property (nonatomic,strong,readwrite)RACCommand *widthdrawRecordCommand;

@end

@implementation MHMineMerWithdrawRecordViewModel

#pragma mark - lazyload
//申请记录
- (RACCommand *)widthdrawRecordCommand{
    if(!_widthdrawRecordCommand){
        @weakify(self);
        _widthdrawRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *isRefresh) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if([isRefresh boolValue]){
                    self.page = 1;
                }else{
                    self.page ++;
                }
                //提现详情
                NSDictionary *parameter = [MHMineMerWithDrawParameter merchantWithdrawReocrdListWithPage:self.page];
                
                [[MHNetworking shareNetworking] post:API_mall_merchant_withdraw_record_list params:parameter success:^(id data) {
                    if([self checkDataWithClass:[NSDictionary class] data:data subscriber:subscriber]){
                        
                        self.total_pages = [data[@"total_pages"] integerValue];
                        
                        if([isRefresh boolValue]){
                            [self.dataSoure removeAllObjects];
                        }
                        NSArray *arr = [NSArray yy_modelArrayWithClass:MHMineMerWithdrawRecordModel.class json:data[@"list"]];
                        if(arr && arr.count){
                            [self.dataSoure addObjectsFromArray:arr];
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
    return _widthdrawRecordCommand;
}

@end
