//
//  MHVoServerPageDelegateModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoServerPageDelegateModel.h"
#import "MHMacros.h"
#import "MHVoSeverPageCell.h"
#import "ReactiveObjC.h"
#import "MHVolServerPageHeaderReusableView.h"

@interface MHVoServerPageDelegateModel()

@end

@implementation MHVoServerPageDelegateModel

- (void)setApproving_projects:(NSArray *)approving_projects{
    _approving_projects = approving_projects;
    if(self.weakCollectionView && _approving_projects && _approving_projects.count && !self.isCacelNotice){
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.weakCollectionView.collectionViewLayout;
        layout.headerReferenceSize = CGSizeMake(MScreenW, 44);
        [self.weakCollectionView reloadData];
        
    }else if(self.isCacelNotice || !_approving_projects || _approving_projects.count == 0){
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.weakCollectionView.collectionViewLayout;
        layout.headerReferenceSize = CGSizeZero;
        [self.weakCollectionView reloadData];
    }
}

- (void)mh_delegateConfig{
     self.weakCollectionView.contentInset = UIEdgeInsetsMake(245, 0, 0, 0);
    [self.weakCollectionView addSubview:self.headView];
    self.mh_collectionViewRowCellBlock = ^(NSIndexPath *indexPath ,UICollectionViewCell<MHCellConfigDelegate> *acell){
        MHVoSeverPageCell *cell = (MHVoSeverPageCell *)acell;
        if(indexPath.row % 3 < 2){
            cell.rightLineView.hidden = NO;
        }else{
            cell.rightLineView.hidden = YES;
        }
    };
    
    [self.weakCollectionView registerNib:[UINib nibWithNibName:@"MHVolServerPageHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(MHVolServerPageHeaderReusableView.class)];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(kind == UICollectionElementKindSectionHeader){
        if(self.approving_projects && self.approving_projects.count && !self.isCacelNotice){
            MHVolServerPageHeaderReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(MHVolServerPageHeaderReusableView.class) forIndexPath:indexPath];
            [headView loadApprovingProjects:self.approving_projects];
            @weakify(self);
            headView.cancelNotifyBlock = ^{
                @strongify(self);
                UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.weakCollectionView.collectionViewLayout;
                layout.headerReferenceSize = CGSizeZero;
                self.isCacelNotice = YES;
                [self.weakCollectionView reloadData];
            };
            
            return headView;
        }
        return nil;
    }
    return nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y; 
    [self.headView changeColorWithDisplacement:y];
    BOOL islimit = NO;
    if(y >= -64){
        islimit = YES;
    }
    if(self.scorllLimitHeightBlock){
        self.scorllLimitHeightBlock(islimit);
    }
    CGRect frame = self.headView.frame;
    frame.origin.y = y;
    frame.size.height = -y;
    self.headView.frame = frame;
    if(y <= -(245 + 145)){
        [scrollView setContentOffset:CGPointMake(0, -(245 + 150))];
    }
}

- (MHVolServerPageHeadView *)headView{
    if(!_headView){
        _headView = [[MHVolServerPageHeadView alloc] initWithFrame:CGRectMake(0, -245, MScreenW, 245)];
    }
    return _headView;
}

@end
