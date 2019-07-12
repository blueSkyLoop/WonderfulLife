//
//  MHIntegralsPayAlertView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHThemeButton.h"
typedef NS_ENUM(NSInteger ,IntegralsPayFailuretType) {
    IntegralsPayFailuret_less = 1,
    IntegralsPayFailuret_notVolunteer
};

@interface MHIntegralsPayAlertView : UIView

@property (nonatomic,strong)UIImageView *suggestImageView;
@property (nonatomic,strong)UILabel *suggestLabel;
@property (nonatomic,strong)MHThemeButton *button;
@property (nonatomic,strong)UIButton *knowButton;

- (id)initWithPaySuggestType:(IntegralsPayFailuretType)type comple:(void(^)(NSInteger buttonIndex))comple;

- (void)show;

- (void)hiddenAlert;

@end
