//
//  MHVolActivityModifyContentController.h
//  WonderfulLife
//
//  Created by zz on 14/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MHVolActivityModifyContentBlock)(NSString *text);

@interface MHVolActivityModifyContentController : UIViewController
@property (copy,nonatomic) NSString *contentTitle;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) MHVolActivityModifyContentBlock block;

@end
