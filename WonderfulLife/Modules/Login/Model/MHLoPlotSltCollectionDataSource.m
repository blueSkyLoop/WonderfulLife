//
//  MHLoPlotSltCollectionDataSource.m
//  WonderfulLife
//
//  Created by zz on 01/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHLoPlotSltCollectionDataSource.h"

#import "MHLoSelectCityCell.h"
#import "MHCollectionHeaderView.h"

#import "MHMacros.h"
#import "MHCityModel.h"
#import "UIView+HLChainStyle.h"


@interface MHLoPlotSltCollectionDataSource()


@end

@implementation MHLoPlotSltCollectionDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if ([self.mapCity.city_name isEqualToString:@"无法定位"]) return;
    }
    
    [self.resultSubject sendNext:indexPath];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHLoSelectCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MHLoSelectCityCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.mh_textLabel setText:self.mapCity.city_name];
    } else {
        [cell.mh_textLabel setText:self.dataSource[indexPath.item].city_name];
    }
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.mapCity?1:0;
    } else {
        return self.dataSource.count;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MHCollectionHeaderView *sectionView = (MHCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MHCollectionHeaderView class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [sectionView.titleLabel setText:@"定位城市"];
        sectionView.titleLabel.hl_x(35);
        sectionView.imageView.hidden = NO;
        [sectionView.imageView setImage:[UIImage imageNamed:@"lo_localtion"]];
        sectionView.topLine.hidden = NO;
        sectionView.bottomLine.hidden = YES;
    } else {
        [sectionView.titleLabel setText:@"热门城市"];
        sectionView.titleLabel.hl_x(16);
        sectionView.imageView.hidden = YES;
        sectionView.topLine.hidden = YES;
        sectionView.bottomLine.hidden = YES;
    }
    return sectionView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && [self.mapCity.city_name isEqualToString:@"无法定位"])
        return CGSizeMake(100, 36);
    return CGSizeMake(76, 36);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(MScreenW, 32);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 13;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16, 16, 32, 16);
}

#pragma mark - Getter

- (RACSubject*)resultSubject {
    if (!_resultSubject) {
        _resultSubject = [RACSubject subject];
    }
    return _resultSubject;
}

@end
