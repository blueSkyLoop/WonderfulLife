//
//  MHVolSerReviewDetailController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerReviewDetailController.h"
#import "MHVolSerDistributeController.h"

#import "MHThemeButton.h"
#import "MHAlertView.h"
#import "MHVolSerRefuseAlertView.h"
#import "MHVoApplyDetailView.h"

#import "MHVolSerReviewApplyDetailModel.h"
#import "MHVoServerRequestDataHandler.h"

#import "MHMacros.h"
#import "MHHUDManager.h"
#import "MHConst.h"
#import "MHWeakStrongDefine.h"

#import "UIViewController+MHConfigControls.h"
#import "UIViewController+MHTelephone.h"
#import "UIView+NIM.h"
#import "NSString+HLJudge.h"
#import "UIImage+Color.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface MHVolSerReviewDetailController ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIView *applyContainerView;
@property (nonatomic,strong) UIView *applyDetailContainerView;
@property (nonatomic,weak) MHVoApplyDetailView *applydetailView;
@property (nonatomic,weak) MHVoApplyDetailIconView *detailIconView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *statusImv;

@property (nonatomic, strong) MHVolSerReviewApplyDetailModel *model;

@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation MHVolSerReviewDetailController{
    CGFloat scale;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MTopStatus_Height, MScreenW, MScreenH - MTopStatus_Height)];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    scale = MScreenW/375;
    [self setupTopLabel];
    
    [self requestGetDetailData];
    
    MHWeakify(self);
    [self setRefreshRevokeBlock:^{
        MHStrongify(self);
        self.statusImv.image = [UIImage imageNamed:@"vo_se_back"];
        [self.applydetailView addSubview:self.statusImv];
        [self.bottomView removeFromSuperview];
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.scrollView);
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolunteerReviewPageNotification object:nil];
    }];
}

- (void)setupTopLabel{
    UILabel *TopLabel = [[UILabel alloc] init];
    TopLabel.font = [UIFont systemFontOfSize:34*scale];
    
    TopLabel.textColor = MRGBColor(50, 64, 87);
    TopLabel.text = @"申请详情";
    TopLabel.textAlignment = NSTextAlignmentCenter;
    [TopLabel sizeToFit];
    TopLabel.nim_centerX = self.scrollView.nim_width/2;
    TopLabel.nim_top = 64;
    UIView *headerView  = [[UIView alloc] init];
    [headerView addSubview:TopLabel];
    
    CGFloat headerH = TopLabel.nim_bottom+32*scale;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerH-0.5, self.scrollView.nim_width, 0.5)];
    line.backgroundColor = MColorSeparator;
    [headerView addSubview:line];
    
    [self.scrollView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.scrollView);
        make.height.equalTo(@(headerH));
    }];
    self.headerView = headerView;
}

- (void)setupContainerView{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = MColorToRGB(0xf9fafc);
    [self.scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.width.equalTo(self.scrollView);
        make.top.equalTo(self.headerView.mas_bottom);
        //此时还没确定containerView的高，在ApplyDetailContainerView处确定
    }];
    self.containerView = containerView;
}

- (void)setupApplyContainerView{//
    UIView *applyContainerView = [UIView new];
    applyContainerView.backgroundColor = [UIColor whiteColor];
    [self setupContainerLayerWithContainerView:applyContainerView];
    self.applyContainerView = applyContainerView;
    [self.containerView addSubview:applyContainerView];
    [applyContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(self.containerView);
        make.width.equalTo(self.containerView).multipliedBy(343/375.0);
        //此时还没确定applyContainerView的高，在子子控件确定。
        
    }];
    
    MHVoApplyDetailView *applydetailView = [MHVoApplyDetailView voApplyDetailView];
    [applyContainerView addSubview:applydetailView];
    self.applydetailView = applydetailView;
    
    if (self.type == MHVolSerReviewDetailControllerRefuse) {
        
        [applydetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(applyContainerView);

        }];
        
        MHVoApplyDetailView *refuseView = [MHVoApplyDetailView voApplyDetailView];
        refuseView.titleLabel.text = @"拒绝原因";
        refuseView.detailLabel.text = _model.reason;
        [self.applyContainerView addSubview:refuseView];
        [refuseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.applyContainerView);
            make.top.equalTo(applydetailView.mas_bottom);
            
            //有拒绝原因的情况下,确定高度
            make.bottom.equalTo(self.applyContainerView);
            
        }];
    }else{
        
        [applydetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(applyContainerView);
            //没有拒绝原因的情况下,确定高度
            make.bottom.equalTo(applyContainerView);
        }];

    }
    
    }

