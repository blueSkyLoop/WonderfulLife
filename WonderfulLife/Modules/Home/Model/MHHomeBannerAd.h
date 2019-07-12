//
//  MHHomeBannerAd.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHomeBannerAd : NSObject

/*
 ad_id	Long	1	广告id
 img_url	String	http://xxx	图片路径
 link_type	String	0|1	0表示内链，1表示外链
 link_url	String	http://www.baidu.com	广告链接地址
 */

/// <#summary#>
@property (strong,nonatomic) NSNumber *ad_id;
/// <#summary#>
@property (copy,nonatomic) NSString *img_url;
/// <#summary#>
@property (assign,nonatomic) BOOL link_type;
/// <#summary#>
@property (copy,nonatomic) NSString *link_url;
@end
