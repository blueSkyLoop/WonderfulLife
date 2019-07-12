//
//  MHStorePictureView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStorePictureView.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "MHBaseCollectionDelegateModel.h"

#import "MHReportRepairPhotoPreViewController.h"
#import "MHReportRepairPictreCell.h"

@interface MHStorePictureView()

@property (nonatomic,strong,readwrite)UICollectionView *collectionView;

@property (nonatomic,strong)MHBaseCollectionDelegateModel *delegateModel;


@end

@implementation MHStorePictureView
@synthesize picArr = _picArr;

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

- (void)setPicArr:(NSMutableArray *)picArr{
    [self.picArr removeAllObjects];
    for(int i=0;i<picArr.count;i++){
        MHReportRepairPictureModel *model = [MHReportRepairPictureModel new];
        model.pictreUrlStr = picArr[i];
        [self.picArr addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)setUpUI{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    @weakify(self);
    self.delegateModel = [[MHBaseCollectionDelegateModel alloc] initWithDataArr:self.picArr collectionView:self.collectionView cellClassNames:@[NSStringFromClass(MHReportRepairPictreCell.class)] cellDidSelectedBlock:^(NSIndexPath *indexPath, NSString *cellModel) {
        @strongify(self);
        MHReportRepairPhotoPreViewController *photoVC = [MHReportRepairPhotoPreViewController new];
        photoVC.clickNum = indexPath.row;
        photoVC.dataArr = [self getAllPicture];
        [[self viewController].navigationController pushViewController:photoVC animated:YES];
    }];
    
    self.delegateModel.mh_collectionViewRowCellBlock = ^(NSIndexPath *indexPath, UICollectionViewCell<MHCellConfigDelegate> *acell){
        MHReportRepairPictreCell *cell = (MHReportRepairPictreCell *)acell;
        cell.closeButton.hidden = YES;
    };

}

- (NSMutableArray *)getAllPicture{
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:self.picArr.count];
    for(int i=0;i<self.bigPicArr.count;i++){
        MHReportRepairPhotoPreViewModel *model = [MHReportRepairPhotoPreViewModel new];
        model.bigPicUrl = self.bigPicArr[i];
        model.type = 1;
        [muArr addObject:model];
    }
    return muArr;
}

//获取控制器
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark - lazyload
- (UICollectionView *)collectionView{
    if(!_collectionView){
        CGFloat width = (MScreenW - 24 * 2 - 19 * 2) / 3.0;
        CGSize itemSize = CGSizeMake(width , width);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = itemSize;
        layout.minimumInteritemSpacing = 19;
        layout.minimumLineSpacing = 18;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [MHBaseCollectionDelegateModel createCollectionViewWithLayout:layout rigistNibCellNames:@[NSStringFromClass(MHReportRepairPictreCell.class)] rigistClassCellNames:nil];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
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