- (void)setupApplyDetailContainerView{
    UIView *applyDetailContainerView = [UIView new];
    applyDetailContainerView.backgroundColor = [UIColor whiteColor];
    [self setupContainerLayerWithContainerView:applyDetailContainerView];
    
    [self.containerView addSubview:applyDetailContainerView];
    self.applyDetailContainerView = applyDetailContainerView;
    [applyDetailContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyContainerView.mas_bottom).offset(24);
        make.centerX.equalTo(self.containerView);
        make.width.equalTo(self.containerView).multipliedBy(343/375.0);
        //此时还没确定applyDetailContainerView的高，在子子控件确定。
        
        make.bottom.equalTo(self.containerView).offset(-40);//确定ContainerView的高
        
    }];
    
    MHVoApplyDetailIconView *detailIconView = [MHVoApplyDetailIconView voApplyDetailIconView];
    [applyDetailContainerView addSubview:detailIconView];
    self.detailIconView = detailIconView;
    [detailIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(applyDetailContainerView);
        make.height.equalTo(@127);
    }];
    
    for (NSInteger i = 0; i < 5; i++) {
        MHVoApplyDetailView *detailView = [MHVoApplyDetailView voApplyDetailView];
        [applyDetailContainerView addSubview:detailView];
        [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(applyDetailContainerView);
            make.top.equalTo(i==0? detailIconView.mas_bottom : applyDetailContainerView.subviews[i].mas_bottom);
            if (i == 4) {//确定applyDetailContainerView的高
                make.bottom.equalTo(applyDetailContainerView);
            }
        }];
    }
}

- (void)setupContainerLayerWithContainerView:(UIView *)containerView{
    
    containerView.layer.cornerRadius = 6;
    containerView.layer.borderColor = MColorSeparator.CGColor;
    containerView.layer.borderWidth = 0.5;
    
    containerView.layer.shadowOffset = CGSizeMake(0, 2);
    containerView.layer.shadowRadius = 5;
    containerView.layer.shadowColor = MColorShadow.CGColor;
    containerView.layer.shadowOpacity = 1;
    containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

- (void)setupTypeControls:(MHVolSerReviewDetailControllerType)type {
    
    switch (type) {
        case MHVolSerReviewDetailControllerReview:
        {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.scrollView).offset(-60);
            }];
            [self.view addSubview:self.bottomView];
        }
            break;
        case MHVolSerReviewDetailControllerPass:
        {
            self.statusImv.image = [UIImage imageNamed:@"vo_se_pass"];
            [self.applydetailView addSubview:self.statusImv];
        }
            break;
        case MHVolSerReviewDetailControllerRefuse:
        {
            self.statusImv.image = [UIImage imageNamed:@"vo_se_refuse"];
            [self.applydetailView addSubview:self.statusImv];
        }
            break;
        case MHVolSerReviewDetailControllerBack:
        {
            self.statusImv.image = [UIImage imageNamed:@"vo_se_back"];
            [self.applydetailView addSubview:self.statusImv];
        }
            break;
    }
}


