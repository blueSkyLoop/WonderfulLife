//
//  MHVoServerPageDelegateModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseCollectionDelegateModel.h"
#import "MHVolServerPageHeadView.h"

@interface MHVoServerPageDelegateModel : MHBaseCollectionDelegateModel

@property (nonatomic, strong) MHVolServerPageHeadView *headView;

@property (nonatomic,strong)NSArray *approving_projects;

@property (nonatomic,copy)void(^scorllLimitHeightBlock)(BOOL isLimit);

@property (nonatomic,assign)BOOL isCacelNotice;

@end
