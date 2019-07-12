//
//  MHStoreGoodsOrderPayDetailView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"
#import "MHThemeButton.h"

@interface MHStoreGoodsOrderPayDetailView : MHBaseView
@property (weak, nonatomic) IBOutlet UIView *scoreBgView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;

@property (weak, nonatomic) IBOutlet MHThemeButton *payBtn;

@end
