//
//  MHVoSeMonStepperButtonView.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MHVoSeMonStepperButtonViewType) {
    MHVoSeMonStepperButtonViewDay,
    MHVoSeMonStepperButtonViewMonth
};
@interface MHVoSeMonStepperButtonView : UIView
@property (nonatomic, strong, readonly) NSString *date;
@property (nonatomic, copy) void(^clickLastBlock)(NSInteger year, NSInteger month);
@property (nonatomic, copy) void(^clickNextBlock)(NSInteger year, NSInteger month);

+ (instancetype)voSeMonStepperButtonViewWithType:(MHVoSeMonStepperButtonViewType)type;
@end
