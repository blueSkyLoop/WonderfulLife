//
//  MHSanboxPath.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#ifndef MHSanboxPath_h
#define MHSanboxPath_h

/** Document路径 */
#define PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


/** 个人信息路径 */
#define PathUserInfo [PathDocument stringByAppendingPathComponent:@"MHUserInfo"]


/** 缓存小区信息路径 */
#define PathArea [PathDocument stringByAppendingPathComponent:@"MHAreaManager"]


#endif /* MHSanboxPath_h */
