//
//  MHHomeTableHeaderView.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeTableHeaderView.h"

#import "MHHomeCricleCell.h"
#import "MHHomeButtonCell.h"
#import "MHHomeItemCell.h"
#import "MHMacros.h"
#import "UIView+NIM.h"

static NSString *kHomeCollectionFootKey = @"kHomeCollectionFootKey";

@interface MHHomeTableHeaderView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MHHomeCricleCellDelegate>
@property (nonatomic,weak) UIView *horizontiolLine;
@property (nonatomic,weak) UIView *verticalLine;

@property (nonatomic, copy)   NSArray *btns;
@end

@implementation MHHomeTableHeaderView

- (NSArray *)btns{
    if (!_btns) {
        _btns = @[
                  @{@"title":@"食堂送餐",@"imageUrl":@"MHHomeButtonIcon_food"},
                  @{@"title":@"小区公告",@"imageUrl":@"MHHomeButtonIcon_report"},
                  @{@"title":@"投诉报修",@"imageUrl":@"MHHomeButtonIcon_repair"},
                //  @{@"title":@"邻里互助",@"imageUrl":@"MHHomeButtonIcon_help"},
                 // @{@"title":@"美好财富",@"imageUrl":@"MHHomeButtonIcon_financial"},
                 // @{@"title":@"免息商城",@"imageUrl":@"MHHomeButtonIcon_shop"},
                  @{@"title":@"扫一扫",@"imageUrl":@"MHHomeButtonIcon_QR"},
              //    @{@"title":@"更多",@"imageUrl":@"MHHomeButtonIcon_more"}
                  ];
    }return _btns;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]]) {
        [self setUp];
    } return self;
}

- (void)setUp {
    [self setBackgroundColor:[UIColor whiteColor]];
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([MHHomeCricleCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MHHomeCricleCell class])];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([MHHomeButtonCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MHHomeButtonCell class])];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([MHHomeItemCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MHHomeItemCell class])];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kHomeCollectionFootKey];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeCollectionFootKey];
    
    UIView *horizontiolLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 0.5)];
    horizontiolLine.backgroundColor = MColorDisableBtn ;
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(MScreenW/2-1, 0, 0.5, 185)];
    verticalLine.backgroundColor = MColorDisableBtn;
    [self addSubview:horizontiolLine];
    [self addSubview:verticalLine];
    self.horizontiolLine = horizontiolLine;
    self.verticalLine = verticalLine;
}

- (void)refreshWithBannerList:(NSArray<MHHomeBannerAd *>*)bannerList {
    [((MHHomeCricleCell*)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]])refreshWithBannerList:bannerList];
}


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        //        [self.customDelegate didSelectBannerItem:indexPath.item];
    } else if (indexPath.section == 1) {
        [self.customDelegate didSelectTenementItem:self.btns[indexPath.item]];
    } else {
        [self.customDelegate didSelectFacilityItem:indexPath.item];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MHHomeCricleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MHHomeCricleCell class]) forIndexPath:indexPath];
        cell.delegate = self ;
        return cell;
    } else if (indexPath.section == 1) {
        MHHomeButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MHHomeButtonCell class]) forIndexPath:indexPath];
        cell.topView.hidden = YES;
        cell.rightView.hidden = YES;
        cell.leftView.hidden = YES;
        cell.bottomView.hidden = YES;
        
        
        
        NSDictionary *dic  = self.btns [indexPath.row];
        
        NSString *title    = [dic objectForKey:@"title"];
        NSString *imageUrl = [dic objectForKey:@"imageUrl"];
        
        [cell.mh_imageView setImage:[UIImage imageNamed:imageUrl]];
        [cell.mh_titleLabel setText:title];
        
        return cell;
    } else {
        MHHomeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MHHomeItemCell class]) forIndexPath:indexPath];
        if (indexPath.row == 0) {
            self.verticalLine.nim_top = cell.nim_top;
            self.horizontiolLine.nim_top = cell.nim_bottom;
        }
        [cell.mh_imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MHHomeItemIcon%ld",indexPath.item]]];
        [cell.mh_label setText:({
            [@[@"幸福食堂",
               @"童心课堂",
               @"智善书院",
               @"便民理发"] objectAtIndex:indexPath.row];
        })];
        
        [cell.mh_subLabel setText:({
            [@[@"关怀社区老人",
               @"免费辅导孩子",
               @"开办兴趣课程",
               @"老人免费理发"] objectAtIndex:indexPath.row];
        })];
        return cell;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeCollectionFootKey forIndexPath:indexPath];
    if (indexPath.section == 2) {
        [view setBackgroundColor:MColorBackgroud];
    }else{
        [view setBackgroundColor:[UIColor whiteColor]];
    }
        return view;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) return 1;
    else if (section == 1) return self.btns.count;
    else return 4;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return CGSizeMake(CGRectGetWidth(self.frame), 168);
    else if (indexPath.section == 1) return CGSizeMake(CGRectGetWidth(collectionView.frame)/4, 94);
    else return CGSizeMake(CGRectGetWidth(collectionView.frame)/2-0.5, 92);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return CGSizeMake(MScreenW, 20);
    }else {
        return CGSizeMake(MScreenW, 12);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return CGSizeMake(MScreenW, 12);
    }else{
        return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return 0.5;
    } else {
        return 0;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 0;
    } else {
        return 0.5;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - HomeCricleCellDelegate
// 首页顶部的ScrollView  点击回调
- (void)didSelectHomeCricleCell:(NSInteger)index{
    [self.customDelegate didSelectBannerItem:index];
}

@end
