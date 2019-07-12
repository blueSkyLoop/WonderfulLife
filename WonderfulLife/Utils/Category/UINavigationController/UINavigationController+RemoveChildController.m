//
//  UINavigationController+RemoveChildController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UINavigationController+RemoveChildController.h"

@implementation UINavigationController (RemoveChildController)

/**
 *  @param range   要移除的索引NSMakeRange(索引, 长度)。例：导航控制器有6个子控制器：0，1，2，3，4，5，传参NSMakeRange(3, 2)，就抽调3，4两个控制器，新的控制器数组就是0，1，2，5。如此这般从5这个topViewController就可以直接pop到2；
 */
- (void)mh_removeChildViewControllersInRange:(NSRange)range{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    
    [viewControllers removeObjectsInRange:range];
    self.viewControllers = [NSArray arrayWithArray:viewControllers];
}
@end
