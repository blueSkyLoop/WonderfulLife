//
//  MHHomePayNoteController.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayNoteController.h"
#import "MHHomePayChooseController.h"
#import "MHHomePayMyRoomController.h"
#import "MHHomePayDetailsController.h"
#import "MHMineRoomModel.h"
#import "MHUnpayModel.h"

#import "MHMacros.h"
#import "MHHUDManager.h"
#import "MHHomeRequest.h"
#import "UIView+MHFrame.h"
#import "MHWeakStrongDefine.h"
#import "MHNavigationControllerManager.h"
#import "UINavigationController+RemoveChildController.h"
#import "YYModel.h"
#import "MHConst.h"

#import "MHHomePayNoteCell.h"
#import "MHHomePayBottomView.h"
#import "MHPayEmptyCell.h"
#import "UIView+NIM.h"

#import <AlipaySDK/AlipaySDK.h>

typedef NS_ENUM(NSUInteger, MHHomePayNoteControllerType) {
    MHHomePayNoteControllerTypeNote = 0,  // 缴费记录
    MHHomePayNoteControllerTypePay  // 待缴费用, 可以缴费
};

static NSString *payNoteCellID = @"payNoteCell";
#define MHPayEmptyCellID @"MHPayEmptyCellID"
@interface MHHomePayNoteController () <UITableViewDataSource, UITableViewDelegate,MHNavigationControllerManagerProtocol>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *sectionHeader;

/**
 业主信息容器View
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**
 标题Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 房间详细地址
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/**
 业主姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
/**
 待缴费用按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *needPayBtn;
/**
 缴费记录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *payNoteBtn;
/**
 tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 按钮底部指示栏
 */
@property (weak, nonatomic) IBOutlet UIView *lineView;
/**
 切换房间View，根据状态隐藏或显示
 */
@property (weak, nonatomic) IBOutlet UIView *reselectRoomView;
/**
 房间信息卡片height
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reselectRoomViewHeight;

/**
 底部工具栏
 */
@property (weak, nonatomic) MHHomePayBottomView *bottomView;

@property (nonatomic,strong) MHUnpayModel *unpayModel;
@property (nonatomic,strong) NSArray *donePayArray;

//辅助属性
@property (nonatomic,weak) UIButton *selectedButton;
@property (nonatomic,assign) BOOL change;

@property (nonatomic,copy) void (^refreshRecordBlock)();


// 0 不处理  1 支付了其中具体的一项缴费  2 一键缴费，全缴费了
@property (nonatomic,assign)NSInteger payFlag;
@property (nonatomic,copy)NSString *payProperty_id;
@property (nonatomic,assign) BOOL isFirstEnter;
@end

@implementation MHHomePayNoteController{
    CGFloat scale;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 设置导航栏
    self.navigationController.navigationBarHidden = YES;
    
    if(self.payFlag == 1){
        self.payFlag = 0;
        self.refreshBillBlock();
        
    }else if(self.payFlag == 2){
        self.payFlag = 0;
        self.refreshRecordBlock();
    }
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    scale = MScreenW/375;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.needPayBtn.mh_x = self.needPayBtn.mh_x*scale;
    self.payNoteBtn.mh_x = self.payNoteBtn.mh_x*scale;
    
    [self setupBackButton];
    self.headerView.nim_width = MScreenW;
    [self.headerView layoutIfNeeded];
    [self showRoomSelectButton:self.hasMoreRoom];
    [self setRoom:self.room];
    // 初始化界面
    [self setupUI];
    
    // 设置tableView
    [self setupTableView];
    
    MHWeakify(self);
    if (self.fromList) {
        if (self.selectedButtonIndex == 0) {
            self.selectedButton = self.needPayBtn;
            self.needPayBtn.enabled = NO;
            [self loaduUnpayDataCompleteBlock:^{
                
            }];
    
        }else{
            self.selectedButton = self.payNoteBtn;
            self.payNoteBtn.enabled = NO;
            [self loadDonePayDataCompleteBlock:^{
                
            }];
        }
    }else{
        self.selectedButton = self.needPayBtn;
        self.needPayBtn.enabled = NO;
        [self loaduUnpayDataCompleteBlock:^{
            
        }];
    }
    
    [self setRefreshRecordBlock:^{//支付回调
        MHStrongify(self);
        [self needPayChooseClick:self.payNoteBtn];
    }];
    
    [self setRefreshBillBlock:^{
        MHStrongify(self);
        [self needPayChooseClick:self.needPayBtn];
    }];
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kStoreOrderPaySuccessNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if(x.object){
            if([x.object isEqualToString:@"payAll"]){
                self.payFlag = 2;
            }else if([x.object isEqualToString:self.payProperty_id]){
                self.payFlag = 1;
            }
        }
    }];
}

