//
//  MHVoAttendanceRecordDetailController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRecordDetailController.h"
#import "MHVoRegisterAttendanceController.h"

#import "MHVoAttendanceRecordDetailCell.h"
#import "MHAttendanceRecordSectionHeader.h"
#import "MHAttendancenDetailBottomView.h"
#import "MHAttendanceRecordHeader.h"


#import "UIView+NIM.h"
#import "MHMacros.h"
#import "MHHUDManager.h"
#import "YYModel.h"

#import "MHVoAttendanceRecordDetailModel.h"
#import "MHVoAttendanceRegisterModel.h"
#import "MHVoServerRequestDataHandler.h"

typedef enum : NSUInteger {
    MHVoAttendanceRecordDetailControllerteamer,
    MHVoAttendanceRecordDetailControllerUnAuDit,
    MHVoAttendanceRecordDetailControllerDidAudit,
} MHVoAttendanceRecordDetailControllerType;

@interface MHVoAttendanceRecordDetailController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MHAttendancenDetailBottomViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,weak) MHAttendanceRecordHeader *headerView;
@property (nonatomic,strong) NSMutableArray *crews;
@property (nonatomic,assign) MHVoAttendanceRecordDetailControllerType type;
@property (weak, nonatomic) PYPhotosView *photosView;

@end

NSString *const MHVoAttendanceRecordDetailPhotoCellID = @"MHVoAttendanceRecordDetailPhotoCellID";
NSString *const MHVoAttendanceRecordDetailRemarksCellID = @"MHVoAttendanceRecordDetailRemarksCellID";
NSString *const MHVoAttendanceRecordDetailMemberCellID = @"MHVoAttendanceRecordDetailMemberCellID";
NSString *const MHVoAttendanceRecordDetailCellID = @"MHVoAttendanceRecordDetailCellID";
NSString *const MHAttendanceRecordSectionHeaderID = @"MHAttendanceRecordSectionHeaderID";

