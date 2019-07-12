//
//  MHStoShopDetailModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/6.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHOOSImageModel;

@interface MHStoShopDetailCategoryModel : NSObject
@property (nonatomic,strong) NSNumber *merchant_category_id;
@property (nonatomic,copy) NSString *merchant_category_name;

@end

@interface MHStoShopDetailModel : NSObject
@property (nonatomic,strong) MHStoShopDetailCategoryModel *mallMerchantCategoryDto;

@property (nonatomic,assign) double average_spend;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,strong) NSArray <MHOOSImageModel *>*img_cover;
@property (nonatomic,strong) NSArray <MHOOSImageModel *>*img_details;
@property (nonatomic,copy) NSString *merchant_addr;
@property (nonatomic,copy) NSString *merchant_contact;
@property (nonatomic,copy) NSString *merchant_summary;
@property (nonatomic,copy) NSString *merchant_intro;
@property (nonatomic,copy) NSString *merchant_name;
/** 联系电话 */
@property (nonatomic,copy) NSString *merchant_phone;
/** 商家账号 */
@property (nonatomic,copy) NSString *mobile_phone;
//@property (nonatomic,copy) NSString *opening_time_begin;
//@property (nonatomic,copy) NSString *opening_time_end;
@property (nonatomic,copy) NSString *opening_time_begin_end;
@property (nonatomic,assign) NSInteger star;

/** 商家概览 */
@property (nonatomic,strong) NSNumber *merchant_id;




@end