#pragma mark - private
//待缴费列表
- (void)loaduUnpayDataCompleteBlock:(void(^)())completeBlock{
    [MHHUDManager show];
    self.isFirstEnter = NO;
    [MHHomeRequest postPropertyfeeUnpayListWithPropertyID:self.room.struct_id Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            self.isFirstEnter = YES;
            if (completeBlock) {
                completeBlock();
            }
            
            self.unpayModel = [MHUnpayModel yy_modelWithJSON:data];
            if (self.unpayModel.list.count) {
                [self setupBottomView];
                self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.unpayModel.sum];
            }else {
                [self.bottomView removeFromSuperview];
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            
            [self.tableView reloadData];
        }else{
            self.isFirstEnter = YES;
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}
//已缴费列表
- (void)loadDonePayDataCompleteBlock:(void(^)())completeBlock{
    [MHHUDManager show];
    self.isFirstEnter = NO;
    [MHHomeRequest postPropertyfeeTrainingListWithPropertyID:self.room.struct_id Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            self.isFirstEnter = YES;
            if (completeBlock) {
                completeBlock();
            }
            self.donePayArray = [NSArray yy_modelArrayWithClass:[MHUnpaySubjectModel class] json:data[@"list"]];
            
            [self.tableView reloadData];
        }else{
            self.isFirstEnter = YES;
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)setRoom:(MHMineRoomModel *)room{
    _room = room;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",room.community_name,room.room_info];
    [self.addressLabel sizeToFit];
    self.ownerNameLabel.text = [NSString stringWithFormat:@"业主：%@",room.real_name?:@""];
    [self.headerView setNeedsLayout];
    [self.headerView layoutIfNeeded];
    self.headerView.nim_height = self.containerView.nim_bottom+16;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - backProtocol
- (BOOL)bb_ShouldBack{
    if (self.change == NO) {
        [self.navigationController mh_removeChildViewControllersInRange:NSMakeRange(1, 1)];
        self.change = YES;
    }
    return YES;
}

#pragma mark - 设置界面

- (void)setupBackButton{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self.navigationController action:@selector(popToRootViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 初始化界面
 */
- (void)setupUI {
    // 1. 设置房间信息圆角与边框
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = MColorToRGB(0XD3DCE6).CGColor;
    self.containerView.layer.cornerRadius = 6;
    self.containerView.layer.masksToBounds = YES;

}

- (void)setupBottomView{
    
    // 2. 底部支付工具栏
    if (_bottomView) {
        return;
    }
    MHHomePayBottomView *bottomView = [MHHomePayBottomView loadHomePayBottomView];
    [bottomView.payButton setTitle:@"一键缴费" forState:UIControlStateNormal];
    MHWeakify(self)
    bottomView.payHandler = ^{
        MHStrongify(self)
        NSMutableArray *list = [NSMutableArray array];
        for (MHUnpaySubjectModel *model in self.unpayModel.list) {
            [list addObject:model.date];
        }

        MHStoreGoodPayModel *payModel = [MHStoreGoodPayModel new];
        payModel.type = mhPay_property_pay;
        payModel.totalScore = self.unpayModel.sum;
        payModel.payTypeStr = self.unpayModel.property_id.stringValue;
        payModel.payData = [list yy_modelToJSONString];
        payModel.noticeObject = @"payAll";
        MHHomePayChooseController *payChooseVc = [[MHHomePayChooseController alloc] initWithPayModel:payModel];
        [self.navigationController pushViewController:payChooseVc animated:YES];
    };
    CGFloat bottomX = 0;
    CGFloat bottomW = [UIScreen mainScreen].bounds.size.width;
    CGFloat bottomH = 80;
    CGFloat bottomY = [UIScreen mainScreen].bounds.size.height - bottomH;
    bottomView.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);

}

/**
 初始化tableView
 */
- (void)setupTableView {
    // 1. 设置tableView属性
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.headerView;
    
    // 2. 注册cell
    UINib *nib = [UINib nibWithNibName:@"MHHomePayNoteCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:payNoteCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"MHPayEmptyCell" bundle:nil] forCellReuseIdentifier:MHPayEmptyCellID];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isFirstEnter) {
        return 0;
    }
    if (self.selectedButton.tag == 0) {
        return self.unpayModel.list.count ? self.unpayModel.list.count : 1;
    }else{
        return self.donePayArray.count ? self.donePayArray.count : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 获取cell
    MHHomePayNoteCell *cell;
    MHUnpaySubjectModel *model;
    
    if (self.selectedButton.tag == 0) {
        
        if (self.unpayModel.list.count) {
            cell = [tableView dequeueReusableCellWithIdentifier:payNoteCellID forIndexPath:indexPath];
            model = self.unpayModel.list[indexPath.row];
            
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:MHPayEmptyCellID];
            MHPayEmptyCell *emptyCell = (MHPayEmptyCell *)cell;
            emptyCell.titleLabel.text = @"暂无待缴费用";
            return cell;
        }
        
    }else if (self.selectedButton.tag == 1){
        
        if (self.donePayArray.count) {
            cell = [tableView dequeueReusableCellWithIdentifier:payNoteCellID forIndexPath:indexPath];
            model = self.donePayArray[indexPath.row];

        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:MHPayEmptyCellID];
            MHPayEmptyCell *emptyCell = (MHPayEmptyCell *)cell;
            emptyCell.titleLabel.text = @"暂无缴费记录";
            return cell;
        }
    }
    // 2. 传递模型
    cell.model = model;
    // 3. 返回cell
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedButton.tag == 0) {
        return self.unpayModel.list.count ? 72 : MScreenH - 316 - 64;
    }else{
        return self.donePayArray.count ? 72 : MScreenH - 316 - 64;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.lineView.mh_x = self.selectedButton.mh_x;
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedButton.tag == 0) {
        if (self.unpayModel.list.count == 0) {
            return;
        }
        MHHomePayDetailsController *vc = [MHHomePayDetailsController new];
        vc.property_id = self.room.struct_id.stringValue;
        self.payProperty_id = self.room.struct_id.stringValue;
        MHUnpaySubjectModel *model = self.unpayModel.list[indexPath.row];
        vc.fee_date = model.date;
        vc.payControllerType = MHHomePayControllerTypePay;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        if (self.donePayArray.count == 0) {
            return;
        }
        MHUnpaySubjectModel *model = self.donePayArray[indexPath.row];
        MHHomePayDetailsController *vc = [MHHomePayDetailsController new];
        vc.property_id = self.room.struct_id.stringValue;
        vc.fee_date = model.datetime;
        vc.payControllerType = MHHomePayControllerTypeDetails;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 按钮点击事件
/**
 切换房间
 */
- (IBAction)switchRoomButtonClick:(UIButton *)button {

    MHHomePayMyRoomController *vc = [[MHHomePayMyRoomController alloc] init];
    vc.type = MHHomePayMyRoomControllerTypePay;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)needPayChooseClick:(UIButton *)button {
    // 1. 切换界面
    if (button.tag == 0) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
        [self loaduUnpayDataCompleteBlock:^{
            [self changeButton:button];
        }];
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self loadDonePayDataCompleteBlock:^{
            [self changeButton:button];
        }];
    }
    
}

- (void)changeButton:(UIButton *)button{
    
    if (self.selectedButton == button) {
        return;
    }
    
    button.enabled = NO;
    
    self.selectedButton.enabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.mh_x = button.mh_x;
        self.bottomView.mh_y = button.tag==0&&self.unpayModel.list.count ?  self.view.mh_h - self.bottomView.mh_h : self.view.mh_h;
    }];
    self.selectedButton = button;
}


#pragma mark - 房间信息卡片的切换按钮显示/隐藏
- (void)showRoomSelectButton:(BOOL)show {
    self.reselectRoomView.hidden = !show;
    self.reselectRoomViewHeight.constant = !show?0:57;
}

#if DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif

@end
