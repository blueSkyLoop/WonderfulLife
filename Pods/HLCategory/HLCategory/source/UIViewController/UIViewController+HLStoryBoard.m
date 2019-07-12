//
//  UIViewController+HLStoryBoard.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+HLStoryBoard.h"

@implementation UIViewController (HLStoryBoard)
+ (instancetype)hl_instantiateControllerWithStoryBoardName:(NSString *)sbName {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]];
     return sb.instantiateInitialViewController;
}
+ (instancetype)hl_controllerWithIdentifier:(NSString *)identifier
                             storyBoardName:(NSString *)sbName {
   UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]];
    return [sb instantiateViewControllerWithIdentifier:identifier];
}
@end
