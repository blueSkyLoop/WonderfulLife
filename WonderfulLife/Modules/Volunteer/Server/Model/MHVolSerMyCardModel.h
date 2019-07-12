//
//  MHVoMyCardModel.h
//  WonderfulLife
//
//  Created by ikrulala on 2017/8/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

typedef NS_ENUM(NSUInteger, MHVoMyCardCellType) {
    MHVoMyCardCellWithHeaderImg,
    MHVoMyCardCellWithoutArrow,
    MHVoMyCardCellNormal,
};

@interface MHVolSerMyCardModel : NSObject
/// item标题
@property (nonatomic, copy) NSString *title;
/// item内容
@property (nonatomic, copy) NSString *content;
/// item类型
@property (nonatomic,assign) MHVoMyCardCellType type;
@end

@interface MHVolSerMyCardViewModel : NSObject
@property(nonatomic,strong) RACCommand *userInfoCommand;
@property(nonatomic,strong) RACCommand *modifyPhoneCommand;
@property(nonatomic,strong) RACCommand *modifyBirthdayCommand;
@property(nonatomic,strong) RACCommand *modifySexCommand;
@property(nonatomic,strong) RACCommand *modifyAddressCommand;
@property(nonatomic,strong) RACCommand *modifyHeaderImgCommand;
@property(nonatomic,strong) RACCommand *modifyIdentityCardCommand;


@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,assign) BOOL isFreshed;
@end
