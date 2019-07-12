//
//  MHVoMyCardModel.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/8/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerMyCardModel.h"
#import "MHVolunteerDataHandler.h"
#import "MHHUDManager.h"
#import "MHUserInfoManager.h"
#import "NSDate+ChangeString.h"

#import "YYModel.h"

@implementation MHVolSerMyCardModel

@end

@interface MHVolSerMyCardViewModel()
@property (nonatomic, copy)NSArray *itemNames;
@end

@implementation MHVolSerMyCardViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray array];
        
        self.itemNames = @[@"照片",@"姓名",@"身份证",@"性别",@"生日",@"电话",@"住址",@"爱好特长",@"需要帮助"];
        
        self.dataSource = [NSMutableArray array];
        @weakify(self);
        [self.itemNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            MHVolSerMyCardModel *model = [[MHVolSerMyCardModel alloc]init];
            model.title = obj;
            model.content = @"";
            if (idx == 0) {
                model.type = MHVoMyCardCellWithHeaderImg;
            }else if (idx == 1 ||idx == 2){
                model.type = MHVoMyCardCellWithoutArrow;
            }else {
                model.type = MHVoMyCardCellNormal;
            }
            [self.dataSource addObject:model];
        }];

        
        [self handleCommand];
    }
    return self;
}

- (void)handleCommand {
    
    @weakify(self);
    self.userInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.isFreshed = NO;
            [MHVolunteerDataHandler getVoSerMyCard:[MHUserInfoManager sharedManager].volunteer_id request:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                self.isFreshed = YES;
                MHUserInfoManager *user = [MHUserInfoManager sharedManager];
                user.volUserInfo = [MHVolUserInfo yy_modelWithDictionary:data];
                [user saveUserInfoData];
                [self updateDataSource:user.volUserInfo];
                [subscriber sendNext:@""];
                [subscriber sendCompleted];
            } failure:^(NSString *errmsg) {
                self.isFreshed = NO;
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
                [subscriber sendError:nil];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
    
    
    self.modifyPhoneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            self.isFreshed = NO;
            [MHVolunteerDataHandler postVoSerModifyThePhoneOfMyCard:[MHUserInfoManager sharedManager].volunteer_id Phone:input request:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                self.isFreshed = YES;
                MHVolSerMyCardModel *model = [self.dataSource objectAtIndex:5];
                model.content = data[@"phone"];
                
                [subscriber sendNext:@""];
                [subscriber sendCompleted];
            } failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
                [subscriber sendError:nil];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
    
    
    self.modifyBirthdayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            self.isFreshed = NO;
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date =[dateFormat dateFromString:input];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *destDateString = [dateFormatter stringFromDate:date];
            
            [MHVolunteerDataHandler postVoSerModifyTheBirthdayOfMyCard:[MHUserInfoManager sharedManager].volunteer_id Birthday:destDateString request:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                self.isFreshed = YES;
                MHVolSerMyCardModel *obj = self.dataSource[4];
                obj.content = destDateString;
                [subscriber sendNext:@""];
                [subscriber sendCompleted];
            } failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
                [subscriber sendError:nil];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
    
    
    self.modifySexCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            self.isFreshed = NO;
            [MHVolunteerDataHandler postVoSerModifyTheSexOfMyCard:[MHUserInfoManager sharedManager].volunteer_id Sex:[input integerValue] request:^(NSDictionary *data) {
                self.isFreshed = YES;
                [MHHUDManager dismiss];
                NSString *sexStr = [input integerValue] == 1 ?@"男":@"女";
                MHVolSerMyCardModel *obj = self.dataSource[3];
                obj.content = sexStr;
                [MHHUDManager dismiss];
                [subscriber sendNext:@""];
                [subscriber sendCompleted];
            } failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
                [subscriber sendError:nil];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];

    self.modifyAddressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            self.isFreshed = NO;

            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:input options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

            [MHVolunteerDataHandler postVoSerModifyTheAddressOfMyCard:[MHUserInfoManager sharedManager].volunteer_id Address:jsonString request:^(NSDictionary *data) {
                self.isFreshed = YES;
                [MHHUDManager dismiss];
                MHVolSerMyCardModel *obj = self.dataSource[6];
                obj.content = [NSString stringWithFormat:@"%@%@%@",input[@"city"],input[@"community"],input[@"room"]];
                [subscriber sendNext:@""];
                [subscriber sendCompleted];
            } failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
                [subscriber sendError:nil];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
    
    self.modifyHeaderImgCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            self.isFreshed = NO;
            
            NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:input];
            [m_dic setValue:[MHUserInfoManager sharedManager].volunteer_id forKey:@"volunteer_id"];
            
            [MHVolunteerDataHandler postVoSerModifyThePhotoOfMyCard:m_dic request:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                [self.userInfoCommand execute:nil];
                [subscriber sendNext:@""];
                [subscriber sendCompleted];
            } failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
                [subscriber sendError:nil];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
    
    self.modifyIdentityCardCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            self.isFreshed = NO;
            
            [MHVolunteerDataHandler postVoSerModifyTheIdentifyOfMyCard:[MHUserInfoManager sharedManager].volunteer_id Identity:input request:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                [self.userInfoCommand execute:nil];
                [subscriber sendNext:@""];
                [subscriber sendCompleted];
            } failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
                [subscriber sendError:nil];
                [subscriber sendCompleted];

            }];
            
            return nil;
        }];
    }];

}


- (void)updateDataSource:(MHVolUserInfo *)volUserInfo {
  
    NSArray *birthday = [volUserInfo.birthday componentsSeparatedByString:@" "];

    NSString *realname = volUserInfo.real_name?:@"";
    NSString *city = volUserInfo.address.city?:@"";
    NSString *community = volUserInfo.address.community?:@"";
    NSString *room = volUserInfo.address.room?:@"";
    NSString *id_card = volUserInfo.identity_card?:@"";
    NSString *birthdayFormat = volUserInfo.birthday?birthday[0]:@"";
    NSString *sex = volUserInfo.sex?:@"";
    NSString *phone = volUserInfo.phone?:@"";
    NSString *tag = volUserInfo.tag?:@"";
    NSString *support = volUserInfo.support?:@"";
    NSString *address = [NSString stringWithFormat:@"%@%@%@",city,community,room];
    
    NSArray *itemContents = @[@"",
                              realname,
                              id_card,
                              sex,
                              birthdayFormat,
                              phone,
                              address,
                              tag,
                              support];
    
    [self.dataSource enumerateObjectsUsingBlock:^(MHVolSerMyCardModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.content = itemContents[idx];
        if (idx == 2&&id_card.length == 0) {
            obj.type = MHVoMyCardCellNormal;
        }else if(idx == 2&&id_card.length != 0) {
            obj.type = MHVoMyCardCellWithoutArrow;
        }
    }];
}

@end
