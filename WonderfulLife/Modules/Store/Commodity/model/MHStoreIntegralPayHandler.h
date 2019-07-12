//
//  MHStoreIntegralPayHandler.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHStorePayViewModel.h"

#import "MHStoreGoodPayModel.h"
static NSInteger const not_volunteerCode = 2001;//不是志愿者
static NSInteger const not_setPassword = 2002;//没有设置支付密码
static NSInteger const integralsLess = 2003;//积分不足
static NSInteger const passwordError = 2004;//支付密码错误

@interface MHStoreIntegralPayHandler : NSObject

@property (nonatomic,strong,readonly)MHStorePayViewModel *viewModel;

//支付完成回调
@property (nonatomic,copy)void(^payCompleBlock)(BOOL success,id data);

////把控制器的viewDidAppear转移到这里来实现,因为有可能要移除密码框
-(void)pay_viewDidAppear:(BOOL)animated;

#pragma mark - 隐藏密码输入界面
- (void)hiddenPasswordAlert;

#pragma mark - 弹起密码输入界面
- (void)showPayPasswordAlert;


//调起支付，内部会做支付处理校验，支付成功，失败，跳转，外部只关心支付成功与否和结果，成功和失败跳转，外部不需要处理，内部已做好
- (void)startPayWithPayModel:(MHStoreGoodPayModel *)payModel payInfor:(id)payInfor controller:(UIViewController *)controller comple:(void(^)(BOOL success,id data))comple;

- (void)handlePayResultWithCode:(NSInteger)code arg:(NSDictionary *)dict controller:(UIViewController *)controller payModel:(MHStoreGoodPayModel *)payModel;
//处理支付结果,暂时没有用到
- (void)handlePayResultWithCode:(NSInteger)code arg:(NSDictionary *)dict controller:(UIViewController *)controller;

//处理积分抵扣
- (void)handleIntergralDeductionWithModel:(MHStoreGoodPayModel *)payModel payInfor:(id)payInfor controller:(UIViewController *)controller comple:(void(^)(BOOL success,id data))comple;



@end
