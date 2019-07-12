//
//  MHCalendarTimeController.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCalendarTimeController.h"
#import "MHCalendarTimePickCell.h"
#import "MHMacros.h"

#import "NSDate+MHCalendar.h"
#import "UIPickerView+MHPicker.h"

@interface MHCalendarTimeController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineTopConstraint;

@property (strong, nonatomic) NSMutableArray *hours;
@property (strong, nonatomic) NSMutableArray *minutes;
@property (strong, nonatomic) NSDate         *didSelectedTime;

@property (assign, nonatomic) NSInteger selectHour;
@property (assign, nonatomic) NSInteger selectMinute;
@end

@implementation MHCalendarTimeController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


    [self drawObliqueLine];

    if (isIPhone5()) {
        self.topLineTopConstraint.constant = 185;
    }
    
    self.dateLabel.text = self.didSelectedWeek;
    
    _hours = [NSMutableArray array];
    _minutes = [NSMutableArray array];
    
    NSInteger index = 0;
    do {
        [_hours addObject:@(index)];
        index++;
    } while (index < 24);
    index = 0;
    do {
        [_minutes addObject:@(index)];
        index++;
    } while (index < 60);

    [self handleInputTime];
}

- (void)handleInputTime {

    NSDate *currentDate  = [NSDate date];
    
    if (_inputTime) {
        currentDate = _inputTime;
    }
    
    self.didSelectedTime = currentDate;
    
    NSString *currentHour   = [currentDate stringFromDateFormat:@"HH"];
    NSString *currentMinute = [currentDate stringFromDateFormat:@"mm"];
    self.timeLabel.text     = [currentDate stringFromDateFormat:@"a HH:mm"];
    
    _selectHour   = [currentHour integerValue];
    _selectMinute = [currentMinute integerValue];
    
    [self.pickView selectRow:(self.hours.count *100 + _selectHour) inComponent:0 animated:YES];
    [self.pickView selectRow:(self.hours.count *100 + _selectMinute) inComponent:1 animated:YES];

}

- (void)updateTimeLabel {
    NSString *selectedTime = [NSString stringWithFormat:@"%ld:%ld",(long)_selectHour,(long)_selectMinute];
    self.didSelectedTime   = [NSDate dateFromStringDate:selectedTime format:@"H:m"];
    self.timeLabel.text    = [self.didSelectedTime stringFromDateFormat:@"a HH:mm"];
}

#pragma mark - Action methods
- (void)popLastControllerEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetSelectedSender:(id)sender {
    NSDate *currentDate = [NSDate date];
    
    if (_resetDate) {
        currentDate = _resetDate;
    }
    
    NSString *currentHour   = [currentDate stringFromDateFormat:@"HH"];
    NSString *currentMinute = [currentDate stringFromDateFormat:@"mm"];
    self.timeLabel.text     = [currentDate stringFromDateFormat:@"a HH:mm"];
    self.didSelectedTime    = currentDate;

    _selectHour   = [currentHour integerValue];
    _selectMinute = [currentMinute integerValue];
    
    [self.pickView selectRow:(self.hours.count *100 + _selectHour) inComponent:0 animated:YES];
    [self.pickView selectRow:(self.hours.count *100 + _selectMinute) inComponent:1 animated:YES];
}

- (IBAction)saveEvent:(id)sender {
    if (self.block) {
        NSString *didSelectedBlockDate = [self.didSelectedDate stringFromDateFormat:@"yyyy-MM-dd"];
        NSString *didSelectedBlockTime = [self.didSelectedTime stringFromDateFormat:@"HH:mm"];
        NSString *blockDate = [NSString stringWithFormat:@"%@ %@",didSelectedBlockDate,didSelectedBlockTime];
        
        if (_outputDateFormat) {
            NSDate *outputDate = [NSDate dateFromStringDate:blockDate format:@"yyyy-MM-dd HH:mm"];
            blockDate = [outputDate stringFromDateFormat:_outputDateFormat];
        }
        
        self.block(blockDate);
    }
    NSInteger index = self.navigationController.viewControllers.count-3;
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _hours.count*200;
    }
    return _minutes.count *200;
}

#pragma mark - UIPickerViewDelegate
// 选中行显示在label上
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        NSInteger count = self.hours.count;
        _selectHour = [self.hours[row%count] integerValue];
    }else if(component == 1){
        NSInteger count = self.minutes.count;
        _selectMinute = [self.minutes[row%count] integerValue];
    }
    [self updateTimeLabel];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    NSInteger rowNum = 0;
    if (component == 0) {
        NSInteger count = self.hours.count;
        rowNum = [self.hours[row%count] integerValue];
    }else{
        NSInteger count = self.minutes.count;
        rowNum = [self.minutes[row%count] integerValue];
    }
    MHCalendarTimePickCell *cell = [MHCalendarTimePickCell cellWithRow:rowNum];
    [pickerView clearSpearatorLine];
    return cell;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 130;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 67;
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


@end
