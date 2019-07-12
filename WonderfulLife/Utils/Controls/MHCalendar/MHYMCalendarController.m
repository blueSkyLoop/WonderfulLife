//
//  MHMonthCalendarController.m
//  WonderfulLife
//
//  Created by zz on 10/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHYMCalendarController.h"
#import "MHCalendarView.h"
#import "MHThemeButton.h"

#import "MHMacros.h"
#import "Masonry.h"

#import "NSDate+MHCalendar.h"
#import "UIButton+MHImageUpTitleDown.h"
#import "UIViewController+HLNavigation.h"

@interface MHYMCalendarController () <MHCalendarViewDelegate, MHCalendarViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet MHThemeButton *saveButton;

@property (strong, nonatomic) MHCalendarView *calendarView;
@property (strong, nonatomic) NSDate *selectDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation MHYMCalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars=YES;

    NSDictionary * dict = [NSDictionary dictionaryWithObject:MColorTitle forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.title = self.calendarTitle;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [cancel setTitleColor:MColorTitle forState:UIControlStateNormal];
    [cancel sizeToFit];
    cancel.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [cancel setContentEdgeInsets:UIEdgeInsetsMake(0, -24, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(popEvent:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setTitle:@"今天" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [confirm sizeToFit];
    [confirm setTitleColor:MColorTitle forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(resetEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _calendarView = [[MHCalendarView alloc] initWithFrame:CGRectMake(0, 112, MScreenW, MScreenH - 112 - 96)];
    _calendarView.dataSource = self;
    _calendarView.delegate = self;
    [self.view addSubview:_calendarView];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_calendarView resetSelectDateAnimated:NO];
}


- (IBAction)saveEvents:(id)sender {
    if (self.block) {
        // 默认回调日期的格式
        NSString *dateFormat = @"yyyy-MM-dd HH:mm";
        if (self.outputDateFormat) {
            // 有传入回调日期的格式
            dateFormat = self.outputDateFormat;
        }
        NSString *selectedBlockDate = [self.selectDate stringFromDateFormat:dateFormat];
        self.block(selectedBlockDate);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetEvent:(id)sender {
    [_calendarView reloadResetData];
}

#pragma mark - MHCalendarViewDataSource
// 日历的最小日期
- (NSDate *)minimumDateForCalendar{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [self.dateFormatter dateFromString:@"1976-01-01"];
}
// 日历的最大日期
- (NSDate *)maximumDateForCalendar{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [self.dateFormatter dateFromString:@"2219-01-01"];
}
// 预设选择日期
- (NSDate *)defaultSelectDate{
    NSDate *defaultDate = [NSDate date];
    
    if (_inputDateFormat) {
        self.dateFormatter.dateFormat = _inputDateFormat;
    }else {
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    if (_inputDate) {
        defaultDate = [self.dateFormatter dateFromString:self.inputDate];
    }
//    
//    if (_inputDate.length >= 11) {
//        self.dateFormatter.dateFormat = @"yyyy年MM月dd日";
//        defaultDate = [self.dateFormatter dateFromString:self.inputDate];
//    }else if (_inputDate.length == 10){
//        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
//        defaultDate = [self.dateFormatter dateFromString:self.inputDate];
//    }
    self.selectDate = defaultDate;
    return defaultDate;
}
// 预设重置日期
- (NSDate *)defaultResetToDate{
    return [NSDate date];
}

#pragma mark - MHCalendarViewDelegate
// 回传所选择的日期为 NSDate 类型
- (void)selectNSDateFromDate:(NSDate *)date {
    self.selectDate = date;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
