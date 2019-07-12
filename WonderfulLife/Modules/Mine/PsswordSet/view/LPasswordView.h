//
//  LPasswordView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPasswordView : UIView

@property (nonatomic,copy)NSString *inputStrig;

@property (nonatomic,copy)void (^passwordInputCompleBlock)(void);

@property (nonatomic,copy)void (^passwordChangeBlock)(void);

- (id)initWithInputNum:(NSInteger)num titleName:(NSString *)titleName;

//更新title
- (void)updataTitleNameWith:(NSString *)titleName;

- (void)clearInput;

- (void)makeFirstResponderIndex:(NSInteger)index;

@end
