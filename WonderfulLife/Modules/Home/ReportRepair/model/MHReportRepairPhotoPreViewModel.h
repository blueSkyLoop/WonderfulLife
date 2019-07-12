//
//  MHReportRepairPhotoPreViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MHReportRepairPhotoPreViewModel : NSObject

@property (nonatomic,copy)NSString *bigPicUrl;

@property (nonatomic,copy)NSString *bigPicName;

@property (nonatomic,strong)UIImage *bigImage;

// 1 url的形式，即bigPicUrl有值   2 本地图片名字的形式，即bigPicName有值  3 直接以图片的形式 ，即bigImage有值
@property (nonatomic,assign)NSInteger type;

@property (nonatomic,assign)BOOL isSelected;

@end
