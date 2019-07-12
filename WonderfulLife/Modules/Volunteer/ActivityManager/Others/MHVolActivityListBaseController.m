//
//  MHVolActivityListBaseController.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityListBaseController.h"
#import "MHMacros.h"
#import "UIView+NIM.h"

@interface MHVolActivityListBaseController ()

@end

@implementation MHVolActivityListBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)mh_createTalbeView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}


- (void)mh_initTitleAlignmentLeftLabelWithTitle:(NSString *)title {
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.frame = CGRectMake(24, 72, MScreenW - 48, 39);
    self.titleLab.textColor = MColorTitle;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont boldSystemFontOfSize:32];
    self.titleLab.numberOfLines = 0;
    self.titleLab.text = title;
    self.titleLab.adjustsFontSizeToFitWidth = YES;
    
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

- (CGPoint)mh_titleOriginCenter {
    
    CGFloat size_width = [self titleContentWidthWithfontSize:32];
    if (size_width > MScreenW - 48) {
        size_width = MScreenW - 48;
    }
    
    return CGPointMake(size_width/2+24, 90.5);
}

- (CGPoint)mh_titleFinalCenter {
    
    return CGPointMake(MScreenW/2, 42);
}

- (CGSize)mh_titleOriginSize{
    
    CGFloat size_width = [self titleContentWidthWithfontSize:32];
    if (size_width > MScreenW - 48) {
        size_width = MScreenW - 48;
    }
    return CGSizeMake(size_width, 45);
}

- (CGSize)mh_titleFinalSize {
    CGFloat size_width = [self titleContentWidthWithfontSize:16];
    if (size_width > 100) {
        size_width = 100;
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
