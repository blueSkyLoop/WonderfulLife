//
//  MHVoRegisterAttendanceController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoRegisterAttendanceController.h"
#import "MHVoAttendanceRemarkController.h"
#import "MHVoAttendanceRecordsController.h"
#import "MHNavigationControllerManager.h"

#import "MHVoAttendanceRecordDetailCell.h"
#import "MHAttendanceRegisterTableViewCell.h"
#import "MHVoAttendanceRegisterScoreCell.h"
#import "MHVoAtReCoScoreFillCell.h"

#import "MHAttendanceRecordSectionHeader.h"
#import "MHAttendancenDetailBottomView.h"
#import "MHVoAttendanceRegisterCommitView.h"
#import "MHAttendanceRecordHeader.h"

#import "UIView+NIM.h"
#import "UIImage+Color.h"
#import "MHConst.h"
#import "MHMacros.h"
#import "TZImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import "YYModel.h"
#import "MHHUDManager.h"
#import "MHWeakStrongDefine.h"
#import "PYPhoto.h"
#import "SDWebImageManager.h"
#import "MHAlertView.h"
#import "JFAuthorizationStatusManager.h"

#import "MHVoServerRequestDataHandler.h"
#import "MHVoAttendanceRegisterModel.h"

#import "MHAttendanceRegisterMoreMemberController.h"

@interface MHVoRegisterAttendanceController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,MHAttendancenDetailBottomViewDelegate,MHVoAtReCoScoreFillFieldDelegate,PYPhotosViewDelegate,TZImagePickerControllerDelegate,MHAttendanceRegisterTableViewCellDelegate,MHVoAttendanceRegisterCommitViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MHNavigationControllerManagerProtocol,MHAttendanceRecordSectionHeaderDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,weak) MHAttendanceRecordHeader *headerView;
@property (weak, nonatomic) PYPhotosView *photosView;
@property (nonatomic,strong) UIView *shapeView;
@property (nonatomic,strong) MHAttendancenDetailBottomView *bottomView;
@property (nonatomic,strong) MHVoAttendanceRegisterCommitView *commitView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic,strong) NSMutableArray *seletedCrew;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *images;

@end

extern NSString *const MHVoAttendanceRecordDetailPhotoCellID;
extern NSString *const MHVoAttendanceRecordDetailRemarksCellID;
extern NSString *const MHAttendanceRecordSectionHeaderID;
static NSString *const MHAttendanceRegisterTableViewCellID = @"MHAttendanceRegisterTableViewCellID";

static NSString *const MHVoAtReCoScoreFillCellID = @"MHVoAtReCoScoreFillCellID";
static NSString *const MHVoAttendanceRegisterScoreCellID = @"MHVoAttendanceRegisterScoreCellID";


@implementation MHVoRegisterAttendanceController{
    CGPoint titleOriginCenter;
    CGPoint titleFinalCenter;
    CGSize titleOriginSize;
    CGSize titleFinalSize;
    CGFloat topInset;
    CGFloat totalScore;
    NSInteger totalHour;
    NSInteger imageCount;
    BOOL firstLoad;
    BOOL hasModified;
}


#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    firstLoad = YES;
    self.seletedCrew = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedAssets = [NSMutableArray array];
    _selectedPhotos = [NSMutableArray array];
    self.images = [NSMutableArray array];

