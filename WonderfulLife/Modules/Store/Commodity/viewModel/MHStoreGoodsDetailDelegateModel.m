//
//  MHStoreGoodsDetailDelegateModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsDetailDelegateModel.h"
#import "MHMacros.h"
#import "UIImageView+WebCache.h"
#import "LCommonModel.h"
#import "Masonry.h"
#import "ReactiveObjC.h"

#import "MHStorePictureCell.h"
#import "MHStoreGoodsDetailInforCell.h"

@interface MHStoreGoodsDetailDelegateModel()

@property (nonatomic,assign)CGFloat picHeight;

@end

@implementation MHStoreGoodsDetailDelegateModel

- (void)mh_delegateConfig{
    self.picHeight = MScreenW;
    //添加头部
    self.weakTableView.contentInset = UIEdgeInsetsMake(MScreenW, 0, 0, 0);
    [self.weakTableView addSubview:self.headView];
    @weakify(self);
    self.mh_tableViewRowCellClassIndexBlock = ^Class(NSIndexPath *indexPath) {
        if(self.dataArr.count > 1){
            if(indexPath.row == 0){
                return MHStorePictureCell.class;
            }
            return MHStoreGoodsDetailInforCell.class;
        }
        return MHStoreGoodsDetailInforCell.class;
    };
    
    self.mh_tableViewRowsNumBlock = ^NSInteger(NSInteger section) {
        @strongify(self);
        return self.dataArr.count;
    };
    
    self.mh_tableViewRowCellBlock = ^(NSIndexPath *indexPath, UITableViewCell<MHCellConfigDelegate> *acell){
        if([acell isKindOfClass:MHStoreGoodsDetailInforCell.class]){
            @strongify(self);
            MHStoreGoodsDetailInforCell *cell = (MHStoreGoodsDetailInforCell *)acell;
            cell.merchantClikBlock = self.merchantClikBlock;
            cell.topLineView.hidden = self.dataArr.count > 1?NO:YES;
        }
        
    };

}

- (void)setDetailModel:(MHStoreGoodsDetailModel *)detailModel{
    _detailModel = detailModel;
    @weakify(self);
    [self.headView sd_setImageWithURL:[NSURL URLWithString:_detailModel.img_cover.s_url?:_detailModel.img_cover.url] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            @strongify(self);
            self.headView.image = image;
            CGSize size = image.size;
            if(size.width && size.height){
                self.detailModel.img_cover.width = [NSString stringWithFormat:@"%f",size.width];
                self.detailModel.img_cover.height = [NSString stringWithFormat:@"%f",size.height];
                self.picHeight = MScreenW * size.height / size.width;
                CGRect frame = self.headView.frame;
                frame.size = CGSizeMake(MScreenW, MScreenW * size.height / size.width);
                self.weakTableView.contentInset = UIEdgeInsetsMake(MScreenW * size.height / size.width, 0, 0, 0);
            }
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dataArr.count?58:0;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return self.dataArr.count?58:0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.dataArr.count == 0){
        return nil;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 58)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.clipsToBounds = YES;
    UIFont *afont;
    if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
        afont = [UIFont systemFontOfSize:MScale * 18 weight:UIFontWeightMedium];
    }else{
        afont = [UIFont systemFontOfSize:MScale * 18];
    }
    UILabel *label = [LCommonModel quickCreateLabelWithFont:afont textColor:MRGBColor(50, 64, 87)];
    label.numberOfLines = 0;
    label.text = self.detailModel.coupon_name;
    UIView *lineView = [UIView new];
    lineView.backgroundColor = MRGBColor(211, 220, 230);
    [headView addSubview:label];
    [headView addSubview:lineView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(24);
        make.right.lessThanOrEqualTo(headView.mas_right).offset(-24);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(23);
        make.right.equalTo(headView.mas_right).offset(-24);
        make.bottom.equalTo(headView.mas_bottom);
        make.height.equalTo(@.5);
    }];
    return headView;
}

//设置拉伸
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    CGRect frame = self.headView.frame;
    frame.origin.y = y;
    frame.size.height = -y;
    self.headView.frame = frame;
    if(y <= -(self.picHeight + 145)){
        [scrollView setContentOffset:CGPointMake(0, -(self.picHeight + 150))];
    }
}

#pragma mark - lazyload
- (UIImageView *)headView{
    if(!_headView){
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MScreenW)];
        _headView.clipsToBounds = YES;
        _headView.backgroundColor = MColorBackgroud;
        _headView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [[tap.rac_gestureSignal throttle:.2] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            if(self.detailModel && self.coverPicClikBlock){
                self.coverPicClikBlock();
            }
        }];
        _headView.userInteractionEnabled = YES;
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}

@end
