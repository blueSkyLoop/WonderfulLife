//
//  UINavigationController+MHDirectPop.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UINavigationController+MHDirectPop.h"
#import "objc/runtime.h"

static char directClassNameKey;

@implementation UINavigationController (MHDirectPop)

- (NSMutableArray *)directClassArr{
    NSMutableArray *directArr = objc_getAssociatedObject(self, &directClassNameKey);
    if(!directArr){
        directArr = [NSMutableArray array];
        objc_setAssociatedObject(self, &directClassNameKey, directArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return directArr;
    
}

- (void)saveDirectViewControllerName:(NSString *)className{
    if(![self invaleClassName:className]) return;
    [[self directClassArr] addObject:className];
}
- (void)removeDirectViewControllerName:(NSString *)className{
    if(![self invaleClassName:className]) return;
    if([[self directClassArr] containsObject:className]){
        [[self directClassArr] removeObject:className];
    }
    
}
- (void)removeAllDirect{
    [[self directClassArr] removeAllObjects];
}
- (UIViewController *)findDirectViewController{
    NSString *findClassName = [[self directClassArr] lastObject];
    if(!findClassName) return nil;
    [self removeDirectViewControllerName:findClassName];
    UIViewController *findController;
    Class findClass = NSClassFromString(findClassName);
//    for(UIViewController *controller in self.viewControllers){
//        if([controller isKindOfClass:findClass]){
//            findController = controller;
//            break;
//        }
//    }
    //从最后面开始找
    NSInteger count = self.viewControllers.count;
    if(count){
        for(NSInteger i = count - 1;i>= 0;i--){
            UIViewController *controller = self.viewControllers[i];
            if([controller isKindOfClass:findClass]){
                findController = controller;
                break;
            }
        }
    }
    
    return findController;
}
- (void)directTopControllerPop{
    UIViewController *controller = [self findDirectViewController];
    if(controller){
        [self popToViewController:controller animated:YES];
    }else{
        [self popViewControllerAnimated:YES];
    }
}

- (BOOL)invaleClassName:(NSString *)className{
    if(!className) return NO;
    return [NSClassFromString(className) isSubclassOfClass:[UIViewController class]];
}
- (BOOL)needCheck{
    return [self directClassArr].count?YES:NO;
}
- (void)checkClassNameExsit:(NSArray *)allClassNames{
    NSMutableArray *muArr = [self directClassArr];
    NSMutableArray *removeArr = [NSMutableArray array];
    for(NSString *aname in muArr){
        if(![allClassNames containsObject:aname]){
            [removeArr addObject:aname];
        }
    }
    if(removeArr.count){
        [muArr removeObjectsInArray:removeArr];
    }
}
- (UIViewController *)findControllerWithControllerName:(NSString *)controllerName{
    if(!controllerName) return nil;
    UIViewController *findController;
    Class findClass = NSClassFromString(controllerName);
//    for(UIViewController *controller in self.viewControllers){
//        if([controller isKindOfClass:findClass]){
//            findController = controller;
//            break;
//        }
//    }
    //从最后面开始找
    NSInteger count = self.viewControllers.count;
    if(count){
        for(NSInteger i = count - 1;i>= 0;i--){
            UIViewController *controller = self.viewControllers[i];
            if([controller isKindOfClass:findClass]){
                findController = controller;
                break;
            }
        }
    }
    
    return findController;
}

- (UIViewController *)frontControllerWithControllerName:(NSString *)controllerName{
    UIViewController *controller = [self findControllerWithControllerName:controllerName];
    if(!controller){
        return nil;
    }
    NSInteger index = [self.viewControllers indexOfObject:controller];
    if(index == 0){
        return nil;
    }
    return [self.viewControllers objectAtIndex:index - 1];
}

@end
