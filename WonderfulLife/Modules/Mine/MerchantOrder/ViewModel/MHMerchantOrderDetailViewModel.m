//
//  MHMerchantOrderDetailViewModel.m
//  WonderfulLife
//
//  Created by zz on 30/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailViewModel.h"
#import "MHMerChantOrderRequestHandler.h"

#import "MHHUDManager.h"
#import "MHAliyunManager.h"
#import "YYModel.h"

@interface MHMerchantOrderDetailViewModel ()
@property (nonatomic,copy) NSString *picturesJson;
@end

@implementation MHMerchantOrderDetailViewModel


- (void)bindRegisterCells {
    
    //[待付款]、[待使用]、[待评价]、[退款中]、[已完成]、[已退款]、[已过期]、 [退款失败，待使用]
    switch (self.type) {
        case MHMerchantOrderDetailTypeUnPaid:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusNormalCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeUnUsed:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusNormalCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeUnReviews:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusNormalCell"],
                                  @[@"MHMerchantOrderDetailCell",
                                    @"MHMerchantOrderDetailStarRatingCell",
                                    @"MHMerchantOrderDetailReviewsContentCell",
                                    @"MHMerchantOrderDetailReviewsPicturesCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeRefunding:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusRefundingCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeFinished:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusNormalCell"],
                                  @[@"MHMerchantOrderDetailReviewsCell",
                                    @"MHMerchantOrderDetailPicturesCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeRefunded:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusRefusedAndUnuseCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeExpried:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusNormalCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeRefusedAndUnUsed:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusRefusedAndUnuseCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
    }

}

- (void)bindRegisterMerchantDetailCells {
    switch (self.type) {
            
        case MHMerchantOrderDetailTypeUnPaid:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusVendorCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeUnUsed:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusVendorCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeUnReviews:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusVendorCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeFinished:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusVendorCell"],
                                  @[@"MHMerchantOrderDetailReviewsCell",
                                    @"MHMerchantOrderDetailPicturesCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeExpried:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusVendorCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;


        case MHMerchantOrderDetailTypeRefunding:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusRefundingCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeRefusedAndUnUsed:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusRefusedCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
        case MHMerchantOrderDetailTypeRefunded:
            self.nibCellNames = @[@[@"MHMerchantOrderDetailStatusRefundCell"],
                                  @[@"MHMerchantOrderDetailCell"]];
            self.classHeaderFooterViewNames = @[@"MHMerchantOrderDetailGoodsView"];
            break;
    }
}

- (NSMutableDictionary *)reviewsPostParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_no"] = self.model.order_no;
    params[@"grade_to_merchant"] = @(self.merchantLevels);
    params[@"grade_to_goods"] = @(self.goodsLevels);
    params[@"comment"] = self.reviewsContent;
    params[@"img_details"] = self.picturesJson;
    return params;
}


- (void)submitGoodsReviewsInfo {
    [MHHUDManager show];
//    if (self.model.selectedImages) {
//        [self.reportNewCommand execute:nil];
//        return;
//    }
    @weakify(self);
    [[MHAliyunManager sharedManager]uploadImageToAliyunWithArrayImage:self.model.selectedImages success:^(NSArray<MHOOSImageModel *> *imageModels) {
        @strongify(self)
        NSMutableArray *imgs = [NSMutableArray array];
        [imageModels enumerateObjectsUsingBlock:^(MHOOSImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"file_id"] = obj.file_id;
            dic[@"file_url"] = obj.file_url;
            dic[@"img_height"] = obj.img_height;
            dic[@"img_width"] = obj.img_width;
            [imgs addObject:dic];
        }];
        self.picturesJson = [imgs yy_modelToJSONString];
        [self.postReviewsCommand execute:[self reviewsPostParams]];
    } failed:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
    
}


#pragma mark - Getter
- (RACCommand *)pullDetailCommand {
    if (!_pullDetailCommand) {
        _pullDetailCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHMerChantOrderRequestHandler pullOrderDetailSignal:input];
        }];
    }
    return _pullDetailCommand;
}

- (RACCommand *)postReviewsCommand {
    if (!_postReviewsCommand) {
        _postReviewsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHMerChantOrderRequestHandler postGoodsOrderComment:input];
        }];
    }
    return _postReviewsCommand;
}

- (RACCommand *)pullMerchantDetailCommand {
    if (!_pullMerchantDetailCommand) {
        _pullMerchantDetailCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [MHMerChantOrderRequestHandler pullMerchantOrderDetailSignal:input];
        }];
    }
    return _pullMerchantDetailCommand;
}

- (RACCommand *)postComfirmRefundCommand {
    if (!_postComfirmRefundCommand) {
        @weakify(self)
        _postComfirmRefundCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [MHMerChantOrderRequestHandler comfirmRefundOrder:input];
        }];
    }
    return _postComfirmRefundCommand;
}

@end
