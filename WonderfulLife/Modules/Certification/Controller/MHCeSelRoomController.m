//
//  MHCeSelRoomController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCeSelRoomController.h"

#import "MHViSelectedCell.h"
#import "MHTitleSectionView.h"

#import "MHCertificationRequestHandler.h"
#import "MHCommunityModel.h"
#import "MHStructAreaModel.h"
#import "MHStructBuildingModel.h"
#import "MHStructUnitModel.h"
#import "MHStructRoomModel.h"

#import "MHMacros.h"
#import "MHHUDManager.h"
#import "LCommonModel.h"
#import "Masonry.h"

@interface MHCeSelRoomController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign,nonatomic) int type;
/** 用于是否判断有内容信息，如果是 “无区域” || “无单元” 决定是否拼接内容信息*/
@property (nonatomic, assign) BOOL has_area;
@property (nonatomic, assign) BOOL has_unit;
@property (nonatomic, strong) NSMutableAttributedString *str;


@property (copy,nonatomic) NSArray<MHStructAreaModel *> *areaList;
@property (copy,nonatomic) NSArray<MHStructBuildingModel *> *buildList;
@property (copy,nonatomic) NSArray<MHStructUnitModel *> *unitList;
@property (copy,nonatomic) NSArray<MHStructRoomModel *> *roomList;

@property (strong,nonatomic) MHStructAreaModel *selectArea;
@property (strong,nonatomic) MHStructBuildingModel *selectBuild;
@property (strong,nonatomic) MHStructUnitModel *selectUnit;
@property (strong,nonatomic) MHStructRoomModel *selectRoom;


//空视图

@property (nonatomic,strong)UIView *emptyView;
@end

@implementation MHCeSelRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHViSelectedCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHViSelectedCell class])];
    self.tableView.tableFooterView = [UIView new];
    [self requestArea];
}

#pragma mark - tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.tableView.contentOffset = CGPointMake(0, 0);
    switch (self.type) {
        case 0:
            self.selectArea = self.areaList[indexPath.row];
            [self requestBuild];
            break;
        case 1:
            self.selectBuild = self.buildList[indexPath.row];
            [self requestUnit];
            break;
        case 2:
            self.selectUnit = self.unitList[indexPath.row];
            [self requestRoom];
            break;
        case 3:
            self.selectRoom = self.roomList[indexPath.row];
            if (self.callBack) self.callBack(self.selectArea, self.selectBuild, self.selectUnit, self.selectRoom);
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHViSelectedCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHViSelectedCell class])];
    switch (self.type) {
        case 0:
            [cell.mh_titleLabel setText:self.areaList[indexPath.row].area];
            cell.hl_nextIv.hidden = NO;
            break;
        case 1:
            [cell.mh_titleLabel setText:self.buildList[indexPath.row].building_no];
            cell.hl_nextIv.hidden = NO;
            break;
        case 2:
            [cell.mh_titleLabel setText:self.unitList[indexPath.row].unit_no];
            cell.hl_nextIv.hidden = NO;
            break;
        case 3:
            [cell.mh_titleLabel setText:self.roomList[indexPath.row].room_no];
            cell.hl_nextIv.hidden = YES;
            break;
        default:
            break;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.type) {
        case 0:
            return self.areaList.count;
            break;
        case 1:
            return self.buildList.count;
            break;
        case 2:
            return self.unitList.count;
            break;
        case 3:
            return self.roomList.count;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return ({
        MHTitleSectionView *view = [[MHTitleSectionView alloc]init];
        view.bottomLine.hidden = YES;
        [view.titleLabel setAttributedText:({
            self.str = [[NSMutableAttributedString alloc]initWithString:@"已选择：" attributes: @{NSForegroundColorAttributeName:MColorTitle}];
            switch (self.type) {
                case 0:
                    break;
                case 1:
                    if (self.has_area) {
                        [self headerTitleAppendAttributedStringWithContent:self.selectArea.area textColor:MColorTitle];
                    }else{
                        
                    }
                    break;
                case 2:
                    if (self.has_area) {
                        [self headerTitleAppendAttributedStringWithContent:[NSString stringWithFormat:@"%@  / ",self.selectArea.area] textColor:MRGBColor(153,169,191)];
                        [self headerTitleAppendAttributedStringWithContent:self.selectBuild.building_no textColor:MColorTitle];
                        
                    }else{
                        [self headerTitleAppendAttributedStringWithContent:self.selectBuild.building_no textColor:MColorTitle];
                    }
                    break;
                case 3:
                    
                    if (self.has_area) {
                        [self headerTitleAppendAttributedStringWithContent:[NSString stringWithFormat:@"%@  / ",self.selectArea.area] textColor:MRGBColor(153,169,191)];
                        
                        if (self.has_unit) {
                            [self headerTitleAppendAttributedStringWithContent:[NSString stringWithFormat:@"%@  / ",self.selectBuild.building_no] textColor:MRGBColor(153,169,191)];
                            [self headerTitleAppendAttributedStringWithContent:self.selectUnit.unit_no textColor:MColorTitle];
                        }else{
                            [self headerTitleAppendAttributedStringWithContent:self.selectBuild.building_no textColor:MRGBColor(153,169,191)];
                        }
                        
                    }else{
                        if (self.has_unit) {
                            [self headerTitleAppendAttributedStringWithContent:[NSString stringWithFormat:@"%@  / ",self.selectBuild.building_no] textColor:MRGBColor(153,169,191)];
                            [self headerTitleAppendAttributedStringWithContent:self.selectUnit.unit_no textColor:MColorTitle];
                        }else{
                            [self headerTitleAppendAttributedStringWithContent:self.selectBuild.building_no textColor:MRGBColor(153,169,191)];
                        }
                    }
                    break;
                default:
                    break;
            }
            self.str;
        })];
        view;
    });
}