#pragma mark - Request
- (void)requestGetDetailData {
    [MHVoServerRequestDataHandler getVolunteerApplyDetailWithApplyId:self.applyId Success:^(MHVolSerReviewApplyDetailModel *dataSource) {
        _model = dataSource;
        
        [self setupContainerView];
        [self setupApplyContainerView];
        [self setupApplyDetailContainerView];
        
        if ([_model.apply_status isEqualToNumber:@1]) {
            self.statusImv.image = [UIImage imageNamed:@"vo_se_pass"];
            [self.applydetailView addSubview:self.statusImv];
        } else if ([_model.apply_status isEqualToNumber:@2]) {
            self.statusImv.image = [UIImage imageNamed:@"vo_se_refuse"];
            [self.applydetailView addSubview:self.statusImv];
        }else if ([_model.apply_status isEqualToNumber:@3]) {
            self.statusImv.image = [UIImage imageNamed:@"vo_se_back"];
            
        }else if ([_model.apply_status isEqualToNumber:@0]) {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.scrollView).offset(-60);
            }];
            [self.view addSubview:self.bottomView];
           
            
        }
        
        
        self.applydetailView.titleLabel.text = @"申请加入";
        self.applydetailView.detailLabel.text = _model.activity_name;
        
        self.detailIconView.nameLabel.text = _model.real_name;
        self.detailIconView.detailLabel.text = _model.age;
        [self.detailIconView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.headphoto_s_url] placeholderImage:MAvatar];
        for (NSInteger i = 1; i < 6; i++) {
            MHVoApplyDetailView *view = self.applyDetailContainerView.subviews[i];
            if (i == 1) {
                view.titleLabel.text = @"电话";
                view.detailLabel.text = _model.phone;
            }else if (i == 2){
                view.titleLabel.text = @"住址";
                view.detailLabel.text = _model.address;
            }else if (i == 3){
                view.titleLabel.text = @"爱好特长";
                view.detailLabel.text = _model.hobby;
            }else if (i == 4){
                view.titleLabel.text = @"需要帮助";
                view.detailLabel.text = _model.need_help;
            }else if (i == 5){
                view.titleLabel.text = @"申请时间";
                view.detailLabel.text = _model.apply_date;
            }
        }
        
        
    } failure:^(NSString *errmsg) {
      
    }];
}

/** 拒绝  */
- (void)requestRefuseWithReason:(NSString *)reason {
    [MHHUDManager show];
    [MHVoServerRequestDataHandler postVolunteerApplyDenyWithApplyId:self.applyId
                                                             reason:reason
                                                            Success:^{
        [MHHUDManager dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolunteerReviewPageNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

#pragma mark - Event
- (void)agreeAction {
    MHVolSerDistributeController *vc = [[MHVolSerDistributeController alloc] init];
    vc.applyId = self.model.apply_id;
    vc.name = self.model.real_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refuseAction {
    MHWeakify(self)
    [MHVolSerRefuseAlertView volSerRefuseAlertViewWithTitle:@"拒绝原因"  tipStr:@"填写拒绝原因150字以内" clickSureButtonBlock:^(NSString *reason) {
        MHStrongify(self)
        NSString *message = [NSString stringWithFormat:@"确定拒绝%@的加入申请？", self.model.real_name];
        [[MHAlertView sharedInstance] showNormalAlertViewTitle:message message:nil leftHandler:^{
            
        } rightHandler:^{
            //request
            [self requestRefuseWithReason:reason];
        } rightButtonColor:nil];
    }];
}


#pragma mark - Setter

#pragma mark - Getter
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, self.view.nim_height - 60, self.view.nim_width, 60);
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView addSubview:({
            UIView *topLine = [UIView new];
            topLine.frame = CGRectMake(0, 0, _bottomView.nim_width, 1);
            topLine.backgroundColor = MColorSeparator;
            topLine;
        })];
        
        [_bottomView addSubview:({
            MHThemeButton *refuseBtn = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, 1, _bottomView.nim_width / 2.0, _bottomView.nim_height - 1)];
            [refuseBtn setTitle:@"拒 绝" forState:UIControlStateNormal];
            [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            refuseBtn.titleLabel.font = MFont(19);
            refuseBtn.noShadow = YES;
            refuseBtn.layer.masksToBounds = NO;
            [refuseBtn addTarget:self action:@selector(refuseAction) forControlEvents:UIControlEventTouchDown];
            refuseBtn;
        })];
        
        [_bottomView addSubview:({
            UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_bottomView.nim_width / 2.0, 1, _bottomView.nim_width / 2.0, _bottomView.nim_height - 1)];
            [agreeBtn setTitle:@"同 意" forState:UIControlStateNormal];
            [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            agreeBtn.titleLabel.font = MFont(19);
            [agreeBtn setBackgroundImage:[UIImage mh_gradientImageWithBounds:agreeBtn.bounds direction:UIImageGradientDirectionRight colors:@[MColorToRGB(0x00e3ae),MColorToRGB(0x9be15d)]] forState:UIControlStateNormal];
            [agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchDown];
            agreeBtn;
        })];
    }
    return _bottomView;
}

- (UIImageView *)statusImv {
    if (!_statusImv) {
        _statusImv = [UIImageView new];
        [self.applydetailView addSubview:_statusImv];
        [_statusImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@67);
            make.right.equalTo(@-20);
            make.centerY.equalTo(self.applydetailView);
        }];
    }
    return _statusImv;
}

#if DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif

@end
