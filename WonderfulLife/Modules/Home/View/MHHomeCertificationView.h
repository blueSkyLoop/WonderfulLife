//
//  MHHomeCertificationView.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MHHomeCertificationAction)(void);

@interface MHHomeCertificationView : UIControl
+ (instancetype)awakeFromNibWithCaetificationAction:(MHHomeCertificationAction)action;
@end
