//
//  MHCommunityAnnouncementModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHCommunityAnnouncementModel : NSObject
@property (nonatomic,copy) NSString *subject;
@property (nonatomic,copy) NSString *img_url;
@property (nonatomic,strong) NSNumber *cover_type;
@property (nonatomic,copy) NSString *post_time;

@property (nonatomic,copy) NSString *article_url;
@property (nonatomic,copy) NSString *content;

@property (nonatomic,assign) float cellHeight;

@end
