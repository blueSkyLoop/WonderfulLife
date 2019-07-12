//
//  NSObject+AutoProperty.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSObject+AutoProperty.h"


@implementation NSObject (AutoProperty)

/**
 *  自动生成属性列表
 *
 *  @param dict JSON字典/模型字典
 */
+(void)printPropertyWithDict:(NSDictionary *)dict allPropertyCode:(NSMutableString *)allPropertyCode{
    if(!allPropertyCode){
        allPropertyCode = [[NSMutableString alloc]init];
    }
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *oneProperty = [[NSString alloc]init];
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
            NSArray *arr = (NSArray *)obj;
            if(arr.count){
                NSString *begin = [NSString stringWithFormat:@"\n*****************%@数组里面的内容字段开始**********************\n",key];
                [allPropertyCode appendString:begin];
                [self printPropertyWithDict:[arr firstObject] allPropertyCode:allPropertyCode];
                NSString *end = [NSString stringWithFormat:@"\n*****************%@数组里面的内容字段结束**********************\n",key];
                [allPropertyCode appendString:end];
        
            }
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayI")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
            NSArray *arr = (NSArray *)obj;
            if(arr.count){
                NSString *begin = [NSString stringWithFormat:@"\n*****************%@数组里面的内容字段开始**********************\n",key];
                [allPropertyCode appendString:begin];
                [self printPropertyWithDict:[arr firstObject] allPropertyCode:allPropertyCode];
                NSString *end = [NSString stringWithFormat:@"\n*****************%@数组里面的内容字段结束**********************\n",key];
                [allPropertyCode appendString:end];
            }
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
            NSDictionary *adict = (NSDictionary *)obj;
            if(adict.count){
                NSString *begin = [NSString stringWithFormat:@"\n*****************%@字典里面的内容字段开始**********************\n",key];
                [allPropertyCode appendString:begin];
                [self printPropertyWithDict:adict allPropertyCode:allPropertyCode];
                NSString *end = [NSString stringWithFormat:@"\n*****************%@字典里面的内容字段结束**********************\n",key];
                [allPropertyCode appendString:end];
            }
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSDictionaryI")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
            NSDictionary *adict = (NSDictionary *)obj;
            if(adict.count){
               
                NSString *begin = [NSString stringWithFormat:@"\n*****************%@字典里面的内容字段开始**********************\n",key];
                [allPropertyCode appendString:begin];
                [self printPropertyWithDict:adict allPropertyCode:allPropertyCode];
                NSString *end = [NSString stringWithFormat:@"\n*****************%@字典里面的内容字段结束**********************\n",key];
                [allPropertyCode appendString:end];
            }
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;)",key];
        }
        [allPropertyCode appendFormat:@"\n%@\n",oneProperty];
    }];
    NSLog(@"%@",allPropertyCode);
    allPropertyCode  = nil;
}


@end
