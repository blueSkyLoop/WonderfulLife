//
//  MHFunctionalModulesModel.h
//  WonderfulLife
//
//  Created by zz on 24/11/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHomeFunctionalModulesModel : NSObject
//功能名称
@property (nonatomic,  copy) NSString *function_name;
//功能代码
@property (nonatomic,  copy) NSString *function_code_ios;
//功能图标url
@property (nonatomic,  copy) NSString *function_icon_url;
//功能是否建设中，0：否，1：是
@property (nonatomic,strong) NSNumber *is_under_construction;

@end
