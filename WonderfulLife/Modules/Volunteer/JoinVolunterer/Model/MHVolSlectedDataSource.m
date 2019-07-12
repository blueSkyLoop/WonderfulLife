//
//  MHVolSlectedDataSource.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSlectedDataSource.h"
#import "MHTitleSectionView.h"
#import "MHLoSelectPlotCell.h"
#import "MHCommunityModel.h"

#import "MHMacros.h"
#import "NSString+HLJudge.h"
@implementation MHVolSlectedDataSource
#pragma mark - Getter

- (RACSubject*)resultSubject {
    if (!_resultSubject) {
        _resultSubject = [RACSubject subject];
    }
    return _resultSubject;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.resultSubject sendNext:indexPath];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![self.searchText hl_isEmpty]) return ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 0.5)];
        [view setBackgroundColor:MColorSeparator];
        view;
    });
    MHTitleSectionView *sectionView = [[MHTitleSectionView alloc]initWithFrame:CGRectZero];
    if (self.allPlots.count == 0){
        return nil;
    }else{
        MHCommunityModel *community =  self.allPlots[0];
        sectionView.topLine.hidden = YES;
        sectionView.bottomLine.hidden = YES;
        if (self.allPlots.count == 1 && [community.community_name isEqualToString:@"体验小区"]){
            [sectionView.titleLabel setText:@"您搜索的小区暂未开通服务，您可尝试加入体验小区"];
            sectionView.titleLabel.textColor = MColorFootnote ;
            sectionView.titleLabel.font = [UIFont systemFontOfSize:13.0];
        }else{
            [sectionView.titleLabel setText:@"所有小区"];
        }
    }return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHLoSelectPlotCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHLoSelectPlotCell class])];
    MHCommunityModel *model;
    if ([self.searchText hl_isEmpty])
        model = self.allPlots[indexPath.row];
    else
        model = self.searchPlots[indexPath.row];
    [cell.mh_titleLabel setText:model.community_name];
    [cell.mh_subLabel setText:model.community_address];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchText hl_isEmpty])
        return self.allPlots.count;
    else
        return self.searchPlots.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.searchText hl_isEmpty]){
        if (self.allPlots.count){
            return 32;
        }else return  0.01 ;
        
    }else   return 0.5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

@end
