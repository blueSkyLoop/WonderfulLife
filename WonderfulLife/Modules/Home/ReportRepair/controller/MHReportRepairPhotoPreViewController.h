//
//  MHReportRepairPhotoPreViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"

#import "MHReportRepairPhotoPreViewModel.h"

@interface MHReportRepairPhotoPreViewController : MHBaseViewController

/**
 *  数据源
 */
@property(nonatomic,strong)NSMutableArray <MHReportRepairPhotoPreViewModel *>* dataArr;

/**
 *  点击的图片下标
 */
@property(nonatomic,assign)NSInteger clickNum;


/**
 *  是否需要显示删除按钮
 */
@property(nonatomic,assign)BOOL showDeleteButton;

@property (nonatomic,copy)void(^previewDeleteBlock)(NSInteger removeIndex);

@end
