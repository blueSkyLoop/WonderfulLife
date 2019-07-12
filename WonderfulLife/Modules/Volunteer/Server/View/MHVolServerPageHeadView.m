//
//  MHVolServerPageHeadView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolServerPageHeadView.h"
#import "LCommonModel.h"
#import "MHMacros.h"
#import "UIImage+Color.h"
#import "Masonry.h"
#import "YYText.h"
#import "ReactiveObjC.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT)
#define NAV_HEIGHT 44
#define IMAGE_HEIGHT 245

@interface MHVolServerPageHeadView()


@end

@implementation MHVolServerPageHeadView

- (void)dealloc{
    
}

- (id)init{
    self = [super init];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
         [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self addSubview:self.imageView];
    [self addSubview:self.scoreLabel];
    [self addSubview:self.scoreDescripLabel];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.mas_top).offset(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_scoreDescripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scoreLabel.mas_bottom).offset(16);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-40);
    }];
    
}


- (void)loadScroeInforWithModel:(MHVolunteerServiceMainModel *)model{
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2lf",model.all_integral.floatValue];
    
}


- (void)changeColorWithDisplacement:(CGFloat)offsetY {
    CGFloat alpha = 1 - (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
    self.scoreLabel.alpha = alpha;
    self.scoreDescripLabel.alpha = alpha;
}


#pragma mark - lazyload
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [UIImageView new];
        _imageView.image = [UIImage mh_gradientImageWithBounds:CGRectMake(0, 0, MScreenW, 245) direction:UIImageGradientDirectionDown colors:@[MColorMainGradientStart, MColorMainGradientEnd]];
    }
    return _imageView;
}
- (UILabel *)scoreLabel{
    if(!_scoreLabel){
        _scoreLabel = [LCommonModel quickCreateLabelWithFont:[UIFont boldSystemFontOfSize:64] textColor:[UIColor whiteColor]];
        _scoreLabel.text = @" ";
        _scoreLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [[[tapGes rac_gestureSignal] throttle:.3] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            if(self.comeinMyScoreBlock){
                self.comeinMyScoreBlock();
            }
        }];
        [_scoreLabel addGestureRecognizer:tapGes];
        
    }
    return _scoreLabel;
}
- (UILabel *)scoreDescripLabel{
    if(!_scoreDescripLabel){
        UIFont *afont;
        if([[UIDevice currentDevice] systemVersion].floatValue >= 8.2){
            afont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        }else{
            afont = [UIFont systemFontOfSize:18];
        }
        _scoreDescripLabel = [LCommonModel quickCreateLabelWithFont:afont textColor:[UIColor whiteColor]];
        _scoreDescripLabel.text = @"爱心积分";
    }
    return _scoreDescripLabel;
}

@end
