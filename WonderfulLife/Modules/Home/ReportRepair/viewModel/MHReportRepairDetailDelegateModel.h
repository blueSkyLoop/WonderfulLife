//
//  MHReportRepairDetailDelegateModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseTableDelegateModel.h"

#import "MHReportRepairDetailModel.h"
#import "MHReportRepairPictureView.h"

@interface MHReportRepairDetailDelegateModel : MHBaseTableDelegateModel

@property (nonatomic,strong)MHReportRepairDetailModel *model;

@property (nonatomic,copy)void (^evaluateBlock)(void);

@property (nonatomic,copy)void(^pictreCollectionViewDidSelectBlock)(NSIndexPath *indexPath,MHReportRepairPictureModel *cellModel);

@end
