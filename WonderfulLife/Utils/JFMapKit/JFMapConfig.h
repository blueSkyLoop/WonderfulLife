//
//  JFMapConfig.h
//  JFCommunityCenter
//
//  Created by hanl on 2017/5/3.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#ifndef JFMapConfig_h
#define JFMapConfig_h


static inline void jf_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


#endif /* JFMapConfig_h */
