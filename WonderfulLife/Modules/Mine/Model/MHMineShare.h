//
//  MHMineShare.h
//  WonderfulLife_dev
//
//  Created by 梁斌文 on 2017/10/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MHMineShare : NSObject

@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *img_url;

/** 本地图片 */
@property (strong,nonatomic)  UIImage *logoImage;


+ (MHMineShare *)mineShare ;


+ (MHMineShare *)mineShareSina ;

+ (MHMineShare *)mineShareWechatTimeLine ;
@end
