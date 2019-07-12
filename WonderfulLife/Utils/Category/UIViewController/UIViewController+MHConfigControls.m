//
//  UIViewController+MHConfigControls.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+MHConfigControls.h"
#import <objc/runtime.h>
#import "MHMacros.h"
#import "UIView+NIM.h"


@implementation UIViewController (MHConfigControls)
- (void)setTableView:(UITableView *)tableView {
    objc_setAssociatedObject(self, @selector(tableView), tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableView *)tableView {
   return objc_getAssociatedObject(self, @selector(tableView));
}

- (void)setSegmentLineView:(UIView *)segmentLineView {
    objc_setAssociatedObject(self, @selector(segmentLineView), segmentLineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)segmentLineView {
    return objc_getAssociatedObject(self, @selector(segmentLineView));
}

- (void)setLineAlpha:(CGFloat)lineAlpha {
    self.segmentLineView.alpha = lineAlpha;
    objc_setAssociatedObject(self, @selector(lineAlpha), @(lineAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lineAlpha {
    return [objc_getAssociatedObject(self, @selector(lineAlpha)) floatValue];
}



- (void)mh_createTalbeView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)mh_createTalbeViewStyleGrouped {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)setTitleLab:(UILabel *)titleLab {
   objc_setAssociatedObject(self, @selector(titleLab), titleLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)titleLab {
    return  objc_getAssociatedObject(self, @selector(titleLab));
}

- (void)setHeaderView:(UIView *)headerView {
    objc_setAssociatedObject(self, @selector(headerView), headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)headerView {
    return  objc_getAssociatedObject(self, @selector(headerView));
}

- (void)setContainerView:(UIView *)containerView {
    objc_setAssociatedObject(self, @selector(containerView), containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)containerView {
    return  objc_getAssociatedObject(self, @selector(containerView));
}

- (void)mh_createTitleLabelWithTitle:(NSString *)title {
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.frame = CGRectMake(0, 64, MScreenW, 34);
    self.titleLab.text = title;
    self.titleLab.textColor = MColorTitle;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = MFont(34);
    [self.view addSubview:self.titleLab];
}

- (void)mh_initTitleAlignmentLeftLabelWithTitle:(NSString *)title {
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.frame = CGRectMake(24, 72, MScreenW - 48, 39);
    self.titleLab.textColor = MColorTitle;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont boldSystemFontOfSize:32];
    self.titleLab.numberOfLines = 0;
    self.titleLab.text = title;
    CGSize size = [self.titleLab sizeThatFits:CGSizeMake(self.titleLab.frame.size.width, MAXFLOAT)];
    self.titleLab.frame = CGRectMake(self.titleLab.nim_left, self.titleLab.nim_top, self.titleLab.nim_width,size.height);
    
    self.headerView = [UIView new];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.frame = CGRectMake(0, 0, MScreenW, self.titleLab.nim_bottom + 8);
    
    self.segmentLineView = [UIView new];
    self.segmentLineView.frame = CGRectMake(0, self.headerView.nim_bottom,self.headerView.nim_width, 0.5);
    self.segmentLineView.backgroundColor = MColorSeparator;
    
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.titleLab];
    [self.headerView addSubview:self.segmentLineView];

    self.tableView.nim_top = self.headerView.nim_bottom;
    
}

- (void)mh_addSubViewOnHeaderView:(UIView *)subView {
    self.containerView = subView;
    
    self.containerView.nim_top = self.titleLab.nim_bottom + 16;
    self.headerView.nim_height = self.containerView.nim_bottom + 16;
    self.tableView.nim_top = self.headerView.nim_bottom;
    self.segmentLineView.nim_bottom = self.headerView.nim_bottom;
    
    [self.headerView addSubview:subView];
    
}

- (void)mh_scrollUpdateTitleLabelWithContainerView {
    
    CGFloat offsetY = self.tableView.contentOffset.y;
    
    if (offsetY >= 64){
        self.headerView.nim_top = 0;
        self.titleLab.nim_size = [self mh_titleFinalSize];
        self.titleLab.center   = [self mh_titleFinalCenter];
        self.titleLab.font     = [UIFont boldSystemFontOfSize:16];
    }
    if (offsetY <= 0){
        self.titleLab.nim_size = [self mh_titleOriginSize];
        self.titleLab.center   = [self mh_titleOriginCenter];
        self.titleLab.font     = [UIFont boldSystemFontOfSize:32];

    }else if (offsetY > 0 && offsetY< 64) {
        CGFloat headerTop = 64 - offsetY;
        CGFloat scale = 1 - headerTop/64.00;
        
        CGFloat centerX = [self mh_titleOriginCenter].x + ([self mh_titleFinalCenter].x - [self mh_titleOriginCenter].x)*scale;
        CGFloat centerY = [self mh_titleOriginCenter].y + ([self mh_titleFinalCenter].y - [self mh_titleOriginCenter].y)*scale;
        CGFloat width  = [self mh_titleOriginSize].width - ([self mh_titleOriginSize].width - [self mh_titleFinalSize].width)*scale;
        CGFloat height = [self mh_titleOriginSize].height - ([self mh_titleOriginSize].height - [self mh_titleFinalSize].height)*scale;
        self.titleLab.nim_size = CGSizeMake(width, height);
        self.titleLab.center = CGPointMake(centerX, centerY);
        UIFont *lblFont = [UIFont boldSystemFontOfSize:32-16*scale];
        self.titleLab.font = lblFont;
    }
    
    
    self.containerView.nim_top = self.titleLab.nim_bottom + 16;
    self.headerView.nim_height = self.containerView.nim_bottom + 16;
    self.segmentLineView.nim_bottom = self.headerView.nim_bottom;
    self.tableView.nim_top = self.headerView.nim_bottom;
}

- (void)mh_scrollUpdateTitleLabel {
    CGFloat offsetY = self.tableView.contentOffset.y;

    if (offsetY >= 64){
        self.headerView.nim_top = 0;
        self.titleLab.nim_size = [self mh_titleFinalSize];
        self.titleLab.center   = [self mh_titleFinalCenter];
        self.titleLab.font     = [UIFont boldSystemFontOfSize:16];
        self.segmentLineView.alpha = 1;
    }
    if (offsetY <= 0){
        self.titleLab.nim_size = [self mh_titleOriginSize];
        self.titleLab.center   = [self mh_titleOriginCenter];
        self.titleLab.font     = [UIFont boldSystemFontOfSize:32];
        self.segmentLineView.alpha = self.lineAlpha;

    }else if (offsetY > 0 && offsetY< 64) {
        CGFloat headerTop = 64 - offsetY;
        CGFloat scale = 1 - headerTop/64.00;

        CGFloat centerX = [self mh_titleOriginCenter].x + ([self mh_titleFinalCenter].x - [self mh_titleOriginCenter].x)*scale;
        CGFloat centerY = [self mh_titleOriginCenter].y + ([self mh_titleFinalCenter].y - [self mh_titleOriginCenter].y)*scale;
        CGFloat width  = [self mh_titleOriginSize].width - ([self mh_titleOriginSize].width - [self mh_titleFinalSize].width)*scale;
        CGFloat height = [self mh_titleOriginSize].height - ([self mh_titleOriginSize].height - [self mh_titleFinalSize].height)*scale;
        self.titleLab.nim_size = CGSizeMake(width, height);
        self.titleLab.center = CGPointMake(centerX, centerY);
        UIFont *lblFont = [UIFont boldSystemFontOfSize:32-16*scale];
        self.titleLab.font = lblFont;
        

    }
    
    self.headerView.nim_height = self.titleLab.nim_bottom + 8;
    self.segmentLineView.nim_bottom = self.headerView.nim_bottom;
    self.tableView.nim_top = self.headerView.nim_bottom;
}

- (CGPoint)mh_titleOriginCenter {

    CGFloat size_width = [self titleContentWidthWithfontSize:32];
    if (size_width > MScreenW - 48) {
        size_width = MScreenW - 48;
    }
    
    CGSize size = [self.titleLab sizeThatFits:CGSizeMake(self.titleLab.frame.size.width, MAXFLOAT)];
    
    return CGPointMake(size_width/2+24, 64+size.height/2);
}

- (CGPoint)mh_titleFinalCenter {
    
    return CGPointMake(MScreenW/2, 42);
}

- (CGSize)mh_titleOriginSize{
    
    CGFloat size_width = [self titleContentWidthWithfontSize:32];
    if (size_width > MScreenW - 48) {
        size_width = MScreenW - 48;
    }
    CGSize size = [self.titleLab sizeThatFits:CGSizeMake(self.titleLab.frame.size.width, MAXFLOAT)];

    return CGSizeMake(size_width, size.height);
}

- (CGSize)mh_titleFinalSize {
    CGFloat size_width = [self titleContentWidthWithfontSize:16];
    if (size_width > 160) {
        size_width = 160;
    }
    return CGSizeMake(size_width, 32);
}

- (CGFloat)titleContentWidthWithfontSize:(CGFloat)fontSize {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]};
    CGRect rect = [self.titleLab.text boundingRectWithSize:CGSizeMake(0, 90.5) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

@end
