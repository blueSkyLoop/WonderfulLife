//
//  MHVolServerPageHeaderReusableView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolServerPageHeaderReusableView.h"
#import "MHMacros.h"
#import "UIImage+Color.h"
#import "Masonry.h"
#import "YYText.h"
#import "ReactiveObjC.h"

@interface MHVolServerPageHeaderReusableView()

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSInteger noticeAllPage;

@end

@implementation MHVolServerPageHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)loadApprovingProjects:(NSArray *)approvingProjects{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.noticeAllPage = approvingProjects.count;
    UIView *tempView;
    for(int i=0;i<approvingProjects.count;i++){
        UIView *notify_view = [self createapprovingProjectViewWithTitle:approvingProjects[i]];
        [self.scrollView addSubview:notify_view];
        [notify_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tempView?tempView.mas_bottom:_scrollView.mas_top);
            make.left.equalTo(_scrollView.mas_left);
            make.right.equalTo(_scrollView.mas_right);
            make.height.equalTo(@44);
            if(i == approvingProjects.count - 1){
                make.bottom.equalTo(_scrollView.mas_bottom);
            }
        }];
        tempView = notify_view;
    }
    
    if(approvingProjects.count > 1){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.timer){
                [self.timer invalidate];
                self.timer = nil;
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(shoot) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        });
    }
    
}

- (UIView *)createapprovingProjectViewWithTitle:(NSString *)title{
    UIView *notify_view = [UIView new];
    UIImageView *notify_icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vo_home_notify"]];
    [notify_view addSubview:notify_icon];
    
    UIButton *stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stateBtn setImage:[UIImage imageNamed:@"vo_home_notify_cancel"] forState:UIControlStateNormal];
    @weakify(self);
    [[[stateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.3] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.timer){
            [self.timer invalidate];
            self.timer = nil;
        }
        !self.cancelNotifyBlock ?: self.cancelNotifyBlock();
    }];
    [notify_view addSubview:stateBtn];
    
    
    YYLabel *label = [self constructApplyStateViewTitle:title];
    [notify_view addSubview:label];
    
    [notify_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(notify_view.mas_left).offset(16);
        make.centerY.equalTo(notify_view.mas_centerY);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(notify_icon.mas_right).offset(12);
        make.centerY.equalTo(notify_view.mas_centerY);
        make.width.equalTo(@(MScreenW - 16 - 16 - 12 - 16 - 12 - 10));
    }];
    [stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(label.mas_right).offset(10).priorityLow();
        make.right.equalTo(notify_view.mas_right).offset(-16).priorityHigh();
        make.centerY.equalTo(notify_view.mas_centerY);
        make.width.equalTo(@12);
        make.height.equalTo(@44);
    }];

    
    [stateBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    return notify_view;
}

- (YYLabel *)constructApplyStateViewTitle:(NSString *)title {
    
    NSString *notifyStr = [title stringByAppendingString:@"申请审核中"];
    NSMutableAttributedString *notify_contents = [[NSMutableAttributedString alloc] initWithString: notifyStr];
    NSRange range = [notifyStr rangeOfString:@"申请审核中"];
    notify_contents.yy_font = [UIFont systemFontOfSize:15*MScale];
    
    @weakify(self);
    [notify_contents yy_setTextHighlightRange:range color:MColorToRGB(0XFC2F39) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        !self.reviewedPersonnelNotifyBlock?:self.reviewedPersonnelNotifyBlock();
    }];
    
    YYLabel *label = [[YYLabel alloc] init];
    label.attributedText = notify_contents;
    label.textAlignment = NSTextAlignmentLeft;
    label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    label.numberOfLines = 0;
    return label;
    
}

- (void)shoot {
    CGFloat offsety = self.scrollView.contentOffset.y;
    NSInteger currentPage = floorf(offsety / CGRectGetHeight(self.scrollView.frame));
    if(++currentPage >= self.noticeAllPage){
        currentPage = 0;
    }
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height * currentPage) animated:YES];
    
}


@end
