//
//  MHMineMerFinListController.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHMineMerFinListController : UIViewController
@property (nonatomic, strong) NSNumber  *merchant_id;

// 格式： yyyy-MM-dd
@property (nonatomic, copy)   NSString * date_begin;

@property (nonatomic, copy)   NSString * date_end;

@end
