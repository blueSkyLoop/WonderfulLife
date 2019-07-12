//
//  MHVolActivityListBaseController.h
//  WonderfulLife
//
//  Created by ikrulala on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVolActivityListBaseController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView  *headerView;
@property (nonatomic, strong) UIView  *containerView;
@property (nonatomic, strong) UIView  *segmentLineView;
- (void)mh_initTitleAlignmentLeftLabelWithTitle:(NSString *)title;
- (void)mh_scrollUpdateTitleLabelWithContainerView;
- (void)mh_addSubViewOnHeaderView:(UIView *)subView;
- (void)mh_createTalbeView;
@end
