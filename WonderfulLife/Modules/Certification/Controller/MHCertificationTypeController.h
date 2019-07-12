//
//  MHCertificationTypeController.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

//MARK - BIN
@class MHStructRoomModel;

@interface MHCertificationTypeController : UIViewController
@property (copy,nonatomic) NSString *plotDescripe;

/** 认证方式，核对业主信息提示框的显示样式*/
@property (nonatomic, copy) NSString *dongdanfan;


@property (nonatomic,strong) MHStructRoomModel *room;
@end