//    [self tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:MHVoRegisterAttendanceControllerReloadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [MHHUDManager show];
    if (_model) {
        if (_model.score_rule_method.integerValue == 2) {
            self.type = MHVoRegisterAttendanceControllerTypeContractModify;
            totalScore = _model.action_total_score.floatValue;
            totalHour = _model.action_total_duration.integerValue;
        }else{
            self.type = MHVoRegisterAttendanceControllerTypeModify;
        }
        [self downloadImages];
        
    }else{
        
        [MHVoServerRequestDataHandler postVolunteerAttendanceCheckinCrewList:self.action_team_ref_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            [MHHUDManager dismiss];
            if (success) {
                self.model = [MHVoAttendanceRegisterModel yy_modelWithJSON:data];
                if (_model.score_rule_method.integerValue == 2) {
                    self.type = MHVoRegisterAttendanceControllerTypeContract;
                    totalScore = _model.action_total_score.floatValue;
                    _model.unAllocScore = _model.action_total_score.floatValue;
                    totalHour = _model.action_total_duration.integerValue;
                }else {
                    self.type = MHVoRegisterAttendanceControllerTypeRegister;
                }
                
                [self configureNormal];
                if (self.type == MHVoRegisterAttendanceControllerTypeContract) {
                    
                    _shapeView = [[UIView alloc] initWithFrame:CGRectMake(193*MScale, -667, 158*MScale, 42)];
                    [self.tableView addSubview:_shapeView];
                    _shapeView.hidden = YES;
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_shapeView.bounds];
                    imageView.image = [UIImage imageNamed:@"VoCombinedShape"];
                    [_shapeView addSubview:imageView];
                    
                    UILabel *label = [UILabel new];
                    label.font = [UIFont systemFontOfSize:14];
                    [_shapeView addSubview:label];
                    label.textColor = [UIColor whiteColor];
                    label.text = @"请手动输入爱心积分";
                    [label sizeToFit];
                    label.nim_top = 8;
                    label.nim_centerX = _shapeView.nim_width/2;
                }

                
            }else{
                [MHHUDManager showErrorText:errmsg];
            }
        }];
    }
    
}


- (BOOL)bb_ShouldBack{
    for (MHVoAttendanceRecordDetailCrewModel *model in self.seletedCrew) {
        model.duration = model.orginDuration;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : MColorTitle}];
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarTranslucent];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ((self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify) && _model.not_apply.count) {
        return 5;
    }else if ( ((self.type == MHVoRegisterAttendanceControllerTypeRegister || self.type == MHVoRegisterAttendanceControllerTypeModify) && _model.not_apply.count)  ||  ((self.type == MHVoRegisterAttendanceControllerTypeContractModify || self.type == MHVoRegisterAttendanceControllerTypeContract) && _model.not_apply.count == 0) ){
        return 4;
    }else{
        return 3;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify)) {
        
        if (section == 3){
            return _model.applied.count;
        }else if (section == 4){
            return _model.selected_not_apply.count;
        }
    }else{
        if (section == 2){
            return _model.applied.count;
        }else if (section == 3){
            return _model.selected_not_apply.count;
        }
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify)) {
        if (indexPath.section == 0) {
            MHVoAttendanceRegisterScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRegisterScoreCellID];
            cell.model = _model;
            
            return cell;
            
        }else if (indexPath.section == 1){
            MHVoAttendanceRecordDetailPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailPhotoCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeRegister;
            cell.photosView.delegate = self;
            self.photosView = cell.photosView;
            if (self.type == MHVoRegisterAttendanceControllerTypeContractModify) {
                cell.photosView.images = self.selectedPhotos;
            }
            return cell;
            
        }else if (indexPath.section == 2){
            
            MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeRegister;
            
            if (_model.remarks.length) {
                cell.remarksLabel.text = _model.remarks;
            }else{
                cell.remarksLabel.text = @"添加备注";
            }
            return cell;

        }else if (indexPath.section == 3 || indexPath.section == 4){
            
            MHVoAtReCoScoreFillCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAtReCoScoreFillCellID ];
            MHVoAttendanceRecordDetailCrewModel *model;
            if (indexPath.section == 3) {
                model = _model.applied[indexPath.row];
                
            }else if (indexPath.section == 4){
                model = _model.selected_not_apply[indexPath.row];
            }
            
            cell.model = model;
            cell.scoreField.fiReDelegate = self;
            cell.scoreField.indexPath = indexPath;
            return cell;
            
        }
        
    }else{ //普通考勤或修改
        if (indexPath.section == 0) {
            MHVoAttendanceRecordDetailPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailPhotoCellID forIndexPath:indexPath];
            cell.type = MHVoAttendanceRecordDetailCellTypeRegister;
            cell.photosView.delegate = self;
            if (self.type == MHVoRegisterAttendanceControllerTypeModify) {
                cell.photosView.images = self.selectedPhotos;
            }
            self.photosView = cell.photosView;
            return cell;
            
        }else if (indexPath.section == 1){
            MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
            cell.type = MHVoAttendanceRecordDetailCellTypeRegister;
            
            if (_model.remarks.length) {
                cell.remarksLabel.text = _model.remarks;
            }else{
                cell.remarksLabel.text = @"添加备注";
            }
            
            return cell;
        }else if (indexPath.section == 2 || indexPath.section == 3){
            MHAttendanceRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MHAttendanceRegisterTableViewCellID];
            MHVoAttendanceRecordDetailCrewModel *model;
            if (indexPath.section == 2) {
                model = _model.applied[indexPath.row];
                
            }else if (indexPath.section == 3){
                model = _model.selected_not_apply[indexPath.row];
            }
            if (self.type == MHVoRegisterAttendanceControllerTypeModify) {
                cell.type = MHAttendanceRegisterTableViewCellTypeModify;
            }else{
                cell.type = MHAttendanceRegisterTableViewCellTypeRegister;
            }
            cell.delegate = self;
            cell.model = model;
            return cell;
            
        }
    }
    
    
    return nil;
}