- (void)headerTitleAppendAttributedStringWithContent:(NSString *)content textColor:(UIColor *)color{
    [self.str appendAttributedString:({
        [[NSAttributedString alloc]initWithString:content attributes:@{NSForegroundColorAttributeName:color}];
    })];
}

-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



#pragma mark - request
- (void)requestArea {
    [MHHUDManager show];
    [MHCertificationRequestHandler postAreaWithCommunityID:self.currentCommunity.community_id callBack:^(NSArray * areaList, NSString *errmsg,BOOL has_area) {
        if (areaList) {
            self.areaList = areaList;
            self.has_area = has_area ;
            self.type = 0;
            if (!has_area) { // 无区域时，再请求多一次获取楼栋信息
                self.selectArea = self.areaList[0];
                self.tableView.hidden =  YES ;
                [self requestBuild];
            }
            [self.tableView reloadData];

            [self hiddenEmptyView];

            if(self.areaList.count == 0){
                [self showEmptyView];
            }
        } else {
            
        }
        [MHHUDManager dismiss];
    }];
}
- (void)requestBuild {
    [MHHUDManager show];
    [MHCertificationRequestHandler postBuildWithCommunityID:self.currentCommunity.community_id structId:self.selectArea.struct_id callBack:^(NSArray *builds, NSString *errmsg,BOOL has_builds) {
        if (builds) {
            self.buildList = builds;
            self.type = 1;
            self.tableView.hidden =  NO ;
            [self.tableView reloadData];

            [self hiddenEmptyView];

            if(self.buildList.count == 0){
                [self showEmptyView];
            }
        } else {
            
        }
        
        [MHHUDManager dismiss];
    }];
}
- (void)requestUnit {
    [MHHUDManager show];
    [MHCertificationRequestHandler postUnitWithCommunityID:self.currentCommunity.community_id structId:self.selectBuild.struct_id callBack:^(NSArray *units, NSString *errmsg,BOOL has_unit) {
        if (units) {
            self.unitList = units;
            self.has_unit = has_unit;
            self.type = 2;
            if (!has_unit) { // 无区域时，再请求多一次获取楼栋信息
                self.selectUnit = self.unitList[0];
                self.tableView.hidden =  YES ;
                [self requestRoom];
            }
            
            [self.tableView reloadData];

            [self hiddenEmptyView];

            if(self.unitList.count == 0){
                [self showEmptyView];
            }
        } else {
            
        }
        [MHHUDManager dismiss];
    }];
}
- (void)requestRoom {
    [MHHUDManager show];
    [MHCertificationRequestHandler postRoomWithCommunityID:self.currentCommunity.community_id structId:self.selectUnit.struct_id callBack:^(NSArray *rooms, NSString *errmsg,BOOL has_room) {
        if (rooms) {
            self.roomList = rooms;
            self.type = 3;
            self.tableView.hidden =  NO ;
            [self.tableView reloadData];

            [self hiddenEmptyView];

            if(self.roomList.count == 0){
                [self showEmptyView];
            }
        } else {
            
        }
        [MHHUDManager dismiss];
    }];
}


- (void)clearEmptyView{
    if(_emptyView){
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }
}

- (void)showEmptyView{
    [self clearEmptyView];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
}


- (void)hiddenEmptyView{
    if(_emptyView && _emptyView.superview){
        [_emptyView removeFromSuperview];
    }
    _emptyView = nil;

}

#pragma mark - 空状态下的视图
- (UIView *)emptyView{
    if(!_emptyView){
        _emptyView = [UIView new];
        _emptyView.backgroundColor = MColorToRGB(0XF9FAFC);
        UIView *bgView = [UIView new];
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"announcement_notice_empty"];
        UILabel *label = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 17] textColor:MColorToRGB(0X99A9BF)];
        label.text = @"抱歉，该小区暂无房间数据";
        [bgView addSubview:imageView];
        [bgView addSubview:label];
        [_emptyView addSubview:bgView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top);
            make.left.greaterThanOrEqualTo(bgView.mas_left);
            make.right.lessThanOrEqualTo(bgView.mas_right);
            make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(8);
            make.left.greaterThanOrEqualTo(bgView.mas_left);
            make.right.lessThanOrEqualTo(bgView.mas_right);
            make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_emptyView);
        }];
    }
    return _emptyView;
}

@end