@implementation MHVoAttendanceRecordDetailController{
    CGPoint titleOriginCenter;
    CGPoint titleFinalCenter;
    CGSize titleOriginSize;
    CGSize titleFinalSize;
    CGFloat topInset;
}

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.crews = [NSMutableArray array];
    
    for (MHVoAttendanceRecordDetailCrewModel *model in _model.applied_crews) {
        if (model.duration.length) {
            [self.crews addObject:model];
        }
    }
    for (MHVoAttendanceRecordDetailCrewModel *model in _model.not_apply_crews) {
        if (model.duration.length) {
            [self.crews addObject:model];
        }
    }
    
    if (_model.role_in_team.integerValue == 0) {
        self.type = MHVoAttendanceRecordDetailControllerteamer;
    }else if (_model.attendance_status.integerValue == 0) {
        self.type = MHVoAttendanceRecordDetailControllerUnAuDit;
    }else if (_model.attendance_status.integerValue == 1 || _model.attendance_status.integerValue == 2) {
        self.type = MHVoAttendanceRecordDetailControllerDidAudit;
    }
    [self tableView];
    
    
    MHAttendanceRecordHeader *headerView = [[MHAttendanceRecordHeader alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, 64)];
    self.headerView = headerView;
    headerView.type = MHAttendanceRecordHeaderTypeAttendanceDetail;
    [self.view addSubview:headerView];
    
    titleOriginCenter = headerView.subviews.firstObject.center;
    titleFinalCenter = CGPointMake(MScreenW/2, 42);
    titleOriginSize = CGSizeMake(130, 45) ;
    titleFinalSize = CGSizeMake(74, 25);
    topInset = 0;
    

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == MHVoAttendanceRecordDetailControllerteamer) {
        return 4;
        
    }else if (_model.attendance_status.integerValue == 0) { // 队长，未审核
        return 5;
    }else{ //队长，拒绝或者已通过
        return 6;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == MHVoAttendanceRecordDetailControllerteamer) {
        if (section == 3){ //活动详情
            return 5;
        }else{
            return 1;
        }
        
    }else if (_model.attendance_status.integerValue == 0) { // 队长，未审核
        if (section == 2) { //报名人数
            return self.crews.count;
        }else if (section == 4){ //活动详情
            return 6;
        }else{
            return 1;
        }
    }else{ //队长，拒绝或者已通过
        if (section == 3) { //报名人数
            return self.crews.count;
        }else if (section == 5){ //活动详情
            return 6;
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == MHVoAttendanceRecordDetailControllerteamer) {
        if (indexPath.section == 0) { // 队员
            MHVoAttendanceRecordDetailMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailMemberCellID];
            cell.model = _model.ordinary_crew_attendance;
            return cell;
        }else if (indexPath.section == 1){ // 照片
            MHVoAttendanceRecordDetailPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailPhotoCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.model = _model;
            self.photosView = cell.photosView;
            return cell;
        }else if (indexPath.section == 2){ // 活动介绍
            MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.contentType = MHVoAttendanceRecordDetailContentTypeActivityIntroduce;
            cell.model = _model;
            return cell;
        }else if (indexPath.section == 3){ // 活动详情
            MHVoAttendanceRecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailCellID];
            cell.row = indexPath.row;
            cell.model = _model;
            return cell;
        }
        
    }else if (_model.attendance_status.integerValue == 0) { // 队长，未审核
        if (indexPath.section == 0){ // 照片
            MHVoAttendanceRecordDetailPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailPhotoCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.model = _model;
            self.photosView = cell.photosView;
            return cell;
        }else if (indexPath.section == 1){ // 考勤备注
            MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.contentType = MHVoAttendanceRecordDetailContentTypeAttendanceRemarks;
            cell.model = _model;
            return cell;
        }else if (indexPath.section == 2) { // 报名成员
            if (_model.score_rule_method.integerValue ==  2) { //承包制
                MHVoAttendanceRecordDetailMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailMemberCellID forIndexPath:indexPath];
                cell.type = MHVoAttendanceRecordDetailMemberCellTypeScore;
                cell.model = self.crews[indexPath.row];
                return cell;
            }else{
                MHVoAttendanceRecordDetailMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailMemberCellID];
                cell.model = self.crews[indexPath.row];
                return cell;
                
            }
        }else if (indexPath.section == 3){ // 活动介绍
            MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.contentType = MHVoAttendanceRecordDetailContentTypeActivityIntroduce;
            cell.model = _model;
            return cell;
        }else if (indexPath.section == 4){ // 活动详情
            MHVoAttendanceRecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailCellID];
            cell.row = indexPath.row;
            cell.model = _model;
            return cell;
        }
        
    }else{ //队长，拒绝或者已通过
        if (indexPath.section == 0) {
            MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.contentType = MHVoAttendanceRecordDetailContentTypeAttendanceAudit;
            cell.model = _model;
            return cell;
            
        }else if (indexPath.section == 1){ // 照片
            MHVoAttendanceRecordDetailPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailPhotoCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.model = _model;
            self.photosView = cell.photosView;
            return cell;
        }else if (indexPath.section == 2){ // 考勤备注
            MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.contentType = MHVoAttendanceRecordDetailContentTypeAttendanceRemarks;
            cell.model = _model;
            return cell;
        }else if (indexPath.section == 3) { // 报名成员
            if (_model.score_rule_method.integerValue ==  2) { //承包制
                MHVoAttendanceRecordDetailMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailMemberCellID forIndexPath:indexPath];
                cell.type = MHVoAttendanceRecordDetailMemberCellTypeScore;
                cell.model = self.crews[indexPath.row];
                return cell;
            }else{
                MHVoAttendanceRecordDetailMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailMemberCellID];
                cell.model = self.crews[indexPath.row];
                return cell;
                
            }
        }else if (indexPath.section == 4){ // 活动介绍
            MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeDetail;
            cell.contentType = MHVoAttendanceRecordDetailContentTypeActivityIntroduce;
            cell.model = _model;
            return cell;
        }else if (indexPath.section == 5){ // 活动详情
            MHVoAttendanceRecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailCellID];
            cell.row = indexPath.row;
            cell.model = _model;
            return cell;
        }
    }
    
    return nil;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == MHVoAttendanceRecordDetailControllerteamer) {
        if (indexPath.section == 0){ //队员
            return 80;
        }else if (indexPath.section == 1){ //照片
            if (self.photosView.subviews.count > 3) {
                return 96*MScale*2 + 19*MScale + 32;
            }else{
                return 96*MScale + 32;
            }
        }else if (indexPath.section == 2){ //活动介绍
            return _model.acInHeight;
        }else if (indexPath.section == 3){ //活动详情
            
            return indexPath.row == 4 ? _model.acAdHeight : 33;
        }else{
            return 0;
        }
        
    }else if (_model.attendance_status.integerValue == 0) { // 队长，未审核
        if (indexPath.section == 0){ //照片
            if (self.photosView.subviews.count > 3) {
                return 96*MScale*2 + 19*MScale + 32;
            }else{
                return 96*MScale + 32;
            }
        }else if (indexPath.section == 1){ //考勤备注
            return _model.AtReHeight;
        }else if (indexPath.section == 2){ //报名成员
            return 80;
        }else if (indexPath.section == 3){ //活动介绍
            return _model.acInHeight;
        }else if (indexPath.section == 4){ //活动详情
            return indexPath.row == 4 ? _model.acAdHeight : 33;
        }else{
            return 0;
        }
    }else{ //队长，拒绝或者已通过
        if (indexPath.section == 0){ //审批结果
            return _model.auReHeight;
        }else if (indexPath.section == 1){ //照片
            if (self.photosView.subviews.count > 3) {
                return 96*MScale*2 + 19*MScale + 32;
            }else{
                return 96*MScale + 32;
            }
        }else if (indexPath.section == 2){ //考勤备注
            return _model.AtReHeight;
        }else if (indexPath.section == 3){ //报名成员
            return 80;
        }else if (indexPath.section == 4){ //活动介绍
            return _model.acInHeight;
        }else if (indexPath.section == 5){ //活动详情
            return indexPath.row == 4 ? _model.acAdHeight : 33;
        }else{
            return 0;
        }
    }
    
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
    
    if (self.type == MHVoAttendanceRecordDetailControllerteamer) {
        if (section == 1) {
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动照片";
        }else if (section == 2){
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动介绍";
        }else if (section == 3){
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动详情";
        }
        
    }else if (_model.attendance_status.integerValue == 0) { // 队长，未审核
        if (section == 0) {
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动照片";
        }else if (section == 1){
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"考勤备注";
        }else if (section == 2){
            header.type = MHAttendanceRecordSectionHeaderTypePeople;
            header.timeLabel.text = @"报名成员";
        }else if (section == 3){
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动介绍";
        }else if (section == 4){
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动详情";
        }
    }else{ //队长，拒绝或者已通过
        if (section == 0) {
            header.type = MHAttendanceRecordSectionHeaderTypeReject;
            if (_model.attendance_status.integerValue == 1){
                header.timeLabel.text = @"通过理由";
            }else if (_model.attendance_status.integerValue == 2){
                header.timeLabel.text = @"不通过理由";
            }
            
        }else if (section == 1) {
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动照片";
        }else if (section == 2){
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"考勤备注";
        }else if (section == 3){
            header.type = MHAttendanceRecordSectionHeaderTypePeople;
            header.timeLabel.text = @"报名成员";
        }else if (section == 4){
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动介绍";
        }else if (section == 5){
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"活动详情";
        }
    }
    
    return header;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.type == MHVoAttendanceRecordDetailControllerteamer && section == 0) {
        return 0;
        
    }else {
        return 72;
    }

}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollTitleLabel];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self scrollTitleLabel];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self scrollTitleLabel];
}

