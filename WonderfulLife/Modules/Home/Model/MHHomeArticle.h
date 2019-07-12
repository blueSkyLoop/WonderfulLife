//
//  MHHomeArticle.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHomeArticle : NSObject

/*
 article_id	Long	1	文章id
 img_url	String	http://xxx	图片路径
 subject	String	志愿者666	标题
 post_time	String	2017-06-06	发布时间
 content	String	2017-06-06	内容，列表页面此项为空
 */

@property (strong,nonatomic) NSNumber *article_id;
@property (copy,nonatomic) NSString *img_url;
@property (copy,nonatomic) NSString *subject;
@property (copy,nonatomic) NSString *post_time;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *article_url;
@end
