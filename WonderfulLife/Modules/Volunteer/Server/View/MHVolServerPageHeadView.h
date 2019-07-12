//
//  MHVolServerPageHeadView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVolunteerServiceMainModel.h"

@interface MHVolServerPageHeadView : UIView

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *scoreLabel;
@property (nonatomic,strong)UILabel *scoreDescripLabel;


@property (nonatomic, copy) void(^comeinMyScoreBlock)();


- (void)loadScroeInforWithModel:(MHVolunteerServiceMainModel *)model;

- (void)changeColorWithDisplacement:(CGFloat)offsetY;

@end