- (void)bottomButtonDidClick{
    
    [MHHUDManager show];
    
    [MHVoServerRequestDataHandler postVolunteerAttendanceStatusQuery:_model.attendance_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        if (success) {
            if ([data[@"attendance_status"] integerValue] == 1) {
                [MHHUDManager showText:@"已审核通过，不可修改"];
                
                [MHVoServerRequestDataHandler postVolunteerAttendanceDetailWithTeamRefId:self.action_team_ref_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
                    [MHHUDManager dismiss];
                    if (success) {
                        self.model = [MHVoAttendanceRecordDetailModel
                                      yy_modelWithJSON:data];
                        [self.tableView reloadData];
                    }else{
                        [MHHUDManager showErrorText:errmsg];
                    }
                }];
            }else{
                MHVoRegisterAttendanceController *vc = [MHVoRegisterAttendanceController new];
                MHVoAttendanceRegisterModel *modifyModel = [MHVoAttendanceRegisterModel new];
                modifyModel.has_virtual_account = _model.has_virtual_account;
                modifyModel.attendance_id = _model.attendance_id;
                modifyModel.imgs = _model.imgs;
                modifyModel.tempImgs = _model.imgs.mutableCopy;
                modifyModel.deleted_imgs = [NSMutableArray array];
                modifyModel.score_rule_method = _model.score_rule_method;
                modifyModel.action_total_score = _model.action_total_score;
                modifyModel.action_total_duration = _model.action_total_duration;
                
                modifyModel.imgs = _model.imgs;
                
                modifyModel.applied = _model.applied_crews;
                modifyModel.not_apply = _model.not_apply_crews;
                
                CGFloat totalScore = _model.action_total_score.floatValue;
                CGFloat unAllocScore = totalScore;
                NSInteger totalHour = _model.action_total_duration.integerValue;
                
                for (MHVoAttendanceRecordDetailCrewModel *model in _model.applied_crews) {
                    CGFloat score = model.score.floatValue;
                    unAllocScore -= score;
                    
                    model.registerAllocScore = score;
                
                    CGFloat registerAllocTime = (score/totalScore)*totalHour;
                    registerAllocTime = floor(registerAllocTime*10)/10;
                    
                    if (registerAllocTime - (NSInteger)registerAllocTime > 0.5) {
                        registerAllocTime = (NSInteger)registerAllocTime + 0.5;
                    }else if (registerAllocTime - (NSInteger)registerAllocTime < 0.5){
                        registerAllocTime = (NSInteger)registerAllocTime;
                    }
                    model.registerAllocTime = registerAllocTime;
                }
                for (MHVoAttendanceRecordDetailCrewModel *model in _model.not_apply_crews) {
                    CGFloat score = model.score.floatValue;
                    unAllocScore -= score;
                    
                    model.registerAllocScore = score;
                    
                    CGFloat registerAllocTime = (score/totalScore)*totalHour;
                    registerAllocTime = floor(registerAllocTime*10)/10;
                    
                    if (registerAllocTime - (NSInteger)registerAllocTime > 0.5) {
                        registerAllocTime = (NSInteger)registerAllocTime + 0.5;
                    }else if (registerAllocTime - (NSInteger)registerAllocTime < 0.5){
                        registerAllocTime = (NSInteger)registerAllocTime;
                    }
                    model.registerAllocTime = registerAllocTime;
                }
                modifyModel.unAllocScore = unAllocScore;
                
                modifyModel.remarks = _model.remark;
                vc.model = modifyModel;
                vc.action_team_ref_id = self.action_team_ref_id;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
    
}

#pragma mark - 按钮点击


#pragma mark - private

- (void)scrollTitleLabel{
    CGFloat offsetY = self.tableView.contentOffset.y;
    
    if (offsetY < -(topInset-64)) {
        self.headerView.nim_top = 64 - (topInset+offsetY);
        
    }else if (offsetY >= -(topInset-64)){
        self.headerView.nim_top = 0;
        _headerView.titleLabel.nim_size = titleFinalSize;
        _headerView.titleLabel.center = titleFinalCenter;
        
    }
    if (offsetY <= -topInset){
        _headerView.titleLabel.nim_size = titleOriginSize;
        _headerView.titleLabel.center = titleOriginCenter;
    }else if (offsetY > -topInset && offsetY< -(topInset-64)) {
        CGFloat headerTop = 64 - (topInset+offsetY);
        CGFloat scale = 1 - headerTop/64.00;
        
        CGFloat centerX = titleOriginCenter.x + (titleFinalCenter.x - titleOriginCenter.x)*scale;
        CGFloat centerY = titleOriginCenter.y + (titleFinalCenter.y - titleOriginCenter.y)*scale;
        CGFloat width = titleOriginSize.width - (titleOriginSize.width - titleFinalSize.width)*scale;
        CGFloat height = titleOriginSize.height - (titleOriginSize.height - titleFinalSize.height)*scale;
        _headerView.titleLabel.nim_size = CGSizeMake(width, height);
        _headerView.titleLabel.center = CGPointMake(centerX, centerY);
    }
}

- (void)setupBottomView{
    MHAttendancenDetailBottomView *bottomView = [MHAttendancenDetailBottomView bottomView];
    [self.view addSubview:bottomView];
    
    if (self.type == MHVoAttendanceRecordDetailControllerteamer || _model.role_in_team.integerValue == 2) {
        bottomView.type = _model.attendance_status.integerValue;
        
    }else {
        if (_model.attendance_status.integerValue == 0) {
            bottomView.type = MHAttendancenDetailBottomViewTypeEnableUnAudit;
        }else if (_model.attendance_status.integerValue == 1){
            bottomView.type = MHAttendancenDetailBottomViewTypeDidAudit;
        }else if (_model.attendance_status.integerValue == 2){
            bottomView.type = MHAttendancenDetailBottomViewTypeReject;
        }
        
    }
    bottomView.frame = CGRectMake(0, self.view.nim_height - 96, self.view.nim_width, 96);
    bottomView.delegate = self;
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-96) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[MHVoAttendanceRecordDetailPhotoCell class] forCellReuseIdentifier:MHVoAttendanceRecordDetailPhotoCellID];
        [_tableView registerClass:[MHVoAttendanceRecordDetailRemarksCell class] forCellReuseIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
        [_tableView registerClass:[MHAttendanceRecordSectionHeader class] forHeaderFooterViewReuseIdentifier:MHAttendanceRecordSectionHeaderID];
        [_tableView registerNib:[UINib nibWithNibName:@"MHVoAttendanceRecordDetailMemberCell" bundle:nil] forCellReuseIdentifier:MHVoAttendanceRecordDetailMemberCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"MHVoAttendanceRecordDetailCell" bundle:nil] forCellReuseIdentifier:MHVoAttendanceRecordDetailCellID];
        
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
        [self setupBottomView];
        
    }
    return _tableView;
}

#ifdef DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif
@end






