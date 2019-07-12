//
//  MHVoAtReMonthSiftController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAtReMonthSiftController.h"
#import "UIView+NIM.h"
#import "MHMacros.h"
#import "UIPickerView+RemoveSeparator.h"

#import "MHAttendancenDetailBottomView.h"

#import "MHVoAttendanceRecordSiftModel.h"

@interface MHVoAtReMonthSiftController ()<UIPickerViewDelegate,UIPickerViewDataSource,MHAttendancenDetailBottomViewDelegate>
@property (nonatomic,strong) NSMutableArray *years;
@property (nonatomic,strong) NSMutableArray *months;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) MHAttendancenDetailBottomView *bottomView;
@end

@implementation MHVoAtReMonthSiftController{
    NSInteger currentYear;
    NSInteger currentMonth;
    BOOL hasReset;
}

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请滑动选择年份月份查看";
    label.textColor = MColorFootnote;
    label.font = [UIFont systemFontOfSize:18];
    [label sizeToFit];
    label.nim_top = 88;
    label.nim_centerX = self.view.nim_width/2;
    [self.view addSubview:label];
    
    [self pickerView];
    
    [self bottomView];
}

#pragma mark - 按钮点击
- (void)reset{
    [_pickerView selectRow:self.years.count-3 inComponent:0 animated:YES];
    [_pickerView selectRow:currentMonth-1 inComponent:1 animated:YES];
    _siftModel.year = nil;
    _siftModel.month = nil;
    hasReset = YES;
}

- (void)bottomButtonDidClick{
    if (hasReset == false) {
        NSInteger selectedYearIndex = [_pickerView selectedRowInComponent:0];
        NSInteger selectedMonthIndex = [_pickerView selectedRowInComponent:1];
        NSString *selectedMonth = self.months[selectedMonthIndex];
        NSString *selectedYear = self.years[selectedYearIndex];
        _siftModel.year = [NSNumber numberWithInteger:selectedYear.integerValue];
        _siftModel.month = [NSNumber numberWithInteger:selectedMonth.integerValue];
    }
    
    !self.beginSift ? : self.beginSift();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.years.count;
    }else{
        return self.months.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    [pickerView mh_clearSpearatorLine];
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        NSString *year = self.years[row];
        UIFont *font = iOS8 ? [UIFont systemFontOfSize:48] : [UIFont fontWithName:@"PingFangSC-Semibold" size:48];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:year attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:MColorTitle}];
        label.attributedText = attr;
        return label;
    }else{
        NSString *month = self.months[row];
        UIFont *font = iOS8 ? [UIFont systemFontOfSize:48] : [UIFont fontWithName:@"PingFangSC-Semibold" size:48];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:month attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MColorTitle}];
        label.attributedText = attr;
        return label;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.view.nim_width/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 112*MScale;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    hasReset = NO;
    if (component == 0) {
        
        if (row>=self.years.count-3) {
            NSInteger selectedMonthIndex = [pickerView selectedRowInComponent:1];
            NSInteger selectedMonth = [self.months[selectedMonthIndex] integerValue];
            if (selectedMonth > currentMonth) {
                [pickerView selectRow:currentMonth-1 inComponent:1 animated:YES];
            }
            [pickerView selectRow:self.years.count-3 inComponent:0 animated:YES];
        }
        
    }else if (component == 1){
        NSInteger selectedYearIndex = [pickerView selectedRowInComponent:0];
        if (row > currentMonth-1 && selectedYearIndex>=self.years.count-3) {
            [pickerView selectRow:currentMonth-1 inComponent:1 animated:YES];
        }
    }
}

#pragma mark - private
- (void)setupNav{
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"重置" forState:UIControlStateNormal];
    UIFont *font = iOS8 ? [UIFont systemFontOfSize:17] : [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    confirm.titleLabel.font = font;
    [confirm sizeToFit];
    [confirm setTitleColor:MColorTitle forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = @"查看月份";
    
}

#pragma mark - lazy
- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        NSDate *now = [NSDate date];
        NSCalendar *calender = [NSCalendar currentCalendar];
        currentYear = [calender component:NSCalendarUnitYear fromDate:now];
        currentMonth = [calender component:NSCalendarUnitMonth fromDate:now];
        
        self.years = [NSMutableArray array];
        for (NSInteger i = 2010; i <= currentYear+2; i++) {
            NSString *yearStr = [NSString stringWithFormat:@"%zd",i];
            [self.years addObject:yearStr];
        }
        self.months = [NSMutableArray array];
        for (NSInteger i = 1; i <= 12; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%zd",i];
            [self.months addObject:monthStr];
        }
        
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.frame = CGRectMake(0, 150*MScale, self.view.nim_width, 370*MScale);
        [self.view addSubview:_pickerView];
        
        if (_siftModel.year) {
            NSInteger selectedYear = _siftModel.year.integerValue;
            NSInteger selectedMonth = _siftModel.month.integerValue;
            [_pickerView selectRow:selectedYear-2010 inComponent:0 animated:NO];
            [_pickerView selectRow:selectedMonth-1 inComponent:1 animated:NO];
        }else{
            [_pickerView selectRow:self.years.count-3 inComponent:0 animated:NO];
            [_pickerView selectRow:currentMonth-1 inComponent:1 animated:NO];            
        }

    }
    return _pickerView;
}

- (MHAttendancenDetailBottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [MHAttendancenDetailBottomView bottomView];
        _bottomView.type = MHAttendancenDetailBottomViewTypeSave;
        [self.view addSubview:_bottomView];
        _bottomView.frame = CGRectMake(0, self.view.nim_height-96, self.view.nim_width, 96);
        _bottomView.delegate = self;
    }
    return _bottomView;
}

#ifdef DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif
@end