#pragma Mark - delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify)) {
        if (indexPath.section == 0) {
            return _model.has_virtual_account ? 187 : 187-25;
        }else if (indexPath.section == 1) {
            if (self.photosView.images.count ? (self.photosView.images.count > 2): (self.photosView.subviews.count > 3) ) { //分别是编辑状态和预览状态
                return 96*MScale*2 + 19*MScale + 32;
            }else{
                return 96*MScale + 32;
            }
            
        }else if (indexPath.section == 2){
            return 72;
        }else if (indexPath.section == 3 || indexPath.section == 4){
            return 80;
        }
    }else{
        if (indexPath.section == 0) {
            if (self.photosView.images.count ? (self.photosView.images.count > 2): (self.photosView.subviews.count > 3)) {
                return 96*MScale*2 + 19*MScale + 32;
            }else{
                return 96*MScale + 32;
            }
            
        }else if (indexPath.section == 1){
            return 72;
        }else if (indexPath.section == 2 || indexPath.section == 3){
            return 80;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ((self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify)) {
        if (section == 1) {
            MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"添加图片(必填)";
            return header;
        }
        if (section == 3){
            MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
            header.type = MHAttendanceRecordSectionHeaderTypePeople;
            header.timeLabel.text = @"报名成员";
            header.countLabel.text = [NSString stringWithFormat:@"%zd人",_model.applied.count];
            return header;
        }else if (section == 4){
            MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
            header.type = MHAttendanceRecordSectionHeaderTypeOtherMember;
            header.timeLabel.text = @"其他成员";
            if (_model.selected_not_apply.count) {
                header.countLabel.text = [NSString stringWithFormat:@"已选择%zd人",_model.selected_not_apply.count];
            }else{
                header.countLabel.text = [NSString stringWithFormat:@"登记其他成员考勤 "];
            }
            header.delegate = self;
            return header;
        }else{
            return nil;
        }
    }else {
        if (section == 0) {
            MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
            header.type = MHAttendanceRecordSectionHeaderTypeDetail;
            header.timeLabel.text = @"添加图片(必填)";
            return header;
        }
        if (section == 2){
            MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
            header.type = MHAttendanceRecordSectionHeaderTypePeople;
            header.timeLabel.text = @"报名成员";
            header.countLabel.text = [NSString stringWithFormat:@"%zd人",_model.applied.count];
            return header;
        }else if (section == 3){
            MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
            header.type = MHAttendanceRecordSectionHeaderTypeOtherMember;
            header.timeLabel.text = @"其他成员";
            if (_model.selected_not_apply.count) {
                header.countLabel.text = [NSString stringWithFormat:@"已选择%zd人",_model.selected_not_apply.count];
            }else{
                header.countLabel.text = [NSString stringWithFormat:@"登记其他成员考勤 "];
            }
            header.delegate = self;
            return header;
        }else{
            return nil;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    float section_H = 72 ;
    if ((self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify)) {
        if (section == 1 || section == 3 || section == 4) {
            return section_H;
        }
    }else{
        if (section == 0 || section == 2 || section == 3) {
            return section_H;
        }
    }
    return 0;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify)) {
        NSInteger index = _model.applied.count ? 3 : 4;
        if (indexPath.section == index && indexPath.row == 0) {
            if (firstLoad) {
                firstLoad = NO;
                return;
            }
            MHVoAtReCoScoreFillCell *fillCell = (MHVoAtReCoScoreFillCell *)cell;
            
            CGRect rect = [cell.contentView convertRect:fillCell.scoreField.frame toView:self.tableView];
            _shapeView.nim_bottom = rect.origin.y - 6;
            _shapeView.hidden = NO;
            [self.tableView bringSubviewToFront:_shapeView];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ((self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify)) {
        if (indexPath.section == 2) {
            MHVoAttendanceRemarkController *vc = [MHVoAttendanceRemarkController new];
            vc.remarks = _model.remarks;
            MHWeakify(vc);
            [vc setSaveBlock:^{
                MHStrongify(vc);
                _model.remarks = vc.remarks;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.view endEditing:YES];
        }
    }else{
        if (indexPath.section == 1) {
            MHVoAttendanceRemarkController *vc = [MHVoAttendanceRemarkController new];
            vc.remarks = _model.remarks;
            MHWeakify(vc);
            [vc setSaveBlock:^{
                MHStrongify(vc);
                _model.remarks = vc.remarks;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollTitleLabel];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self scrollTitleLabel];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self scrollTitleLabel];
}



#pragma mark - PYPhotosViewDelegate
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *shootAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([JFAuthorizationStatusManager authorizationStatusMediaTypeAlbumIsOpen]) {
            [self pushTZImagePickerController];
            
        }else{
            [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeAlbum target:self];
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    if (iOS8_2_OR_LATER) {
        [shootAction setValue:MColorTitle forKey:@"titleTextColor"];
        [albumAction setValue:MColorTitle forKey:@"titleTextColor"];
        [cancelAction setValue:MColorContent forKey:@"titleTextColor"];
    }
    
    [alert addAction:shootAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)didDeleteImageIndex:(NSInteger)index Image:(UIImage *)image{
    
    if ([self.images containsObject:image]) { //是网络图
        MHOOSImageModel *imageModel = _model.tempImgs[index];

        [self.images removeObject:image];
        [_model.tempImgs removeObject:imageModel];
        
        NSLog(@"是网络图");
    }else{
        [self.selectedAssets removeObjectAtIndex:index - self.images.count];
        
    }
    
    [self enableBottomButton];
}

- (void)reloadTableViewHeight{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    if (_shapeView) {
        NSInteger index = _model.applied.count ? 3 : 4;
        MHVoAtReCoScoreFillCell *fillCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
        CGRect rect = [fillCell.contentView convertRect:fillCell.scoreField.frame toView:self.tableView];
        _shapeView.nim_bottom = rect.origin.y - 6;
    }
}

#pragma mark - 通知
- (void)keyboardWillShow:(NSNotification *)noti{
    CGRect frame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, frame.size.height-96+40, 0);
}

- (void)keyboardWillHide:(NSNotification *)noti{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (void)reloadData{
    [self.tableView reloadData];
}
#pragma mark - 积分点击代理
- (void)voAtReCoScoreFillFieldbecomeFirstResponder:(CGFloat)score{
    [self.shapeView removeFromSuperview];
    self.shapeView = nil;
    
    _model.unAllocScore += score;

}

- (void)voAtReCoScoreFillFieldResignFirstResponder:(CGFloat)score IndexPath:(NSIndexPath *)indexPath{
    
    _model.unAllocScore -= score;
    
    MHVoAttendanceRecordDetailCrewModel *model;
    if (indexPath.section == 3) {
        model = _model.applied[indexPath.row];

    }else if (indexPath.section == 4){
        model = _model.selected_not_apply[indexPath.row];
    }
    
    CGFloat registerAllocTime = (score/totalScore)*totalHour;
    registerAllocTime = floor(registerAllocTime*10)/10;
    
    if (registerAllocTime - (NSInteger)registerAllocTime > 0.5) {
        registerAllocTime = (NSInteger)registerAllocTime + 0.5;
    }else if (registerAllocTime - (NSInteger)registerAllocTime < 0.5){
        registerAllocTime = (NSInteger)registerAllocTime;
    }
    model.registerAllocTime = registerAllocTime;
    model.registerAllocScore = score;
    
    if (score && [self.seletedCrew containsObject:model]==NO) {
        if ([model.tag isEqualToString:@"队长"]) {
            [self.seletedCrew insertObject:model atIndex:0];
        }else{
            [self.seletedCrew addObject:model];
        }
    }else if (score==0 && [self.seletedCrew containsObject:model]){
        
        if (self.type == MHVoRegisterAttendanceControllerTypeContractModify && model.orginDuration.floatValue != 0) {

        }else{
            [self.seletedCrew removeObject:model];
            
        }
    }
    
    CGFloat unAllocScore = totalScore;
    for (MHVoAttendanceRecordDetailCrewModel *model in self.seletedCrew) {
        unAllocScore -= model.registerAllocScore;
    }
    _model.unAllocScore = unAllocScore;
    
    [UIView performWithoutAnimation:^{
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    _bottomView.crewCount = self.seletedCrew.count;
    [self enableBottomButton];
    
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    
    if (visibleIndexPaths.count) {
        
        NSIndexPath *visibleIndexPath = visibleIndexPaths.firstObject;
        if (visibleIndexPath.section == 0 && visibleIndexPath.row == 0) {
            [self.tableView reloadRowsAtIndexPaths:@[visibleIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }
}

- (void)recordCrewWithModel:(MHVoAttendanceRecordDetailCrewModel *)model{
    CGFloat time = 0;
    BOOL isContains = [self.seletedCrew containsObject:model] ;
    
    if (self.type == MHVoRegisterAttendanceControllerTypeModify) {
        time = model.modifyTime;
        NSLog(@"score:%.1f\tname:%@",model.modifyTime,model.volunteer_name);
        
    }else{
        time = model.registerAllocTime;
    }
    
    if (isContains) {
        if (time == 0) {
            if (self.type == MHVoRegisterAttendanceControllerTypeModify && model.orginDuration.floatValue != 0) {
                // 当修改考勤时，就算时长修改为“0”。都不能remove 元素，接口需要把全部对象传到后台再更新考勤状态的人员列表。
            }else{
                [self.seletedCrew removeObject:model];
            }
            if (_bottomView.crewCount != 0) _bottomView.crewCount -- ;
            
        }else if ((time == 1 || time == 0.5) && self.type == MHVoRegisterAttendanceControllerTypeModify && model.isIncreasing){
            _bottomView.crewCount ++ ;
        }
    }else if (time && !isContains){
        if ([model.tag isEqualToString:@"队长"]) {
            [self.seletedCrew insertObject:model atIndex:0];
        }else{
            [self.seletedCrew addObject:model];
        }
        _bottomView.crewCount ++ ;
    }
    
    
    /**
    if (time && !isContains) { // 时间大于0 ，并不在数组里
        if ([model.tag isEqualToString:@"队长"]) {
            [self.seletedCrew insertObject:model atIndex:0];
        }else{
            [self.seletedCrew addObject:model];
        }
        _bottomView.crewCount ++ ;
        
    }else if (time == 0 && isContains){  // 时间等于0 ，且在数组里
        if (self.type == MHVoRegisterAttendanceControllerTypeModify && model.orginDuration.floatValue != 0) {
           
        }else{
            [self.seletedCrew removeObject:model];
            
        }
        if (_bottomView.crewCount != 0) _bottomView.crewCount -- ;
    }else if ((time == 1 || time == 0.5) && isContains && self.type == MHVoRegisterAttendanceControllerTypeModify && model.isIncreasing){
        _bottomView.crewCount ++ ;
    }
     */
    
    [self enableBottomButton];
    if (self.type == MHVoRegisterAttendanceControllerTypeModify) { // 是否更改底部按钮状态
        for (MHVoAttendanceRecordDetailCrewModel *model in self.seletedCrew) {
            if (model.modifyTime != 0) {
                return;
            }
        }
        _bottomView.button.enabled = NO;
    }
}

#pragma mark - 组头点击
- (void)sectionHeaderDidClick{
    MHAttendanceRegisterMoreMemberController *vc = [MHAttendanceRegisterMoreMemberController new];
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 按钮点击
- (void)bottomButtonDidClick{
    [self.view endEditing:YES];
    
    if (self.photosView.images.count == 0) {
        [MHHUDManager showText:@"请添加图片"];
        return;
    }
    
    if ((self.type == MHVoRegisterAttendanceControllerTypeContractModify || self.type == MHVoRegisterAttendanceControllerTypeContract) && _model.unAllocScore < 0) {
        [MHHUDManager showText:@"超出可支配积分，提交失败"];
        return;
    }
    
    if ((self.type == MHVoRegisterAttendanceControllerTypeContractModify || self.type == MHVoRegisterAttendanceControllerTypeContract) && _model.has_virtual_account == NO && _model.unAllocScore > 0) {
        [MHHUDManager showText:@"请分配完所有积分"];
        return;
    }
    
    if (self.type == MHVoRegisterAttendanceControllerTypeModify || self.type == MHVoRegisterAttendanceControllerTypeContractModify) {
        
        
        [[MHAlertView sharedInstance] showNormalTitleAlertViewWithTitle:@"确定提交修改的考勤单？" leftHandler:nil rightHandler:^{
            
            [MHHUDManager show];
            // 先查询考勤是否已经通过审核
            [MHVoServerRequestDataHandler postVolunteerAttendanceStatusQuery:_model.attendance_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
                if (success) {
                    if ([data[@"attendance_status"] integerValue] == 1) {
                        [MHHUDManager dismiss];
                        [MHHUDManager showText:@"已审核通过，不可修改"];
                    }else{
                        // 修改考勤
                        [MHVoServerRequestDataHandler postVolunteerAttendanceCheckinUpdate:_model.attendance_id Images:self.selectedPhotos deleted_imgs:nil remark:_model.remarks Crews:self.seletedCrew CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
                            [MHHUDManager dismiss];
                            if (success) {
                                [self.commitView removeFromSuperview];
                                for (UIViewController *vc in self.navigationController.childViewControllers) {
                                    if ([vc isKindOfClass:[MHVoAttendanceRecordsController class]]) {
                                        MHVoAttendanceRecordsController *recordVC = (MHVoAttendanceRecordsController *)vc;
                                        [recordVC refresh];
                                        [self.navigationController popToViewController:recordVC animated:YES];
                                    }
                                }
                                
                            }else{
                                for (MHVoAttendanceRecordDetailCrewModel *model in self.seletedCrew) {
                                    model.duration = model.orginDuration;
                                }
                                [MHHUDManager showErrorText:errmsg];
                            }
                        }];
                    }
                }else{
                    [MHHUDManager showErrorText:errmsg];
                }
            }];
            
        } rightButtonColor:nil];
        
        
    }else{
        
        [WINDOW addSubview:self.commitView];
        _commitView.unAllocScore = _model.unAllocScore;
    }
    
    
}

- (void)tipNotAllowCommit{
    if ((self.type == MHVoRegisterAttendanceControllerTypeContractModify || self.type == MHVoRegisterAttendanceControllerTypeModify) && hasModified == NO) {
        [MHAlertView showMessageAlertViewMessage:@"未修改任何内容，不可重新提交" ConfirmName:@"知道了" sureHandler:^{
            
        }];
        return;
    }
    if ((self.type == MHVoRegisterAttendanceControllerTypeContractModify || self.type == MHVoRegisterAttendanceControllerTypeContract) && _model.has_virtual_account == NO && self.photosView.images.count && _model.unAllocScore>0) {
        [MHHUDManager showText:@"请分配完所有积分"];
    }
    
}

#pragma mark - 提交考勤
- (void)commitAttendance{
    
    if (self.type == MHVoRegisterAttendanceControllerTypeModify) {
        

        
    }else{
        [MHHUDManager show];
        
        [MHVoServerRequestDataHandler postVolunteerAttendanceCheckin:self.selectedPhotos Crews:self.seletedCrew Remark:_model.remarks ActionId:self.action_team_ref_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            [MHHUDManager dismiss];
            if (success) {
                [self.commitView removeFromSuperview];
                MHVoAttendanceRecordsController *vc = [MHVoAttendanceRecordsController new];
                vc.attendance_id = @([data[@"team_id"] longValue]);
                vc.role_in_team = @1;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                for (MHVoAttendanceRecordDetailCrewModel *model in self.seletedCrew) {
                    model.duration = model.orginDuration;
                }
                [MHHUDManager showErrorText:errmsg];
            }
        }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - 相机代理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

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

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)photosViewReloadData{
    [self.photosView reloadDataWithImages:_selectedPhotos];
    [self reloadTableViewHeight];
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [self photosViewReloadData];
    [self enableBottomButton];
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)pushTZImagePickerController {
    NSInteger count = 6;
    if (self.type == MHVoRegisterAttendanceControllerTypeModify || self.type == MHVoRegisterAttendanceControllerTypeContractModify) {
        count = 6 - self.images.count;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:3 delegate:self pushPhotoPickerVc:YES];
        
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组

    //梁斌文
    imagePickerVc.navigationBar.shadowImage = [UIImage mh_imageWithColor:MColorSeparator size:CGSizeMake(MScreenW, 1)];
    imagePickerVc.navigationBar.tintColor = MRGBColor(50, 64, 81);
    imagePickerVc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:MRGBColor(50, 64, 81), NSFontAttributeName: [UIFont systemFontOfSize:17]};
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage mh_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.isStatusBarDefault = YES;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    // photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        if (self.type == MHVoRegisterAttendanceControllerTypeModify || self.type == MHVoRegisterAttendanceControllerTypeContractModify) {
            NSMutableArray *tempPhotos = [NSMutableArray arrayWithArray:photos];
            if (_selectedAssets.count) {
                NSMutableArray *tempAssets = [NSMutableArray arrayWithArray:assets];
                
                NSInteger count = tempAssets.count;
                if (count>_selectedAssets.count) {
                    for (NSInteger i = 0; i < count; i++) {
                        PHAsset *asset = tempAssets[i];
                        if ([_selectedAssets containsObject:asset]) {
                            [tempPhotos removeObjectAtIndex:[tempAssets indexOfObject:asset]];
                            [tempAssets removeObject:asset];
                            count --;
                            i --;
                        }else{
                            [_selectedAssets addObject:asset];
                            [_selectedPhotos addObject:tempPhotos[[tempAssets indexOfObject:asset]]];
                        }
                    }
                }else if (count<_selectedAssets.count){
                    count = _selectedAssets.count;
                    for (NSInteger i = 0; i < count; i++) {
                        PHAsset *asset = _selectedAssets[i];
                        if ([tempAssets containsObject:asset]) {
                            [_selectedPhotos removeObjectAtIndex:[tempAssets indexOfObject:asset]];
                            [_selectedAssets removeObject:asset];
                            count --;
                            i --;
                        }
                    }
                }
            }else{
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                [_selectedPhotos addObjectsFromArray:tempPhotos];
            }
        }else{
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
        }
        [self photosViewReloadData];
        [self enableBottomButton];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)endEditing{
    [self.view endEditing:YES];
    
}

- (void)downloadImages{
    MHOOSImageModel *imageModel = _model.imgs[imageCount];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageModel.url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            [self.selectedPhotos addObject:image];
            [self.images addObject:image];
            if (self.selectedPhotos.count < _model.imgs.count) {
                imageCount +=1;
                [self downloadImages];
            }else{
                [MHHUDManager dismiss];
                [self configureNormal];
                
                for (MHVoAttendanceRecordDetailCrewModel *model in _model.applied) {
                    model.modifyTime = model.duration.floatValue;
                    if (model.modifyTime) {
                        if ([model.tag isEqualToString:@"队长"]) {
                            [self.seletedCrew insertObject:model atIndex:0];
                        }else{
                            [self.seletedCrew addObject:model];
                        }
                    }
                }
                for (MHVoAttendanceRecordDetailCrewModel *model in _model.not_apply) {
                    //又是麻烦事
                    model.modifyTime = model.duration.floatValue;
                    if (model.modifyTime) {
                        if ([model.tag isEqualToString:@"队长"]) {
                            [self.seletedCrew insertObject:model atIndex:0];
                        }else{
                            [self.seletedCrew addObject:model];
                        }
                    }
                }
                _bottomView.crewCount = self.seletedCrew.count;
            }
        }
    }];
}

- (void)configureNormal{
    [self tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
    
    MHAttendanceRecordHeader *headerView = [[MHAttendanceRecordHeader alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, 64)];
    self.headerView = headerView;
    headerView.type = MHAttendanceRecordHeaderTypeRegisterAttendance;
    [self.view addSubview:headerView];
    
    titleOriginCenter = headerView.subviews.firstObject.center;
    titleFinalCenter = CGPointMake(MScreenW/2, 42);
    titleOriginSize = CGSizeMake(130, 45) ;
    titleFinalSize = CGSizeMake(74, 25);
    topInset = 0;
}

- (void)enableBottomButton{
    hasModified = YES;
    _bottomView.button.enabled = self.seletedCrew.count && self.photosView.images.count;
    if (_model.has_virtual_account == NO && _model.unAllocScore && (self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify)) {
        _bottomView.button.enabled = NO;
    }
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-96) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        [_tableView registerClass:[MHVoAttendanceRecordDetailPhotoCell class] forCellReuseIdentifier:MHVoAttendanceRecordDetailPhotoCellID];
        [_tableView registerClass:[MHVoAttendanceRecordDetailRemarksCell class] forCellReuseIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
        [_tableView registerClass:[MHAttendanceRecordSectionHeader class] forHeaderFooterViewReuseIdentifier:MHAttendanceRecordSectionHeaderID];
        [_tableView registerNib:[UINib nibWithNibName:@"MHAttendanceRegisterTableViewCell" bundle:nil] forCellReuseIdentifier:MHAttendanceRegisterTableViewCellID];
        if (self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify) {
            [_tableView registerNib:[UINib nibWithNibName:@"MHVoAttendanceRegisterScoreCell" bundle:nil] forCellReuseIdentifier:MHVoAttendanceRegisterScoreCellID];
            [_tableView registerNib:[UINib nibWithNibName:@"MHVoAtReCoScoreFillCell" bundle:nil] forCellReuseIdentifier:MHVoAtReCoScoreFillCellID];
        }
        
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
        [self setupBottomView];
        
    }
    return _tableView;
}

- (MHVoAttendanceRegisterCommitView *)commitView{
    if (_commitView == nil) {
        _commitView = [MHVoAttendanceRegisterCommitView attendanceRegisterCommitView];
        
        if (self.type == MHVoRegisterAttendanceControllerTypeContract || self.type == MHVoRegisterAttendanceControllerTypeContractModify) {
            if (_model.has_virtual_account == NO) {
                _commitView.type = MHVoAttendanceRegisterCommitViewTypeNormal;
                _commitView.isShow_UndistributedScore = YES ;
                _commitView.scoreLabel.text = @"积分";
            }else{
                _commitView.type = MHVoAttendanceRegisterCommitViewTypeContract;
            }
        }else {
            _commitView.type = MHVoAttendanceRegisterCommitViewTypeNormal;
        }
        _commitView.dataList = self.seletedCrew;
        
        _commitView.frame = self.view.bounds;
        _commitView.delegate = self;
    }
    return _commitView;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)setupBottomView{
    MHAttendancenDetailBottomView *bottomView = [MHAttendancenDetailBottomView bottomView];
    [self.view addSubview:bottomView];
    bottomView.type = MHAttendancenDetailBottomViewTypeCommitAttendance;
    bottomView.frame = CGRectMake(0, self.view.nim_height - 96, self.view.nim_width, 96);
    bottomView.delegate = self;
    _bottomView = bottomView;
    _bottomView.crewCount = 0;
    _bottomView.button.enabled = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = _bottomView.button.frame;
    [_bottomView insertSubview:button belowSubview:_bottomView.button];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(tipNotAllowCommit) forControlEvents:UIControlEventTouchUpInside];
}

#ifdef DEBUG
- (void)dealloc{
    for (MHVoAttendanceRecordDetailCrewModel *model in self.seletedCrew) {
        model.duration = model.orginDuration;
    }
    NSLog(@"%s",__func__);
}
#endif
@end






