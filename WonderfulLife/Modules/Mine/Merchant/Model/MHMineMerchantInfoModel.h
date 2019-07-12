//
//  MHMineMerchantInfoModel.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  商家信息model  , 用于： 买家积分二维码、商家收款码、 商家主页

#import <Foundation/Foundation.h>

@interface MHMineMerchantInfoModel : NSObject

/** 商家ID*/
@property (nonatomic, strong) NSNumber  *merchant_id;

/** 二维码*/
@property (nonatomic, copy)   NSString * qr_code;

/** 条形码*/
@property (nonatomic, copy)   NSString * bar_code;

/** 商家名字*/
@property (nonatomic, copy)   NSString * name;

/** 积分*/
@property (nonatomic, copy)   NSString * score;

/** 小头像*/
@property (copy,nonatomic) NSString * user_s_img;

/** 大头像*/
@property (copy,nonatomic) NSString * user_img;

/** 商家地址*/
@property (nonatomic, copy)   NSString * merchant_address;

/** 商家分类*/
@property (nonatomic, copy)   NSString * merchant_category_name;

/** 商家电话号码*/
@property (nonatomic, copy)   NSString * customer_contact_tel;

/** 商家封面 小图片*/
@property (nonatomic, copy)   NSString * merchant_cover;

/** 商家封面 大图片*/
@property (nonatomic, copy)   NSString * merchant_cover_origin;


/** 绑定的商家列表*/
@property (nonatomic, strong) NSArray  <MHMineMerchantInfoModel *>* my_merchant_list;

///Tip - 请使用单例
+ (instancetype)sharedInstance;
/**
 清理单例数据
 */
+ (void)clear;
@end

