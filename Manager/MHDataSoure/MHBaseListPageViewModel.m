//
//  MHBaseListPageViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/12/29.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseListPageViewModel.h"
#import "NSObject+parser.h"

@implementation LNListPageHttpConfig


//返回一个默认配置的请求配置
+ (LNListPageHttpConfig *)listDefaultHttpConfig{
    LNListPageHttpConfig *config = [[LNListPageHttpConfig alloc] initWithDefaultHttpConfig];
    return config;
}

@end

@implementation MHBaseListPageViewModel

//实例化一个分页列表的基础的请求配置
- (LNListPageHttpConfig *)mh_listDefaultHttpConfigWithApi:(NSString *)apiStr{
    LNListPageHttpConfig *config = [LNListPageHttpConfig listDefaultHttpConfig];
    config.apiStr = apiStr;
    return config;
}

//检测数据的返回类型是否符合，不符合的话内部会作错误处理发送
- (BOOL)checkDataWithClass:(Class)aclass data:(id)data subscriber:(id<RACSubscriber>)subscriber{
    if(!aclass) return YES;
    if(data && [data isKindOfClass:aclass]){
        return YES;
    }
    if([self.currentConfig isKindOfClass:[LNListPageHttpConfig class]]){
        if(self.mh_currentPage > 1){
            //还原page回去,不然再拉page就要跳页了
            self.mh_currentPage --;
        }
    }
    [self handleErrmsg:nil errorCodeNum:nil subscriber:subscriber];
    return NO;
}

//成功数据的处理
- (void)handleSuccessData:(id)data subscriber:(id<RACSubscriber>)subscriber{
    
    if([self.currentConfig isKindOfClass:[LNListPageHttpConfig class]]){
        
        if([self checkDataWithClass:NSClassFromString(self.currentConfig.checkClassName) data:data subscriber:subscriber]){
            //保留原始数据,供外部选择性地使用
            self.currentConfig.orginData = data;
            LNListPageHttpConfig *listConfig = (LNListPageHttpConfig *)self.currentConfig;
            NSDictionary *pageDict = data;
            //有可能列表在里面好几层，所以从里面解析，默认是data
            if(listConfig.ListParserBlock){
                pageDict = [data ln_parseMake:^(LNParserMarker *make) {
                    listConfig.ListParserBlock(make);
                }];
            }
            if(![pageDict isKindOfClass:[NSDictionary class]]){
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return;
            }
            
            self.mh_total_pages = [pageDict[@"total_pages"] integerValue];
            if(self.mh_isRefresh){
                [self.dataSoure removeAllObjects];
            }
            NSArray *pageArr;
            //解析列表，其实就是数组转模型
            if(self.currentConfig.parserBlock){
                
                pageArr = [pageDict ln_parseMake:^(LNParserMarker *make) {
                    self.currentConfig.parserBlock(make);
                }];
        
            }
            if(pageArr && pageArr.count){
                [self.dataSoure addObjectsFromArray:pageArr];
            }
            NSInteger paging_type = [pageDict[@"paging_type"] integerValue];
            //page分页方式,以页码分页
            if(paging_type == 0){
                self.mh_has_next = [pageDict[@"has_next"] boolValue];
            }else if(paging_type == 1){//page_id分页方式,以记录id分页
                if(self.dataSoure.count >= self.mh_total_pages){
                    self.mh_has_next = NO;
                }else{
                    self.mh_has_next = YES;
                }
            }
            self.mh_isRefresh = NO;
            [subscriber sendNext:@(self.mh_has_next)];
            
            [subscriber sendCompleted];
            
        }
        
        
    }else{
        [super handleSuccessData:data subscriber:subscriber];
    }
    
    
}

@end
