//
//  XXNavigationControllerManager.h
//  BaseFramework
//
//  Created by Mantis-man on 16/1/16.
//  Copyright © 2016年 Mantis-man. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHNavigationControllerManagerProtocol <NSObject>

@optional
- (BOOL)bb_ShouldBack;
@end

@interface MHNavigationControllerManager : UINavigationController
- (void)navigationBarWhite;
- (void)navigationBarTranslucent;
@end
