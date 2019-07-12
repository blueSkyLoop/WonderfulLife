//
//  MHReportRepairPhotoPreviewDelegateModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairPhotoPreviewDelegateModel.h"

#import "ReactiveObjC.h"
#import "MHMacros.h"

#import "MHReportRepairPhotoPreviewCell.h"


@implementation MHReportRepairPhotoPreviewDelegateModel

- (void)mh_delegateConfig{
    @weakify(self);
    self.mh_collectionViewRowCellBlock = ^(NSIndexPath *indexPath,UICollectionViewCell<MHCellConfigDelegate> *acell){
        @strongify(self);
        MHReportRepairPhotoPreviewCell *cell = (MHReportRepairPhotoPreviewCell *)acell;
        if(!cell.isAddGes){
            cell.ascrollView.delegate = self;
            [self addGestureTapToScrollView:cell.ascrollView];
            cell.isAddGes = YES;
        }
    };
}

- (void)deleteCurrentItem{
    NSInteger current = floorf(self.weakCollectionView.contentOffset.x / (MScreenW + self.margin?:20))  ;
    if(self.dataArr.count > current){
        [self.weakCollectionView performBatchUpdates:^{
            [self.dataArr removeObjectAtIndex:current];
            [self.weakCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:current inSection:0]]];
        } completion:^(BOOL finished) {
            CGFloat acurrent = self.weakCollectionView.contentOffset.x / (MScreenW + self.margin?:20) + 1;
            
            if(self.titleChangeBlcok){
                self.titleChangeBlcok([NSString stringWithFormat:@"%.f/%d",acurrent,(int)self.dataArr.count]);
            }
            
            if(self.previewDeleteBlock){
                self.previewDeleteBlock(current);
            }
            
            if(self.dataArr.count == 0){
                acurrent --;
                //去掉删除按钮,并返回
                if(self.emptyBlock){
                    self.emptyBlock();
                }
            }
            
        }];
        
        
    }
    
}

#pragma mark --- ScrollView 代理
/**
 *  动态改变图片展示的状态
 *
 *  @param scrollView 当前的_bigCollect
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == (UIScrollView *)self.weakCollectionView) {//UICollectionView是继承于UIScrollView的
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat current = scrollView.contentOffset.x / (size.width + self.margin?:20) + 1;
        if(self.dataArr.count == 0){
            current --;
        }
        if(self.titleChangeBlcok){
            self.titleChangeBlcok([NSString stringWithFormat:@"%.f/%d",current,(int)self.dataArr.count]);
        }
    }
}
/**
 *  即将出现的不被方法或者缩小的视图
 *
 *  @param cell           将要出现的Cell
 *  @param indexPath      cell在数据源中得位置
 */
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MHReportRepairPhotoPreviewCell * acell = (MHReportRepairPhotoPreviewCell *)cell;
    acell.ascrollView.zoomScale = 1;
    
}
/**
 *  返回的是图片的视图
 *
 *  @param scrollView 当前的scrollView
 *
 *  @return 返回一个放大或缩小的视图
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews[0];
}
#pragma mark ---  scrollView 添加手势
-(void)addGestureTapToScrollView:(UIScrollView *)scrollView{
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnScrollView:)];
    singleTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnScrollView:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [scrollView addGestureRecognizer:doubleTap];
}
/**
 *  隐藏导航栏和NavgationBar
 *
 *  @param singleTap 单击
 */
-(void)singleTapOnScrollView:(UITapGestureRecognizer *)singleTap{
    
    if(self.navBarBlock){
        self.navBarBlock();
    }
    
}
/**
 *  放大缩小
 *
 *  @param doubleTap 双击
 */
-(void)doubleTapOnScrollView:(UITapGestureRecognizer *)doubleTap{
    
    UIScrollView * scrollView = (UIScrollView *)doubleTap.view;
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3) {
        scale = 3;
    }else{
        scale = 1;
    }
    [self CGRectForScale:scale WithCenter:[doubleTap locationInView:doubleTap.view] ScrollView:scrollView Completion:^(CGRect Rect) {
        [scrollView zoomToRect:Rect animated:YES];
    }];
}
-(void)CGRectForScale:(CGFloat)scale WithCenter:(CGPoint)center ScrollView:(UIScrollView *)scrollView Completion:(void(^)(CGRect Rect))completion{
    CGRect Rect;
    Rect.size.height = scrollView.frame.size.height / scale;
    Rect.size.width  = scrollView.frame.size.width  / scale;
    Rect.origin.x    = center.x - (Rect.size.width  /2.0);
    Rect.origin.y    = center.y - (Rect.size.height /2.0);
    completion(Rect);
}


@end
