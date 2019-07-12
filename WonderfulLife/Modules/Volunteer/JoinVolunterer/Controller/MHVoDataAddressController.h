//
//  MHVoDataAddressController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVoAddressTextView.h"


@interface MHVoDataAddressController : UIViewController
@property (nonatomic,copy) void (^confirmBlock)(NSString *);
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *topTitle;
@property (nonatomic,assign) MHVoAddressTextViewType type;

@end
