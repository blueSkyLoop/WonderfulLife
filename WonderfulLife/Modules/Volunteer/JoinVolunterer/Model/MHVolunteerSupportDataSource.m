//
// MHVolunteerSupportDataSource.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolunteerSupportDataSource.h"

#import "MHVolunteerSupportModel.h"
#import "MHVolunteerSupportCell.h"
@interface MHVolunteerSupportDataSource ()

@property (nonatomic, strong,readwrite) NSMutableArray  *results;

@property (nonatomic, copy)   NSArray *datas;

@property (nonatomic, copy)   VolunteerSupportBlock supportBlock;

@end

@implementation MHVolunteerSupportDataSource

#pragma mark - Getter
- (void)volunteerSupportDataSourcWithDatas:(NSArray *)datas volunteerSupportBlock:(VolunteerSupportBlock)complete{
    self.datas = [datas copy];
    self.supportBlock = complete;

    [self.datas enumerateObjectsUsingBlock:^(MHVolunteerSupportModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.is_own == 1 ? [self.results addObject:obj] : [self.results removeObject:obj];
        self.supportBlock(self.results);
    }];
}
#pragma mark - SetUI

- (NSMutableArray *)results{
    if (!_results) {
        _results = [NSMutableArray array];
    }return _results;
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVolunteerSupportCell *cell = [MHVolunteerSupportCell cellWithTableView:tableView];
    
    MHVolunteerSupportModel *model = self.datas[indexPath.row];
    cell.model = model;
    return cell ;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MHVolunteerSupportModel *dataModel = self.datas[indexPath.row];
    
    dataModel.is_own = dataModel.is_own == 0 ? 1 : 0; // 点击时转换状态
    
    dataModel.is_own == 1 ? [self.results addObject:dataModel] : [self.results removeObject:dataModel];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    self.supportBlock(self.results);
}




@end
