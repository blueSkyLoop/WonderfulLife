//
//  MHBaseListPageViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/12/29.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

@interface LNListPageHttpConfig : LNHttpConfig

//分页列表解析器，这里只要解析到分页层即可
@property (nonatomic,copy)void (^ListParserBlock)(LNParserMarker *marker);

//返回一个默认配置的请求配置
+ (LNListPageHttpConfig *)listDefaultHttpConfig;

@end

@interface MHBaseListPageViewModel : MHBaseViewModel

@property (nonatomic,assign)NSInteger mh_currentPage;
@property (nonatomic,assign)NSInteger mh_total_pages;
@property (nonatomic,assign)BOOL mh_has_next;
@property (nonatomic,assign)BOOL mh_isRefresh;

//实例化一个分页列表的基础的请求配置
- (LNListPageHttpConfig *)mh_listDefaultHttpConfigWithApi:(NSString *)apiStr;

@end
