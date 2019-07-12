//
//  MHPlaceholderTextView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHPlaceholderTextView : UITextView

@property (nonatomic,strong)IBInspectable UIColor *placeholderColor;
@property (nonatomic,assign)IBInspectable CGFloat placeholderSize;
@property (nonatomic,copy)IBInspectable NSString *placeholder;

- (void)makePlaceholderHidden:(BOOL)isHidden;


@end
