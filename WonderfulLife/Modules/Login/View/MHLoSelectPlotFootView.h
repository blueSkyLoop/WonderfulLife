//
//  MHLoSelectPlotFootView.h
//  WonderfulLife
//
//  Created by zz on 01/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressUserDefinedBlock)();
@interface MHLoSelectPlotFootView : UIView
@property (nonatomic, copy) AddressUserDefinedBlock block;

//默认无数据视图
+ (instancetype)initDefaultFootView;
//带自定义地址按钮视图
+ (instancetype)initFootViewWithUserDefineButton:(AddressUserDefinedBlock)block;

//带体验小区按钮视图 （搜索）
+ (instancetype)initFootViewWithExperienceCommunityButton:(AddressUserDefinedBlock)block;
//带体验小区按钮视图 （无数据）
+ (instancetype)initFootViewWithNoDatasExperienceCommunityButton:(AddressUserDefinedBlock)block;
@end
