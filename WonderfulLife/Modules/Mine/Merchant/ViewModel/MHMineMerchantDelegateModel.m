//
//  MHMineMerchantDelegateModel.m
//  WonderfulLife
//
//  Created by Lucas on 17/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerchantDelegateModel.h"
#import "MHMacros.h"
#import "MHVoSeverPageCell.h"
#import "MHWeakStrongDefine.h"
@implementation MHMineMerchantDelegateModel

static float headView_H = 184 ;

- (void)mh_delegateConfig{
    self.weakCollectionView.contentInset = UIEdgeInsetsMake(headView_H, 0, 0, 0);
    [self.weakCollectionView addSubview:self.headView];
    self.mh_collectionViewRowCellBlock = ^(NSIndexPath *indexPath ,UICollectionViewCell<MHCellConfigDelegate> *acell){
        MHVoSeverPageCell *cell = (MHVoSeverPageCell *)acell;
        if(indexPath.row % 3 < 2){
            cell.rightLineView.hidden = NO;
        }else{
            cell.rightLineView.hidden = YES;
        }
    };
}

- (MHMineMerchantHeaderView *)headView {
    if(!_headView){
        MHWeakify(self)
        _headView = [MHMineMerchantHeaderView merCreatHeaderViewWithFrame:CGRectMake(0, -headView_H, MScreenW, headView_H) block:^(MHMineMerchantHeaderView *viwe) {
            MHStrongify(self)
            if (self.block) {
                self.block(self);
            }
        }];
    }
    return _headView;
}

@end
