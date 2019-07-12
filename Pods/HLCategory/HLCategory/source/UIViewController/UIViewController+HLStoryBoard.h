//
//  UIViewController+HLStoryBoard.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HLStoryBoard)

// 加载 storyBoard 的 instantiate controller
+ (instancetype)hl_instantiateControllerWithStoryBoardName:(NSString *)sbName;

// 根据 identifier 加载 storyBoard 中的 controller
+ (instancetype)hl_controllerWithIdentifier:(NSString *)identifier
                          storyBoardName:(NSString *)sbName;
@end
