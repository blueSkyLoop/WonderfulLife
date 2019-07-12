//
//  MHReportRepairPictureView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairPictureView.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "ReactiveObjC.h"

#import "MHReportRepairPictreCell.h"

@implementation MHReportRepairPictureModel


@end

@implementation MHReportRepairPictureDelegateModel

- (void)mh_delegateConfig{
    @weakify(self);
    self.mh_collectionViewRowCellBlock = ^(NSIndexPath *indexPath, UICollectionViewCell<MHCellConfigDelegate> *acell) {
        @strongify(self);
        MHReportRepairPictreCell *cell = (MHReportRepairPictreCell *)acell;
        cell.pictureCloseBlock = self.mhReportPictureCloseBlock;
        cell.closeButton.hidden = !self.needShowCloseButton;
        MHReportRepairPictureModel *tempModel = self.dataArr[indexPath.row];
        if(tempModel.isTakePhoto){
            cell.closeButton.hidden = YES;
        }
        
    };
}


@end



@interface MHReportRepairPictureView()

@property (nonatomic,strong,readwrite)UICollectionView *collectionView;

@property (nonatomic,strong)MHReportRepairPictureDelegateModel *delegateModel;

@property (nonatomic,strong)NSMutableArray *picArr;

@end

@implementation MHReportRepairPictureView
- (id)init{
    self = [super init];
    if(self){
        [self setUpUI];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (void)setNeedShowTakePhoto:(BOOL)needShowTakePhoto{
    if(_needShowTakePhoto != needShowTakePhoto){
        _needShowTakePhoto = needShowTakePhoto;
        MHReportRepairPictureModel *findModel;
        for(MHReportRepairPictureModel *model in self.picArr){
            if(model.isTakePhoto){
                findModel = model;
                break;
            }
        }
        if(_needShowTakePhoto){
            if(!findModel && (self.pictureArr.count < self.limitNum)){
                MHReportRepairPictureModel *model = [MHReportRepairPictureModel new];
                model.isTakePhoto = YES;
                [self.picArr addObject:model];
                [self.collectionView reloadData];
            }
        }else{
            if(findModel){
                [self.picArr removeObject:findModel];
                [self.collectionView reloadData];
            }
        }
    }
}

- (void)setNeedShowCloseButton:(BOOL)needShowCloseButton{
    if(_needShowCloseButton != needShowCloseButton){
        _needShowCloseButton = needShowCloseButton;
        if(_delegateModel){
            self.delegateModel.needShowCloseButton = _needShowCloseButton;
        }
        if(_collectionView){
            [self.collectionView reloadData];
        }
    }
}

- (void)setItemGap:(CGFloat)itemGap{
    if(_itemGap != itemGap){
        _itemGap = itemGap;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.minimumInteritemSpacing = _itemGap;
        [self.collectionView reloadData];
    }
}

- (void)setItemSize:(CGSize)itemSize{
    if(!CGSizeEqualToSize(_itemSize, itemSize)){
        _itemSize = itemSize;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.itemSize = _itemSize;
        [self.collectionView reloadData];
    }
}

- (void)setPictureArr:(NSArray *)pictureArr{
    _pictureArr = pictureArr;
    [self.picArr removeAllObjects];
    for(int i=0;i<_pictureArr.count;i++){
        MHReportRepairPictureModel *model = [MHReportRepairPictureModel new];
        if([_pictureArr[i] isKindOfClass:[NSString class]]){
            model.pictreUrlStr = _pictureArr[i];
            [self.picArr addObject:model];
        }else if([_pictureArr[i] isKindOfClass:[UIImage class]]){
            model.image = _pictureArr[i];
            [self.picArr addObject:model];
        }
    }
    if(self.needShowTakePhoto && (_pictureArr.count < self.limitNum)){
        MHReportRepairPictureModel *model = [MHReportRepairPictureModel new];
        model.isTakePhoto = YES;
        [self.picArr addObject:model];
    }
    if(_collectionView){
        [self.collectionView reloadData];
    }
}

- (void)setUpUI{
    self.limitNum = 3;
    self.needShowTakePhoto = YES;
    self.needShowCloseButton = YES;
   
    //默认间距
    self.itemGap = 19;
    CGFloat width = (MScreenW - self.itemGap * 2) / 3.0;
    self.itemSize = CGSizeMake(width , width);
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    @weakify(self);
    self.delegateModel = [[MHReportRepairPictureDelegateModel alloc] initWithDataArr:self.picArr collectionView:self.collectionView cellClassNames:@[NSStringFromClass(MHReportRepairPictreCell.class)] cellDidSelectedBlock:^(NSIndexPath *indexPath, MHReportRepairPictureModel *cellModel) {
        @strongify(self);
        if(self.pictreCollectionViewDidSelectBlock){
            self.pictreCollectionViewDidSelectBlock(indexPath, cellModel);
        }
    }];
    
    self.delegateModel.needShowCloseButton = self.needShowCloseButton;
    
    self.delegateModel.mhReportPictureCloseBlock = ^(MHReportRepairPictureModel *model){
        @strongify(self);
        if([self.picArr containsObject:model]){
            NSInteger index = [self.picArr indexOfObject:model];
            [self.picArr removeObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished) {
                if(self.pictureRemoveBlock){
                    self.pictureRemoveBlock(model,index);
                }
                if(self.picArr.count < self.limitNum && self.needShowTakePhoto){
                    MHReportRepairPictureModel *findModel;
                    for(MHReportRepairPictureModel *model in self.picArr){
                        if(model.isTakePhoto){
                            findModel = model;
                            break;
                        }
                    }
                    if(!findModel){
                        MHReportRepairPictureModel *model = [MHReportRepairPictureModel new];
                        model.isTakePhoto = YES;
                        [self.picArr addObject:model];
                        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.picArr.count - 1 inSection:0]]];
                    }
                }
            }];
        }
    };
}

- (NSInteger)remvoeIndexWithModel:(MHReportRepairPictureModel *)model{
    if([[self.pictureArr firstObject] isKindOfClass:[NSString class]]){
        if([self.pictureArr containsObject:model.pictreUrlStr]){
            return [self.pictureArr indexOfObject:model.pictreUrlStr];
        }
    }
    else if([[self.pictureArr firstObject] isKindOfClass:[UIImage class]]){
        if([self.pictureArr containsObject:model.image]){
            return [self.pictureArr indexOfObject:model.image];
        }
    }
    return NSNotFound;
}

#pragma mark - lazyload
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.itemSize;
        layout.minimumInteritemSpacing = self.itemGap;
        _collectionView = [MHReportRepairPictureDelegateModel createCollectionViewWithLayout:layout rigistNibCellNames:@[NSStringFromClass(MHReportRepairPictreCell.class)] rigistClassCellNames:nil];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (NSMutableArray *)picArr{
    if(!_picArr){
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}

@end
