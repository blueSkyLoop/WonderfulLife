//
//  LPasswordSuggestAlert.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHThemeButton.h"

@interface LPasswordSuggestAlert : UIView

@property (nonatomic,strong)UIImageView *suggestImageView;
@property (nonatomic,strong)UILabel *suggestLabel;
@property (nonatomic,strong)MHThemeButton *button;

- (id)initWithSuggestComple:(void(^)(void))comple;

- (void)show;

@end
