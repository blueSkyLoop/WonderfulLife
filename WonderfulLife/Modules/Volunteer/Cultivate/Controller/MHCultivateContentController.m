//
//  MHCultivateContentController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCultivateContentController.h"
#import "MHCultivateContentCell.h"
#import "MHVoCultivateModel.h"
#import "MHVolunteerDataHandler.h"
#import "MHVoCultivateContentModel.h"
#import "HLWebViewController.h"

#import <YYModel.h>
#import "MJRefresh.h"

#import "MHHUDManager.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#define MHCultivateContentCellID @"MHCultivateContentCellID"
@interface MHCultivateContentController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,weak) UIView *headerView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSNumber *category_id;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *mj_footer;

@end

@implementation MHCultivateContentController{
    CGFloat scale;
    CGFloat all;
    CGFloat halfTopLabelHeight;
    CGFloat fontRange;
    NSInteger page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    scale = MScreenW/375;
    [self setupTopLabel];
    halfTopLabelHeight = self.topLabel.nim_height/2;
    all = 64 + halfTopLabelHeight - 44;
    fontRange = 34*scale - 17;
    page = 1;
    self.category_id = self.parentModel.category_id;
    
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    [self.collectionView.mj_header beginRefreshing];
    [self loadData];
    
}

#pragma mark - private
- (void)loadData{
    [MHVolunteerDataHandler postVoCultivateContentCategoryListWithPage:[NSString stringWithFormat:@"1"] CategoryID:self.category_id Success:^(NSDictionary *data) {
        NSArray *temp = [NSArray yy_modelArrayWithClass:[MHVoCultivateContentModel class] json:data[@"list"]];
        self.dataList = [NSMutableArray arrayWithArray:temp];
        
        [self.collectionView reloadData];
        if ([data[@"has_next"] integerValue] == 1) {
            page = 2;
            self.collectionView.mj_footer = self.mj_footer;
            [self.mj_footer resetNoMoreData];
        }
    } failure:^(NSString *errmsg) {
        [MHHUDManager showErrorText:errmsg];
    }];
    [self.collectionView.mj_header endRefreshing];
}

- (void)loadMoreData{
    [MHVolunteerDataHandler postVoCultivateContentCategoryListWithPage:[NSString stringWithFormat:@"%zd",page] CategoryID:self.category_id Success:^(NSDictionary *data) {
        NSArray *temp = [NSArray yy_modelArrayWithClass:[MHVoCultivateContentModel class] json:data[@"list"]];
        if (temp.count) {
            [self.dataList addObjectsFromArray:temp];
            [self.mj_footer endRefreshing];
            page ++;
        }else{
            [self.mj_footer endRefreshingWithNoMoreData];
        }
        [self.collectionView reloadData];
    } failure:^(NSString *errmsg) {
        [MHHUDManager showErrorText:errmsg];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)setupTopLabel{
    UILabel *TopLabel = [[UILabel alloc] init];
    TopLabel.font = [UIFont systemFontOfSize:34*scale];
    TopLabel.textColor = MRGBColor(50, 64, 87);
    TopLabel.text = [NSString stringWithFormat:@"%@培训",self.parentModel.category_name];
    TopLabel.textAlignment = NSTextAlignmentCenter;
    [TopLabel sizeToFit];
    TopLabel.nim_centerX = self.view.nim_width/2;
    
    UIView *headerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, 0)];
    headerView.nim_height = TopLabel.nim_bottom+32*scale;
    [headerView addSubview:TopLabel];
    [self.view addSubview:headerView];
    self.topLabel = TopLabel;
    self.headerView = headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MHCultivateContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MHCultivateContentCellID forIndexPath:indexPath];
    MHVoCultivateContentModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        MHVoCultivateContentModel *model = self.dataList[indexPath.row];
    HLWebViewController * vc = [[HLWebViewController alloc]initWithUrl:model.article_url] ;
    [self.navigationController pushViewController:vc animated:YES];
    
    

//    MHCultivateContentDetailController *vc = [[MHCultivateContentDetailController alloc] init];
//    vc.article_id = model.article_id;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.topLabel.nim_top = -(offsetY + self.headerView.nim_height);
    
    CGPoint center = [self.headerView convertPoint:self.topLabel.center toView:self.view];
    
    if (center.y<=44) {
        center.y = 44;
        CGPoint newCenter = [self.view convertPoint:center toView:self.headerView];
        self.topLabel.center = newCenter;
        self.topLabel.font = [UIFont systemFontOfSize:17];
    }else if (center.y-halfTopLabelHeight < 64 && center.y > 44){
        
        CGFloat offset = center.y - 44;
        self.topLabel.font = [UIFont systemFontOfSize:17 + fontRange * offset/all];
    }else{
        self.topLabel.font = [UIFont systemFontOfSize:34*scale];
    }
}

#pragma mark - lazy
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(164*scale, 154*scale);
        layout.sectionInset = UIEdgeInsetsMake(0, 15*scale, 0, 15*scale);
        layout.minimumInteritemSpacing = 15*scale;
        layout.minimumLineSpacing = 24*scale;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, self.view.nim_height-64) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
        collectionView.contentInset = UIEdgeInsetsMake(self.headerView.nim_height, 0, 0, 0);
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[MHCultivateContentCell class] forCellWithReuseIdentifier:MHCultivateContentCellID];
        [self.view addSubview:collectionView];
        [self.view bringSubviewToFront:self.headerView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (MJRefreshAutoNormalFooter *)mj_footer{
    if (_mj_footer == nil) {
        _mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _mj_footer;
}
@end





