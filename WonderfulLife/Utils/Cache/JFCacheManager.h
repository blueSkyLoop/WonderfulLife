//
//  JFCacheManager.h
//  JFCommunityCenter
//
//  Created by hanl on 2016/11/14.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JFCacheManager : NSObject



/**
 * 展示缓存大小
 */

- (void)showCachesWithComplete:(void(^)(BOOL success,CGFloat cache))complete;



/**
 * 清除所有缓存
 */
- (void)clearCachesWithComplete:(void(^)(BOOL success,CGFloat cache))complete;
@end
