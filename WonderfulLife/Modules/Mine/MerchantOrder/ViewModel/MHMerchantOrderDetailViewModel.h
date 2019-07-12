//
//  MHMerchantOrderDetailViewModel.h
//  WonderfulLife
//
//  Created by zz on 30/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "MHMerchantOrderDetailModel.h"

typedef NS_ENUM(NSUInteger, MHMerchantOrderDetailType) {
    MHMerchantOrderDetailTypeUnPaid = 0,   //待付款
    MHMerchantOrderDetailTypeUnUsed,       //待使用
    MHMerchantOrderDetailTypeUnReviews,    //待评价
    MHMerchantOrderDetailTypeFinished,     //已完成
    MHMerchantOrderDetailTypeRefunding,    //退款中
    MHMerchantOrderDetailTypeRefunded,     //已退款
    MHMerchantOrderDetailTypeRefusedAndUnUsed,     //已拒绝退款，待使用
    MHMerchantOrderDetailTypeExpried,      //已过期
};

@interface MHMerchantOrderDetailViewModel : NSObject

@property (nonatomic,assign)MHMerchantOrderDetailType type;

@property (nonatomic,copy) NSArray *nibCellNames;
@property (nonatomic,copy) NSArray *classCellNames;
@property (nonatomic,copy) NSArray *classHeaderFooterViewNames;

@property (nonatomic,assign) BOOL isMerchant; //是否是商家

//评价商品
@property (nonatomic,assign) NSInteger goodsLevels;
@property (nonatomic,assign) NSInteger merchantLevels;
@property (nonatomic,  copy) NSString *reviewsContent;

@property (nonatomic,strong) RACCommand *pullDetailCommand;     //买家 - 拉取列表数据
@property (nonatomic,strong) RACCommand *postReviewsCommand;    //商家 - 拉取退款列表数据
@property (nonatomic,strong) RACCommand *pullMerchantDetailCommand;    //商家 - 拉取订单详情接口
@property (nonatomic,strong) RACCommand *postComfirmRefundCommand;    //商家 - 同意退款接口

@property (strong, nonatomic) MHMerchantOrderDetailModel *model;


- (void)bindRegisterCells;
- (void)bindRegisterMerchantDetailCells;

- (void)submitGoodsReviewsInfo;

@end
