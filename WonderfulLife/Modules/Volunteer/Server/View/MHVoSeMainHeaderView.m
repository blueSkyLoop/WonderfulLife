//
//  MHVoSeMainHeaderView.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeMainHeaderView.h"

#import "UIImage+Color.h"
#import "MHMacros.h"
#import "UIView+MHFrame.h"
#import "MHWeakStrongDefine.h"

#import "YYText.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT)
#define NAV_HEIGHT 44
#define IMAGE_HEIGHT 245

@interface MHVoSeMainHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgimv;
@property (nonatomic, strong) UIScrollView *scrView;
@property (nonatomic, strong) UIView *notify_view;
@end

@implementation MHVoSeMainHeaderView
{
    NSTimer *_timer;
}

+ (instancetype)voseMainHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MHVoSeMainHeaderView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgimv.image = [UIImage mh_gradientImageWithBounds:_bgimv.bounds direction:UIImageGradientDirectionDown colors:@[MColorMainGradientStart, MColorMainGradientEnd]];
    
    _myCardBtn.layer.cornerRadius = 15;
    _myCardBtn.layer.masksToBounds = YES;
    _myCardBtn.layer.borderWidth = 1;
    _myCardBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)stopTimer {
    [_timer invalidate];
}
- (void)setApprovingProjects:(NSArray *)approvingProjects {
    if (!approvingProjects.count) return;
    
    _approvingProjects = approvingProjects;
    
    UIView *notify_view = [[UIView alloc] initWithFrame:CGRectMake(0, 245, MScreenW, 44)];
    notify_view.backgroundColor = [UIColor whiteColor];
    [self addSubview:notify_view];
    
    self.scrView.frame = CGRectMake(44, 0, MScreenW - 88, 44);
    self.scrView.userInteractionEnabled = YES;
    for (int i = 0; i < _approvingProjects.count; i ++) {
        YYLabel *lab = [self constructApplyStateViewTitle:_approvingProjects[i]];
        lab.frame = CGRectMake(0, self.scrView.frame.size.height * i, self.scrView.frame.size.width, self.scrView.frame.size.height);
        [self.scrView addSubview:lab];
    }
    [self.scrView setContentSize:CGSizeMake(self.scrView.frame.size.width, self.scrView.frame.size.height * _approvingProjects.count)];
    [notify_view addSubview:self.scrView];
    
    if (_approvingProjects.count == 2) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(shoot) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    UIImageView *notify_icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vo_home_notify"]];
    notify_icon.frame = CGRectMake(16, 14, 16, 16);
    [notify_view addSubview:notify_icon];

    UIButton *stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //      Beelin 给 Lo 埋下的bug。 2017.8.9 ，04：45分爬起来改!!!
    stateBtn.frame = CGRectMake(MScreenW - 28, 16, 12, 12);
    [stateBtn setImage:[UIImage imageNamed:@"vo_home_notify_cancel"] forState:UIControlStateNormal];
    [stateBtn addTarget:self action:@selector(cancelNotifyAction) forControlEvents:UIControlEventTouchUpInside];
    [notify_view addSubview:stateBtn];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MColorSeparator;
    line.frame = CGRectMake(0, 43.3, MScreenW, 0.7);
    [notify_view addSubview:line];
    
    self.notify_view = notify_view;
}


- (YYLabel *)constructApplyStateViewTitle:(NSString *)title {

    NSString *notifyStr = [title stringByAppendingString:@"申请审核中"];
    NSMutableAttributedString *notify_contents = [[NSMutableAttributedString alloc] initWithString: notifyStr];
    NSRange range = [notifyStr rangeOfString:@"申请审核中"];
    notify_contents.yy_font = [UIFont systemFontOfSize:15];

    MHWeakify(self);
    [notify_contents yy_setTextHighlightRange:range color:MColorToRGB(0XFC2F39) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        MHStrongify(self);
        !self.reviewedPersonnelNotifyBlock?:self.reviewedPersonnelNotifyBlock();
    }];
    
    YYLabel *label = [[YYLabel alloc] init];
    label.attributedText = notify_contents;
    label.textAlignment = NSTextAlignmentLeft;
    label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    label.numberOfLines = 0;
    return label;
    
}

#pragma mark - Event
- (void)shoot {
    static NSInteger flag = 0;
    flag += 1;
    NSInteger x = flag % 2;
    [self.scrView setContentOffset:CGPointMake(0, self.scrView.frame.size.height * x) animated:YES];
}
- (void)cancelNotifyAction {
    self.notify_view.hidden = YES;
    !self.cancelNotifyBlock ?: self.cancelNotifyBlock();
}
- (IBAction)comeinMyScoreAction:(UIButton *)sender {
    !self.comeinMyScoreBlock ?: self.comeinMyScoreBlock();
}

- (UIScrollView *)scrView {
    if (!_scrView) {
        _scrView = [[UIScrollView alloc] init];
        _scrView.backgroundColor = [UIColor whiteColor];
        _scrView.showsHorizontalScrollIndicator = NO;
    }
    return _scrView;
}

- (void)changeColorWithDisplacement:(CGFloat)offsetY {
    CGFloat alpha = 1 - (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
    self.numBtn.alpha = alpha;
    self.loveScoreTitleLabel.alpha = alpha;
}
@end
