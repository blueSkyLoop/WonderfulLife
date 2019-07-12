//
//  MHHobbyButton.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHHobbyButtonTypeHobby,
    MHHobbyButtonTypeStoreHome,
} MHHobbyButtonType;

@interface MHHobbyButton : UIButton

@property (nonatomic,assign) BOOL custom;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,assign) MHHobbyButtonType type;

- (instancetype)initWithType:(MHHobbyButtonType)type;
@end
