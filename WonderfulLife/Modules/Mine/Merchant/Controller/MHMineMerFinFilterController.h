//
//  MHMineMerFinFilterController.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^FilterTimeBlock)(NSString *date_Begin,NSString *date_end);
@interface MHMineMerFinFilterController : UIViewController

@property (nonatomic,copy) FilterTimeBlock filterBlock;

@end
