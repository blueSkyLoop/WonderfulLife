//
//  MHVoCultivateContentModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVoCultivateContentModel : NSObject
@property (nonatomic,strong) NSNumber *article_id;
@property (nonatomic,copy) NSString *subject;
@property (nonatomic,copy) NSString *img_url;

/** 文章地址*/
@property (nonatomic, copy)   NSString * article_url;
@end
