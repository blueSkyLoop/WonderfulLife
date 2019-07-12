//
//  MHMineMerFinHeaderView.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHMineMerFinModel;
@interface MHMineMerFinHeaderView : UIView

@property (nonatomic, strong) MHMineMerFinModel  *model;

+ (instancetype)mineMerfinHeaderViewWithFrame:(CGRect)frame ;

@end
