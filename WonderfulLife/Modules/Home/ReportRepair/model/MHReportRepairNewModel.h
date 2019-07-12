//
//  MHReportRepairNewModel.h
//  WonderfulLife
//
//  Created by zz on 17/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHReportRepairNewModel : NSObject
/**
 报修房间
 */
@property(nonatomic,copy) NSString  *room_json;
/**
 上传图片的json格式
 */
@property(nonatomic,copy) NSString  *imgs;
/**
 报修类型id
 */
@property(nonatomic,strong) NSNumber *repairment_category_id;
/**
 联系方式
 */
@property(nonatomic,  copy) NSString *contact_tel;
/**
 报修类容
 */
@property(nonatomic,  copy) NSString *repairment_cont;
/**
 联系人
 */
@property(nonatomic,  copy) NSString *contact_man;
@property(nonatomic,strong) NSNumber *community_id;
/**
 缓存的报修房间
 */
@property(nonatomic,copy) NSString  *cache_room_json;
/**
 0|1,1是户内
 */
@property(nonatomic,assign)BOOL is_indoor;

@property(nonatomic, strong)NSMutableArray *images;

+ (instancetype)share;
+ (void)clear;
@end


/**
 参数名称   是否必须    类型  默认值 描述
 room_json  false object {"city":"武汉","community":"人和天地","room":"A区A栋A单元101","struct_id":10086}     报修房间
 imgs       false array[object] [{"file_id":"id","file_url":"id","img_height":1,"img_width":1}]     上传图片的json格式
 repairment_category_id true long 12313L    报修类型id
 contact_tel    true string 13326875454     联系方式
 repairment_cont    true string 报修类容    报修类容
 token      true string        令牌
 contact_man true string 小明  联系人
 */
