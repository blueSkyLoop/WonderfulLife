//
//  MHReportRepairPhotoPreViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairPhotoPreViewController.h"

#import "MHReportRepairPhotoPreviewDelegateModel.h"
#import "MHReportRepairPhotoPreviewCell.h"
#import "MHReportRepairDeletePictureView.h"

#import "MHNavigationControllerManager.h"


static CGFloat const margin = 20;

@interface MHReportRepairPhotoPreViewController ()<MHNavigationControllerManagerProtocol>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)MHReportRepairPhotoPreviewDelegateModel *delegateModel;
@property (nonatomic,strong)UIView *navBarView;
@property (nonatomic,strong)UIView *navBgView;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UIButton *deleteButton;

/**
 *  中间的标题
 */
@property(nonatomic,strong)UILabel * titleLable;

@end

@implementation MHReportRepairPhotoPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    [self bindViewModel];
    
    [self resetBackNaviItem];
    
    //隐藏导航，采用自定义
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpNaviBarView];
    
}

- (void)setUpNaviBarView{
    self.navBgView = [UIView new];
    self.navBgView.backgroundColor = [UIColor whiteColor];
    self.navBgView.clipsToBounds = YES;
    
    self.navBarView = [UIView new];
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [self.backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.backButton setTitleColor:MRGBColor(50, 64, 87) forState:UIControlStateNormal];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [self.backButton sizeToFit];
    [self.backButton addTarget:self action:@selector(nav_back) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.titleLable.font = [UIFont systemFontOfSize:17];
    self.titleLable.textColor = MRGBColor(50, 64, 87);
    self.titleLable.text = [NSString stringWithFormat:@"%d/%d",(int)self.clickNum,(int)self.dataArr.count];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    
    [self.navBarView addSubview:self.backButton];
    [self.navBarView addSubview:self.titleLable];
    [self.navBgView addSubview:self.navBarView];
    [self.view addSubview:self.navBgView];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBarView.mas_left).offset(10);
        make.centerY.equalTo(self.navBarView.mas_centerY);
        make.height.equalTo(@44);
    }];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navBarView);
    }];
    [_navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navBgView);
        make.height.equalTo(@44);
    }];
    [_navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
}
//子类重写此方法
- (void)nav_back{
    [self.navBgView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//右滑手势禁止代理
- (BOOL)bb_ShouldBack{
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.collectionView setContentOffset:CGPointMake(self.clickNum * (MScreenW + margin), 0)];
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat current = self.collectionView.contentOffset.x / (size.width + margin?:20) + 1;
    
    self.titleLable.text = [NSString stringWithFormat:@"%.f/%d",current,(int)self.dataArr.count];
  
    //添加删除按钮
    if(self.showDeleteButton && !self.deleteButton){
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"ReportRepair_estate_delete"] forState:UIControlStateNormal];
        [deleteBtn sizeToFit];
        [deleteBtn addTarget:self action:@selector(deleleAction:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = deleteBtn;
        [self.navBarView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navBarView.mas_right).offset(-15);
            make.centerY.equalTo(self.navBarView.mas_centerY);
            make.height.equalTo(@44);
        }];
    }
}

- (void)setUpUI{
    [self.view addSubview:self.collectionView];
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLable.text = [NSString stringWithFormat:@"%d/%d",(int)self.clickNum,(int)self.dataArr.count];
    _titleLable = titleLable;
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
    
    
}

- (void)deleleAction:(UIButton *)sender{
    
    MHReportRepairDeletePictureView *deleteView = [MHReportRepairDeletePictureView loadViewFromXib];
    [self.view.window addSubview:deleteView];
    [deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view.window);
    }];
    @weakify(self);
    deleteView.deletePictureBlock = ^{
        @strongify(self);
        [self.delegateModel deleteCurrentItem];
    };
    
}

- (void)bindViewModel{
    @weakify(self);
    self.delegateModel = [[MHReportRepairPhotoPreviewDelegateModel alloc] initWithDataArr:self.dataArr collectionView:self.collectionView cellClassNames:@[NSStringFromClass(MHReportRepairPhotoPreviewCell.class)] cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
//        @strongify(self);
        
    }];
    self.delegateModel.margin = margin;
    
    self.delegateModel.titleChangeBlcok = ^(NSString *atitle){
        @strongify(self);
        self.titleLable.text = atitle;
    };
    
    self.delegateModel.previewDeleteBlock = self.previewDeleteBlock;
    
    [self.collectionView reloadData];
    
    self.delegateModel.navBarBlock = ^(){
        @strongify(self);
        if(self.navBgView.isHidden){
            self.navBgView.hidden = NO;
            [self.navBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top);
            }];
            [UIView animateWithDuration:.2 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [UIApplication sharedApplication].statusBarHidden = NO;
            }];
        }else{
            [UIApplication sharedApplication].statusBarHidden = YES;
            [self.navBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(-64);
            }];
            [UIView animateWithDuration:.2 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.navBgView.hidden = YES;
            }];
        }
    };
    
    self.delegateModel.emptyBlock = ^{
        @strongify(self);
        [self nav_back];
    };
}

#pragma mark - lazyload
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = margin;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin/2, 0, margin/2);
        flowLayout.itemSize = CGSizeMake(MScreenW, MScreenH );
        _collectionView = [MHReportRepairPhotoPreviewDelegateModel createCollectionViewWithLayout:flowLayout rigistNibCellNames:@[NSStringFromClass(MHReportRepairPhotoPreviewCell.class)] rigistClassCellNames:nil];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.frame = CGRectMake(-margin/2, 0, MScreenW + margin, MScreenH );
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (NSMutableArray <MHReportRepairPhotoPreViewModel *>*)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
