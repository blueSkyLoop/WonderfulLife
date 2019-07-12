//
//  MHBaseViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"
#import "NSObject+parser.h"

@interface MHBaseViewModel()

@property (nonatomic,strong,readwrite)RACCommand *baseRequestCommond;
@property (nonatomic,strong,readwrite)RACSignal *baseSignal;

@property (nonatomic,strong,readwrite)LNHttpConfig *currentConfig;

@property (nonatomic,strong,readwrite)RACSubject *requestSuccessSubject;
@property (nonatomic,strong,readwrite)RACSubject *requestFailureSubject;

@end

@implementation MHBaseViewModel

- (id)init{
    self = [super init];
    if(self){
        [self mh_initialize];
        [self mh_baseRequestBind];
    }
    return self;
}

- (void)mh_initialize{}

- (void)mh_baseRequestBind{
    @weakify(self);
    [self.baseRequestCommond.executionSignals.switchToLatest subscribeNext:^(id data) {
        @strongify(self);
        if(self.resultBlock){
            self.resultBlock(YES, self.currentConfig.apiFlag, 0, data,self.currentConfig.orginData, nil);
        }
        
    }];
    
    [self.baseRequestCommond.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        if(self.currentConfig.errorShowMessage){
            [MHHUDManager showText:error.userInfo[@"errmsg"] Complete:^{
                if(self.resultBlock){
                    self.resultBlock(NO, self.currentConfig.apiFlag, error.code, nil,self.currentConfig.orginData, error.userInfo[@"errmsg"]);
                }
            }];
        }else{
            if(self.resultBlock){
                self.resultBlock(NO, self.currentConfig.apiFlag, error.code, nil,self.currentConfig.orginData, error.userInfo[@"errmsg"]);
            }
        }
    }];
    
}

//实例化一个基础的请求配置
- (LNHttpConfig *)mh_defaultHttpConfigWithApi:(NSString *)apiStr{
    LNHttpConfig *config = [LNHttpConfig defaultHttpConfig];
    config.apiStr = apiStr;
    return config;
}

//开启一个请求,对于开启一个接口，关注的应该是这个请求的配置，中间请求过程和结果处理无需关心，因为配置已经决定了请求和结果处理
- (void)startHttpWithRequestConfig:(LNHttpConfig *)model{
    self.currentConfig = model;
    [self reStartHttp];
}

//重新请求和上一次请求一样的请求
- (void)reStartHttp{
    if(self.currentConfig){
        [self.baseRequestCommond execute:nil];
    }
}

//统一处理错误信息
- (void)handleErrmsg:(NSString *)errmsg errorCodeNum:(NSNumber *)errorCodeNum  subscriber:(id<RACSubscriber>)subscriber{
    NSError *error = [NSError errorWithDomain:@"" code:errorCodeNum?errorCodeNum.integerValue:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
    [subscriber sendError:error];
    [subscriber sendCompleted];
}

//检测数据的返回类型是否符合，不符合的话内部会作错误处理发送
- (BOOL)checkDataWithClass:(Class)aclass data:(id)data subscriber:(id<RACSubscriber>)subscriber{
    if(!aclass) return YES;
    if(data && [data isKindOfClass:aclass]){
        return YES;
    }
    [self handleErrmsg:nil errorCodeNum:nil subscriber:subscriber];
    return NO;
}

//成功数据的处理
- (void)handleSuccessData:(id)data subscriber:(id<RACSubscriber>)subscriber{

    if([self checkDataWithClass:NSClassFromString(self.currentConfig.checkClassName) data:data subscriber:subscriber]){
        //保留原始数据,供外部选择性地使用
        self.currentConfig.orginData = data;
        if(self.currentConfig.parserBlock){
            id adata = [data ln_parseMake:^(LNParserMarker *make) {
                self.currentConfig.parserBlock(make);
            }];
            [subscriber sendNext:adata];
        }else{
            [subscriber sendNext:data];
        }
        [subscriber sendCompleted];
        
    }
    
}

- (RACCommand *)baseRequestCommond{
    if(!_baseRequestCommond){
        @weakify(self);
        _baseRequestCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return self.baseSignal;
        }];
    }
    return _baseRequestCommond;
}

- (RACSignal *)baseSignal{
    if(!_baseSignal){
        @weakify(self);
        _baseSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            
            if(self.currentConfig.needShow){
                [MHHUDManager show];
            }
            //get 请求
            if(self.currentConfig.method == LNRequestMethodGet){
                
                [[MHNetworking shareNetworking] get:self.currentConfig.apiStr params:self.currentConfig.parameter progress:[self.currentConfig.progressBlock copy] success:^(id data) {
                    if(self.currentConfig.needShow){
                        [MHHUDManager dismiss];
                    }
                    [self handleSuccessData:data subscriber:subscriber];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    if(self.currentConfig.needShow){
                        [MHHUDManager dismiss];
                    }
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                
            }else if(self.currentConfig.method == LNRequestMethodPost){//post 请求
                
                [[MHNetworking shareNetworking] post:self.currentConfig.apiStr params:self.currentConfig.parameter progress:[self.currentConfig.progressBlock copy] success:^(id data) {
                    if(self.currentConfig.needShow){
                        [MHHUDManager dismiss];
                    }
                    [self handleSuccessData:data subscriber:subscriber];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    if(self.currentConfig.needShow){
                        [MHHUDManager dismiss];
                    }
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                
            }
            
            return nil;
        }];
    }
    return _baseSignal;
}

- (RACSubject *)requestSuccessSubject{
    if(!_requestSuccessSubject){
        _requestSuccessSubject = [RACSubject subject];
    }
    return _requestSuccessSubject;
}

- (RACSubject *)requestFailureSubject{
    if(!_requestFailureSubject){
        _requestFailureSubject = [RACSubject subject];
    }
    return _requestFailureSubject;
}

- (NSMutableArray *)dataSoure{
    if(!_dataSoure){
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}


@end
