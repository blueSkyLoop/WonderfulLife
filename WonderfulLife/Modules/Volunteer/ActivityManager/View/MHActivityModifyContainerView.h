//
//  MHActivityModifyContainerView.h
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHActivityModifyContainerView : UIView
+ (instancetype)initSection0View:(NSString*)title;
+ (instancetype)initSection1View;
+ (instancetype)initSectionPublishView:(NSString*)title block:(void (^)(void))block;
@end
