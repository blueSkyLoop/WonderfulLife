//
//  MHCeSlectedCityController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCeSlectedCityController.h"
#import "MHVolSlectedCityListController.h"

#import "MHLoginRequestHandler.h"
#import "MHCityModel.h"
#import "MHHUDManager.h"

#import "MHWeakStrongDefine.h"
#import <HLCategory/UIViewController+HLStoryBoard.h>
#import "UIViewController+HLNavigation.h"
#import "MHLoSelectCityCell.h"

@interface MHCeSlectedCityController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy,nonatomic) NSArray<MHCityModel *> *cities;
@end

@implementation MHCeSlectedCityController

- (instancetype)initWithType:(MHCeSlectedCityType)type {
    if ([super init]) {
        self.type = type ;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MHLoSelectCityCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MHLoSelectCityCell class])];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = layout;
    
    [MHHUDManager show];
    [MHLoginRequestHandler postHotCityListSuccess:^(NSArray *cities) {
        self.cities = [cities copy];
        [self.collectionView reloadData];
        [MHHUDManager dismiss];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}


#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    MHVolSlectedCityListController *vc = [[MHVolSlectedCityListController alloc] init];
    vc.currentCity = self.cities[indexPath.item];
    MHWeakify(self)
    vc.callBack = ^(MHCityModel *city, MHCommunityModel *community) {
        MHStrongify(self)
        //当前界面
        [self.navigationController popViewControllerAnimated:NO];
        //上一个界面
        [self.navigationController popViewControllerAnimated:YES];
        if (self.callBack) self.callBack(city, community);
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHLoSelectCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MHLoSelectCityCell class]) forIndexPath:indexPath];
    [cell.mh_textLabel setText:self.cities[indexPath.item].city_name];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
         return self.cities.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(76, 36);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 13;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 16, 32, 16);
}

@end
