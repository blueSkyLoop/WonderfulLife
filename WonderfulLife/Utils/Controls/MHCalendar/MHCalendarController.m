//
//  MHCalendarController.m
//  calendarDemo
//
//  Created by zz on 05/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCalendarController.h"
#import "MHCalendarTimeController.h"
#import "MHCalendarScrollView.h"
#import "MHActivityActionView.h"

#import "MHMacros.h"
#import "NSDate+MHCalendar.h"
#import "UIViewController+HLNavigation.h"

#import <Masonry.h>
#import <ReactiveObjC.h>

@interface MHCalendarController ()
@property (weak, nonatomic) IBOutlet UILabel *calendarDateLab;
@property (weak, nonatomic) IBOutlet UILabel *chineseMonth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yearMonthTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet MHThemeButton *bottomButton;

@property (strong,nonatomic) MHCalendarScrollView *calendarView;

@property (strong,nonatomic) NSDate *didSelectedDate;
@property (strong,nonatomic) NSDate *didFormatInputDate;
@property (strong,nonatomic) NSDate *didFormatResetDate;
@end

@implementation MHCalendarController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars=YES;
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:MColorTitle forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.title = self.calendarTitle;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"vo_home_notify_cancel"] forState:UIControlStateNormal];
    [cancel sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(popLastControllerEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setTitle:@"重置" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirm sizeToFit];
    [confirm setTitleColor:MColorTitle forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(resetSelectedSender:) forControlEvents:UIControlEventTouchUpInside];

    
    ///处理5小屏手机显示问题
    CGFloat weekheight = 179;
    if (isIPhone5()) {
        weekheight = 155;
        self.calendarView.frame = CGRectMake(0, 240, MScreenW, 280);
        self.yearMonthTopConstraint.constant = 62;
    }

    UIView *weekHeaderView = [self setupWeekHeadViewWithFrame:CGRectMake(0.0, weekheight, MScreenW, 30)];
    [self.view addSubview:weekHeaderView];
    [self.view insertSubview:self.calendarView belowSubview:self.bottomView];
    
    [self handleInputData];

    [self drawObliqueLine];
    [self bindViewEvents];
    
    [self.calendarView refreshToCurrentMonth];
    
}



- (void)handleInputData {
    
    if (!_inputDate) {
        return;
    }
    
    if (_inputDateFormat) {
        self.didFormatInputDate = [NSDate dateFromStringDate:_inputDate format:_inputDateFormat];
        self.didFormatResetDate = [NSDate dateFromStringDate:_resetDate format:_inputDateFormat];
    }else {
        self.didFormatInputDate = [NSDate dateFromStringDate:_inputDate format:@"yyyy-MM-dd HH:mm"];
        self.didFormatResetDate = [NSDate dateFromStringDate:_resetDate format:@"yyyy-MM-dd HH:mm"];
    }
    
    self.didSelectedDate = self.didFormatInputDate;
    self.calendarView.inputDate = self.didFormatInputDate;
    self.calendarView.resetDate = self.didFormatResetDate;
}


#pragma mark - Action methods

- (void)popLastControllerEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextStepEvent:(id)sender {
    
    if (self.type == MHCalendarTypeOnlyDate) {
        if (self.block) {
            
            NSString *dateFormat = @"yyyy-MM-dd HH:mm";
            if (self.outputDateFormat) {
                dateFormat = self.outputDateFormat;
            }
            NSString *didSelectedBlockDate = [self.didSelectedDate stringFromDateFormat:dateFormat];
            self.block(didSelectedBlockDate);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    MHCalendarTimeController *controller = [MHCalendarTimeController new];
    controller.calendarTitle   = self.calendarTitle;
    controller.didSelectedWeek = self.calendarDateLab.text;
    controller.didSelectedDate = self.didSelectedDate;
    controller.inputTime       = self.didFormatInputDate;
    controller.resetDate       = self.didFormatResetDate;
    controller.outputDateFormat= self.outputDateFormat;
    controller.block           = [self.block copy];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)resetSelectedSender:(id)sender {
    [self.calendarView refreshTodayToCurrentMonth];
}


#pragma mark - Private methods

- (void)bindViewEvents {
    
    @weakify(self);
    self.calendarView.willDisplayDateHandler = ^(NSString *date) {
        @strongify(self);
        self.chineseMonth.text = date;
    };
    
    self.calendarView.didSelectDayHandler = ^(NSDate *date) {
        @strongify(self);
        self.didSelectedDate = date;
        self.calendarDateLab.text = [date weekdayAndMonthFromDate];
    };
    
    if (self.type == MHCalendarTypeNormal) {
        [[self.calendarView.didSelectedSubject skip:0] subscribeNext:^(id  _Nullable x) {
            [self nextStepEvent:nil];
        }];
    }
    
    if (self.type == MHCalendarTypeOnlyDate) {
        [self.bottomButton setTitle:@"保 存" forState:UIControlStateNormal];
    }else if (self.type == MHCalendarTypeOnlyDateEnd){
        [self.bottomButton setTitle:@"确 定" forState:UIControlStateNormal];
    }

}

- (void)drawObliqueLine {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(MScreenW/2+24, 78)];
    [path addLineToPoint:CGPointMake(MScreenW/2-24, 134)];
    [path closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.borderWidth = 0.5;
    shapeLayer.strokeColor = MColorToRGB(0XD3DCE6).CGColor;
    shapeLayer.fillColor = MColorToRGB(0XD3DCE6).CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    shapeLayer.path = path.CGPath;
}

- (UIView *)setupWeekHeadViewWithFrame:(CGRect)frame {
    
    CGFloat height = frame.size.height;
    CGFloat width = MScreenW / 7.0;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < 7; ++i) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0.0, width, height)];
        label.backgroundColor = [UIColor clearColor];
        label.text = weekArray[i];
        label.textColor = MColorToRGB(0X324057);
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
    lineView.backgroundColor = MColorToRGB(0XD3DCE6);
    [view addSubview:lineView];
    return view;
    
}



#pragma mark - Private methods

- (MHCalendarScrollView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[MHCalendarScrollView alloc] initWithFrame:CGRectMake(0, 264, MScreenW, 280)];
        _calendarView.calendarBasicColor = [UIColor grayColor];
        _calendarView.dateTextColor      = MColorToRGB(0X324057);
    }
    return _calendarView;
}


@end
