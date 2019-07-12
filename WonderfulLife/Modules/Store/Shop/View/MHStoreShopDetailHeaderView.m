//
//  MHStoreShopDetailHeaderView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/26.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreShopDetailHeaderView.h"

#import "MHStoShopDetailModel.h"

#import "PYPhotosView.h"
#import "MHAliyunManager.h"
#import "MHMacros.h"
#import "Masonry.h"

@interface MHStoreShopDetailHeaderView ()
@property (weak, nonatomic) IBOutlet PYPhotosView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet PYPhotosView *photosView;
@property (weak, nonatomic) IBOutlet UIView *starContainer;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *adminLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel2;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ownerViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *ownerViews2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *judgementTop;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *topMargins;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarksTop;

@end

@implementation MHStoreShopDetailHeaderView

+ (instancetype)headerView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24*MScale);
    }];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    //需求说去掉打电话,用此方法，不会产生按压下沉的效果
    self.phoneButton.userInteractionEnabled = NO;
}

#pragma mark - setter
- (void)setModel:(MHStoShopDetailModel *)model{
    _model = model;
    [self setupPhotoView];
    [self setupPhotosView];
    [self.starContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.highlighted = idx < model.star;
    }];
    self.addressLabel.text = model.merchant_addr;
    [self.phoneButton setTitle:model.merchant_phone forState:UIControlStateNormal];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",model.average_spend];
    self.timeLabel.text = model.opening_time_begin_end;
    if (model.merchant_intro) {
        self.remarksLabel.text = model.merchant_intro;
    }else{
        self.remarksTop.constant = 0;
    }
    self.nameLabel.text = model.merchant_name;
    
    if (model.distance.length) {
        self.distanceLabel.text = model.distance;
        
    }else{
        [self.distanceLabel removeFromSuperview];
        [self.distanceLabel2 removeFromSuperview];
        self.timeBottom.constant = 29;
    }
    
    if (model.mobile_phone) {//是商家自己查看详情
        self.accountLabel.text = model.mobile_phone;
        self.adminLabel.text = model.merchant_contact;
        self.categoryLabel.text = model.mallMerchantCategoryDto.merchant_category_name;
    }else{
        [self.ownerViews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.ownerViews = nil;
        self.judgementTop.constant = 22;
        [self.topMargins enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.constant += 2;
        }];
        self.topMargins = nil;
    }
    
    if (self.count == 0) {
        for (UIView *view in self.ownerViews2) {
            [view removeFromSuperview];
        }
        self.ownerViews2 =  nil;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - 按钮点击

- (IBAction)buttonDidClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneCall)]) {
        [self.delegate phoneCall];
    }
}
#pragma mark - delegate

#pragma mark - private
- (void)setUrlsWithArray:(NSArray *)array PhotosView:(PYPhotosView *)photosView{
    NSMutableArray *thumbnailUrls = [NSMutableArray array];
    NSMutableArray *originalUrls = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(MHOOSImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [thumbnailUrls addObject:obj.s_url];
        [originalUrls addObject:obj.url];
        
    }];
    
    photosView.thumbnailUrls = thumbnailUrls;
    photosView.originalUrls = originalUrls;
    
}

- (void)setupPhotosView{
    _photosView.autoLayoutWithWeChatSytle = NO;
    _photosView.photoMargin = 19*MScale;
    _photosView.photoWidth = 96*MScale;
    _photosView.photoHeight = _photosView.photoWidth;
    
    [self setUrlsWithArray:_model.img_details PhotosView:_photosView];
    [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((_model.img_details.count+2)/3 *((96+19)*MScale));
        if (_model.img_details.count == 1) {
            make.width.mas_equalTo(96*MScale);
        }else{
            make.width.mas_equalTo(327*MScale);
        }
    }];
}

- (void)setupPhotoView{
    _photoView.photoWidth = MScreenW;
    _photoView.photoHeight = _photosView.photoWidth;
    [self setUrlsWithArray:_model.img_cover PhotosView:self.photoView];
}

#pragma mark - lazy

@end







