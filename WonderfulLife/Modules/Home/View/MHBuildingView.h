//
//  MHBuildingView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/29.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHBuildingView : UIView
+ (instancetype)buildingView;

+ (instancetype)buildingViewWithIcon:(NSString *)icon
                               title:(NSString *)title
                             content:(NSString *)content;
@end
