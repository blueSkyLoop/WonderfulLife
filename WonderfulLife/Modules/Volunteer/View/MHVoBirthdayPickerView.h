//
//  MHVoBirthdayPickerView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHVoBirthdayPickerViewTypeNormal,
        MHVoBirthdayPickerViewTypeSetting,
    MHVoBirthdayPickerViewTypeAge,
} MHVoBirthdayPickerViewType;
@interface MHVoBirthdayPickerView : UIView
@property (nonatomic,copy) NSString *birthdayStr;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,copy) void (^confirmBlock)(NSString *);
@property (nonatomic,copy) void (^confirmAgeBlock)(NSString *,NSInteger);
@property (nonatomic,assign) MHVoBirthdayPickerViewType type;

- (void)show;

@end
