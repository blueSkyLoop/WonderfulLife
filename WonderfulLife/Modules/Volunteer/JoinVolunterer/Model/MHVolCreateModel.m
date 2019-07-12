//
//  MHVolCreateModel.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolCreateModel.h"
#import "YYModel.h"

@class MHVolAddress;
@implementation MHVolCreateModel
static MHVolCreateModel *volCreateModel;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        volCreateModel = [[[self class] alloc] init];
        volCreateModel.address = [[MHVolAddress alloc] init];
    });
    return volCreateModel;
}


- (void)remove {
    volCreateModel = nil ;
    onceToken = 0;// 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
}

+ (NSDictionary *)toDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

  
    
    MHVolCreateModel *model = [self sharedInstance];
    
    if (model.real_name) dic[@"real_name"] = model.real_name;
    if (model.sex) dic[@"sex"] = model.sex;
//    if (model.birthday) dic[@"birthday"] = model.birthday;
    if (model.phone) dic[@"phone"] = model.phone;
    if (model.address) dic[@"address"] = [model.address yy_modelToJSONString];
    if (model.tag_list) dic[@"tag_list"] = model.tag_list;
    if (model.support_list) dic[@"support_list"] = model.support_list;
    if (model.identity_card) dic[@"identity_card"] = model.identity_card;
    dic[@"img_width"] = model.img_width;
    dic[@"img_height"] = model.img_height;
    dic[@"file_id"] = model.file_id;
    dic[@"file_url"] = model.file_url;
// Lo 2017.07.17  接口删除此参数
    // Lo 2017.08.25 傻逼产品又说加回去了
  if (model.activity_list) dic[@"activity_list"] = model.activity_list;
    return [dic copy];
}


- (void)setActivity_list:(NSString *)activity_list {
    _activity_list = activity_list ;
    // 2017.08.26  Lo 又要改回去需要中括号
//    _activity_list = [[activity_list stringByReplacingOccurrencesOfString:@"[" withString:@""]stringByReplacingOccurrencesOfString:@"]" withString:@""];
}

@end





@implementation MHVolAddress



@end
