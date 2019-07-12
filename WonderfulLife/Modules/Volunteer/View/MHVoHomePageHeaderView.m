//
//  MHVoHomePageHeaderView.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoHomePageHeaderView.h"
#import "UIImage+Color.h"
#import "MHMacros.h"

@interface MHVoHomePageHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerbgv;
@property (weak, nonatomic) IBOutlet UILabel *numlab;
@property (weak, nonatomic) IBOutlet UIButton *introlbtn;

@end

@implementation MHVoHomePageHeaderView

+ (instancetype)voHomePageHeaderView {
   return [[NSBundle mainBundle] loadNibNamed:@"MHVoHomePageHeaderView" owner:nil options:nil][0];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerbgv.image = [UIImage mh_gradientImageWithBounds:self.headerbgv.bounds direction:UIImageGradientDirectionDown colors:@[MColorMainGradientStart, MColorMainGradientEnd]];
    
    self.introlbtn.layer.masksToBounds = YES;
    self.introlbtn.layer.cornerRadius = 15;
    self.introlbtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.introlbtn.layer.borderWidth = 1;
}


- (IBAction)clickVolunteerIntrolAction:(UIButton *)sender {
    !self.clickPushVolunteerIntrolBlock ? : self.clickPushVolunteerIntrolBlock();
}
- (IBAction)clickVolunteerServeAction:(UIButton *)sender {
    !self.clickPushServerBlock ?: self.clickPushServerBlock();
}

- (IBAction)clickVolunteerCultivateAction:(UIButton *)sender {
    !self.clickPushCultivateBlock ?: self.clickPushCultivateBlock();
}

#pragma mark - Setter
- (void)setHeadcount:(NSString *)headcount {
    _headcount = headcount;
    self.numlab.text = [NSString stringWithFormat:@"%@", _headcount?:@""];
}
@end
