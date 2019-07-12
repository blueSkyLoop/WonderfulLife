//
//  MHVolServiceTimeHeaderView.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolCheckTimeHeaderView.h"
#import <Masonry.h>
#import "MHMacros.h"
@interface MHVolCheckTimeHeaderView()
/**
 *
 */
@property (weak,nonatomic) UILabel *titleLB;

/**
 *
 */
@property (weak,nonatomic) UILabel *tipLB;
@end


@implementation MHVolCheckTimeHeaderView

+ (MHVolCheckTimeHeaderView *)volCheckTimeHeaderViewWithType:(MHVolCheckTimeType)type hours:(CGFloat)hours{
    
    MHVolCheckTimeHeaderView *view = [MHVolCheckTimeHeaderView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, MScreenW, 402);
    
    NSString *title ;
    CGFloat view_h ;
    if (type == MHVolCheckTimeNormal) {
        title = @"服务时长";
        view_h = 402 ;
    }else {
        title = @"我的考勤";
        view_h = 434 ;
    }
    view.frame = CGRectMake(0, 0, MScreenW, view_h);
    
    UILabel *titleLB = [UILabel new];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.text = title;
    titleLB.textColor = MColorTitle ;
    titleLB.font = [UIFont fontWithName:@"PingFangSC-Light" size:34.0];
    view.titleLB = titleLB ;
    [view addSubview:titleLB];
    
    CGFloat magir = 24;
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:48]);
        make.top.equalTo(view).offset(64);
        make.centerX.equalTo(view);
        make.left.equalTo(view).offset(magir);
        make.right.equalTo(view).offset(-magir);
    }];

    [view initTipLB:type];
    
    [view initCountImage:type hours:hours];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, MScreenW, 1)];
    line.backgroundColor = MColorSeparator;
    [view addSubview:line];
    
    return view;
}


- (void)initTipLB:(MHVolCheckTimeType)type{
    
    if (type == MHVolCheckTimeChecking) {
        UILabel *tipLB = [UILabel new];
        tipLB.textAlignment = NSTextAlignmentCenter;
        tipLB.text = @"累计服务时长";
        tipLB.textColor = MColorToRGB(0x99A9BF) ;
        tipLB.font = MFontTitle;
        self.tipLB = tipLB ;
        [self addSubview:tipLB];
        CGFloat magir = 24;
        [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo([NSNumber numberWithFloat:24]);
            make.top.equalTo(self.titleLB.mas_bottom).offset(8);
            make.centerX.equalTo(self.titleLB);
            make.left.equalTo(self).offset(magir);
            make.right.equalTo(self).offset(-magir);
        }];
    }
}



-(void)initCountImage:(MHVolCheckTimeType)type hours:(CGFloat)hours{
    CGFloat ivSize = 218 ;
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vo_checktime"]];
    [self addSubview:iv];
    
    UILabel *referenceLB ; // 参照物
    
    if (type == MHVolCheckTimeNormal) {
        referenceLB = self.titleLB ;
    }else{
        referenceLB = self.tipLB ;
    }
    
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo([NSNumber numberWithFloat:ivSize]);
        make.top.equalTo(referenceLB.mas_bottom).offset(32);
        make.centerX.equalTo(referenceLB);
    }];
    
    //  时间数量
    UILabel *hoursCountLB = [UILabel new];
    hoursCountLB.textAlignment = NSTextAlignmentCenter;
    hoursCountLB.text = [NSString stringWithFormat:@"%.1f",hours];
    hoursCountLB.textColor = [UIColor whiteColor] ;
    hoursCountLB.font = [UIFont systemFontOfSize:56.0];
    [iv addSubview:hoursCountLB];
    
    CGFloat hoursLBmagir = 10;
    [hoursCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:66]);
        make.top.equalTo(iv).offset(60);
        make.centerX.equalTo(iv);
        make.left.equalTo(iv).offset(hoursLBmagir);
        make.right.equalTo(iv).offset(-hoursLBmagir);
    }];
    
    
    UILabel *hoursStrLB = [UILabel new];
    hoursStrLB.textAlignment = NSTextAlignmentCenter;
    hoursStrLB.text = @"小时";
    hoursStrLB.textColor = [UIColor whiteColor] ;
    hoursStrLB.font = [UIFont systemFontOfSize:20.0];
    [iv addSubview:hoursStrLB];
    
    [hoursStrLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:28]);
        make.width.equalTo([NSNumber numberWithFloat:50]);
        make.top.equalTo(hoursCountLB.mas_bottom).offset(4);
        make.centerX.equalTo(hoursCountLB);
    }];
    
}

@end
