//
//  MHReportRepairPhotoPreviewDelegateModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseCollectionDelegateModel.h"

@interface MHReportRepairPhotoPreviewDelegateModel : MHBaseCollectionDelegateModel

@property (nonatomic,assign)CGFloat margin;

@property (nonatomic,copy)void(^titleChangeBlcok)(NSString *atitle);

@property (nonatomic,copy)void(^previewDeleteBlock)(NSInteger removeIndex);

@property (nonatomic,copy)void(^navBarBlock)(void);

@property (nonatomic,copy)void(^emptyBlock)(void);

- (void)deleteCurrentItem;

@end
