//
//  MHVolCreateModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage,MHVolAddress;

@interface MHVolCreateModel : NSObject

///Tip - 请使用单例
+ (instancetype)sharedInstance;


+ (NSDictionary *)toDictionary;

- (void)remove; 

#pragma mark -

/// 申请志愿者表单内容 --- 添加属性后请加注释

@property (strong,nonatomic) UIImage *image; // 用户头像 UIImage格式


/************ 请求体 所需数据 ************/
@property (nonatomic,copy) NSString *file_id;
@property (nonatomic,copy) NSString *file_url;
@property (nonatomic,strong) NSNumber *img_width;
@property (nonatomic,strong) NSNumber *img_height;
@property (copy,nonatomic) NSString *real_name; // 姓名
@property (strong,nonatomic) NSNumber *sex; // 性别
//@property (copy,nonatomic) NSString *birthday; // 生日
@property (copy,nonatomic) NSString *phone; // 电话
@property (strong,nonatomic) MHVolAddress *address; // 地址
@property (copy,nonatomic) NSString *tag_list; // 兴趣ID集合(json)
@property (copy,nonatomic) NSString* support_list; // 关注服务ID集合(json)

@property (copy,nonatomic) NSString *activity_list; // 服务项目ID集合(json去掉括号)

@property (nonatomic, copy)   NSString * identity_card; // 身份证号码

@end


@interface MHVolAddress : NSObject

@property (nonatomic, copy)   NSString * city;

@property (nonatomic, copy)   NSString * community;

@property (nonatomic, copy)   NSString * room;

@end

