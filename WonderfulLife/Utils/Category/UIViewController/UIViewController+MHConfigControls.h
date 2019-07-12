//
//  UIViewController+MHConfigControls.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MHConfigControls) <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView  *headerView;
@property (nonatomic, strong) UIView  *containerView;
@property (nonatomic, strong) UIView  *segmentLineView;
/**
 因部分界面不需要分割线，故添加一个分割线的透明度，当滑到顶部的时候，分割线的alpha为1，显示。滑下来分割线alpha为0，隐藏
 */
@property (nonatomic, assign) CGFloat lineAlpha;

- (void)mh_createTalbeView;
- (void)mh_createTalbeViewStyleGrouped;

- (void)mh_createTitleLabelWithTitle:(NSString *)title;


/**
 标题居左

 @param title 标题题目
 */
- (void)mh_initTitleAlignmentLeftLabelWithTitle:(NSString *)title;

- (void)mh_addSubViewOnHeaderView:(UIView *)subView;
/**
 滑动调用该方法，更新标题位置(只有标题)
 */
- (void)mh_scrollUpdateTitleLabel;
/**
 滑动调用该方法，更新标题位置(带容器控件标题)
 */
- (void)mh_scrollUpdateTitleLabelWithContainerView;


@end
