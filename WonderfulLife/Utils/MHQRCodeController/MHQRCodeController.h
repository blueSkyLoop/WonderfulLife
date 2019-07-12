//
//  MHQRCodeController.h
//  WonderfulLife
//
//  Created by ikrulala on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MHQRCodeViewModel.h"

#import "MHStoreOrdersConsumptionView.h"


@class MHQRCodeController,MHMineMerchantPayModel;

@protocol MHQRCodeControllerDelegate <NSObject>
/**
 *  读取到结果时会调用下面的代理方法
 *
 *  @param reader 扫描二维码控制器
 *  @param result 扫描结果
 */
- (void)reader:(MHQRCodeController *)reader didScanResult:(id)result;
@end

@interface MHQRCodeController : UIViewController
@property (nonatomic, weak) id<MHQRCodeControllerDelegate> delegate;
@property (nonatomic, assign) MHQRCodeType codeType;

@property (nonatomic, strong) NSMutableDictionary  *parma;

@property (strong,nonatomic,readonly)MHQRCodeViewModel *viewModel;

@property (strong,nonatomic)MHStoreOrdersConsumptionView *orderDetailView;


/**
 *  设置扫描二维码完成后回调的block
 *
 *  @param completionBlock 完成block
 */
- (void)setCompletionWithBlock:(void (^) (id resultAsString))completionBlock;


- (instancetype)initWithParma:(NSMutableDictionary *)parma CodeType:(MHQRCodeType)type ;

- (void)startScan ;

- (void)stopScan ;


@end
