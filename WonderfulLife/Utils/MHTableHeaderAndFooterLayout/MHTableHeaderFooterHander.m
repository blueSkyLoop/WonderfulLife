//
//  MHTableHeaderFooterHander.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHTableHeaderFooterHander.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIView+MHMHAutoCalculaSize.h"

@interface MHTableHeaderFooterHander()

@property (nonatomic,readwrite,weak)UIView *tableHeaderFooterView;
@property (nonatomic,readwrite,weak)UITableView *tableView;
/*
 type 描述
 0 表示tableHeaderView
 1 表示tableFooterView
 */
@property (nonatomic,assign)NSInteger type;

@end

@implementation MHTableHeaderFooterHander

- (void)dealloc{
    NSLog(@"%s",__func__);
}

/** 创建headerView 执行者*/
+ (instancetype)mh_tableHeaderViewWithView:(UIView *)headerView refresBlock:(MHTableHeadFootRefreshDataBlock)refresBlock{
    MHTableHeaderFooterHander *header = [[self alloc] init];
    header.refrehBlock = [refresBlock copy];
    header.tableHeaderFooterView = headerView;
    header.type = 0;
    return header;
}
/** 创建headerView 执行者 其中action不能携带参数*/
+ (instancetype)mh_tableHeaderViewWithView:(UIView *)headerView target:(id)target refrehAction:(SEL)action{
    MHTableHeaderFooterHander *header = [[self alloc] init];
    header.refreshAction = action;
    header.refreshTarget = target;
    header.tableHeaderFooterView = headerView;
    header.type = 0;
    return header;
}

/** 创建footerView 执行者*/
+ (instancetype)mh_tableFooterViewWithView:(UIView *)footerView refresBlock:(MHTableHeadFootRefreshDataBlock)refresBlock{
    MHTableHeaderFooterHander *footer = [[self alloc] init];
    footer.refrehBlock = [refresBlock copy];
    footer.tableHeaderFooterView = footerView;
    footer.type = 1;
    return footer;
}
/** 创建footerView 执行者 其中action不能携带参数*/
+ (instancetype)mh_tableFooterViewWithView:(UIView *)footerView target:(id)target refrehAction:(SEL)action{
    MHTableHeaderFooterHander *footer = [[self alloc] init];
    footer.refreshAction = action;
    footer.refreshTarget = target;
    footer.tableHeaderFooterView = footerView;
    footer.type = 1;
    return footer;
}

/*刷新数据*/
- (void)mh_refreshData{
    if(self.refrehBlock){
        self.refrehBlock(self.tableHeaderFooterView);
    }
    if(self.refreshTarget && self.refreshAction && [self.refreshTarget respondsToSelector:self.refreshAction]){
        ((void(*)(id,SEL))objc_msgSend)(self.refreshTarget,self.refreshAction);
    }
    /*数据更新完比之后会计算高度，并判断要不要修改frame,并更新相应的tableHeaderView 或 tableFooterView*/
    [self mh_headerFooterUpdate];
    
}

/*初始设置tableHeadView 或者tableFootView*/
- (void)mh_initHeaderOrFooterViewWithTableView:(UITableView *)tableView{
    self.tableView = tableView;
//    self.tableHeaderFooterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self mh_headerFooterUpdate];
}

- (void)mh_headerFooterUpdate{
    
    if(self.type == 0){
        [self mh_tableHeaderHandle];
    }else if(self.type == 1){
        [self mh_tableFooterHandle];
    }
}

- (void)mh_tableHeaderHandle{
    CGSize asize = [self.tableHeaderFooterView mh_autoCalculaSize];
    if(self.tableView.tableHeaderView && self.tableView.tableHeaderView == self.tableHeaderFooterView){
        CGSize size = self.tableHeaderFooterView.frame.size;
        if(!CGSizeEqualToSize(asize, size)){
            self.tableHeaderFooterView.frame = CGRectMake(0, 0, asize.width, asize.height);
            self.tableView.tableHeaderView = self.tableHeaderFooterView;
        }
    }else{
        self.tableHeaderFooterView.frame = CGRectMake(0, 0, asize.width, asize.height);
        if(self.tableView.tableHeaderView){
            [self.tableView.tableHeaderView removeFromSuperview];
        }
        self.tableView.tableHeaderView = self.tableHeaderFooterView;
    }
}

- (void)mh_tableFooterHandle{
    CGSize asize = [self.tableHeaderFooterView mh_autoCalculaSize];
    if(self.tableView.tableFooterView && self.tableView.tableFooterView == self.tableHeaderFooterView){
        CGSize size = self.tableHeaderFooterView.frame.size;
        if(!CGSizeEqualToSize(asize, size)){
            self.tableHeaderFooterView.frame = CGRectMake(0, 0, asize.width, asize.height);
            self.tableView.tableFooterView = self.tableHeaderFooterView;
        }
    }else{
        self.tableHeaderFooterView.frame = CGRectMake(0, 0, asize.width, asize.height);
        if(self.tableView.tableFooterView){
            [self.tableView.tableFooterView removeFromSuperview];
        }
        self.tableView.tableFooterView = self.tableHeaderFooterView;
    }
}


@end
