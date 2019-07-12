//
//  MHStoreHomeHeaderView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/24.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreHomeHeaderView.h"
#import "MHHobbyButton.h"

#import "MHStoreHomeModel.h"

#import <SDCycleScrollView.h>
#import "UIButton+WebCache.h"
#import "UIView+NIM.h"
#import "MHMacros.h"

@interface MHStoreHomeHeaderView ()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) SDCycleScrollView *scrollView;
@property (nonatomic,strong) UIView *grayView;
@end

@implementation MHStoreHomeHeaderView

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
        
        [self addSubview:self.scrollView];
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, 190);
        
        self.scrollView.delegate = self;
        self.scrollView.showPageControl = YES;
        self.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.scrollView.pageControlDotSize = CGSizeMake(6, 6);
        self.scrollView.currentPageDotColor = [UIColor whiteColor];
        self.scrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.4];
        self.scrollView.autoScrollTimeInterval = 4;
        
        
    }
    
    return self;
}

- (void)setModel:(MHStoreHomeModel *)model{
    _model = model;
    NSMutableArray *urls = [NSMutableArray array];
    for (MHStHoBannerAdModel *addModel in model.banner_list) {
        [urls addObject:addModel.img_cover];
    }
    self.scrollView.imageURLStringsGroup = urls.copy;
    
    CGFloat width = MScreenW/4;
    UIButton *__weak lastButton;
    NSInteger businessCount = model.business_buttons.count;
    NSInteger cacheCount = (self.subviews.count  > 2) ? (self.subviews.count - 2) : 0;
    
    if (cacheCount > businessCount) { //删除多余按钮
        NSInteger deleteCount = cacheCount - businessCount;
        for (NSInteger i = 0; i < deleteCount; i++) {
            [self.subviews[cacheCount] removeFromSuperview];
            cacheCount -= 1 ;
        }
    }
    
    for (NSInteger i = 0; i < cacheCount; i++) { // 使用缓存按钮
        MHHobbyButton *button = self.subviews[i + 1];
        MHStHoBusinessModel *businessModel = model.business_buttons[i];
        button.tag = i;
        button.frame =CGRectMake((i%4)*width, self.scrollView.nim_bottom + 16 + 85*(i/4), width, 85);
        [button sd_setImageWithURL:[NSURL URLWithString:businessModel.icon_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"StoreHomeBusiness"]];
        [button setTitle:businessModel.name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        lastButton = button;
    }
    
    for (NSInteger i = cacheCount; i < businessCount; i++) { //新增按钮
        MHStHoBusinessModel *businessModel = model.business_buttons[i];
        MHHobbyButton *button = [[MHHobbyButton alloc] initWithType:MHHobbyButtonTypeStoreHome];
        [self addSubview:button];
        button.tag = i;
        button.frame =CGRectMake((i%4)*width,self.scrollView.nim_bottom + 16 + 85*(i/4), width, 85);
        [button sd_setImageWithURL:[NSURL URLWithString:businessModel.icon_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"StoreHomeBusiness"]];
        [button setTitle:businessModel.name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        lastButton = button;
    }
    
    self.grayView.nim_top = lastButton.nim_bottom+16;
    self.nim_height = self.grayView.nim_bottom;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - 按钮点击

#pragma mark - delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(didClickAddAtIndex:)]) {
        [self.delegate didClickAddAtIndex:index];
    }
}

- (void)buttonDidClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:button.tag];
    }
}

#pragma mark - private
- (UIView *)grayView{
    if (_grayView == nil) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = MColorBackgroud;
        _grayView.frame = CGRectMake(0, 0, MScreenW, 10);
        [self addSubview:_grayView];
    }
    return _grayView;
}

#pragma mark - lazy

@end







