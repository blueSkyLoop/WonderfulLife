//
//  MHVolActivityModifyAddressController.h
//  WonderfulLife
//
//  Created by zz on 14/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MHVolActivityModifyAddressBlock)(NSString *address);
@interface MHVolActivityModifyAddressController : UIViewController
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) MHVolActivityModifyAddressBlock block;
@end
