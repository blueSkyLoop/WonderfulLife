//
//  MHVoBirthdayPickerView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoBirthdayPickerView.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "UIPickerView+RemoveSeparator.h"
#import "UIDatePicker+RemoveSeparator.h"
#import "UIImage+Color.h"

@interface MHVoBirthdayPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIButton *coverButton;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) NSDateFormatter *fmt;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIPickerView *agePicker;
@property (nonatomic,strong) NSMutableArray *years;
@property (nonatomic,strong) NSMutableArray *months;
@end

@implementation MHVoBirthdayPickerView{
    CGFloat scale;
    CGFloat x;
    
}

- (void)show{
    scale = MScreenW/375;
    x = 24*scale;
    [self addSubview:self.coverButton];
    [self addSubview:self.containerView];
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.nim_top -= (237+32)*scale;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.nim_top = self.nim_height;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

- (void)toolBarConfirm{
    BOOL scrolling = [self anySubViewScrolling:_containerView];
    if (scrolling) {
        return;
    }
    
    id string;
    if (_type == MHVoBirthdayPickerViewTypeAge) {
        NSDate *now = [NSDate date];
        NSString *dateStr = [self.fmt stringFromDate:now];
        NSInteger yearNow = [[dateStr substringToIndex:4] integerValue];
        NSString *year = self.years[[_agePicker selectedRowInComponent:0]];
        year = [year substringToIndex:4];
        NSInteger yearBirth = [year integerValue];
        NSString *month = self.months[[_agePicker selectedRowInComponent:1]];
        month = [month substringToIndex:2];
        NSString *birthdayStr = [NSString stringWithFormat:@"%@-%@",year,month];
        NSInteger age = yearNow - yearBirth;
        if (self.confirmAgeBlock) {
            self.confirmAgeBlock(birthdayStr, age);
        }
    }else{
        string = [self.fmt stringFromDate:self.datePicker.date];
        if (self.confirmBlock) {
            self.confirmBlock(string);
        }
    }
    [self dismiss];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - pickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.years.count;
    }else{
        return self.months.count;
    }
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    NSString *string;
//    if (component == 0) {
//        string = self.years[row];
//    }else{
//        string = self.months[row];
//    }
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:MColorTitle}];
//    return attrStr;
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *string;
    [pickerView mh_clearSpearatorLine];
    if (component == 0) {
        string = self.years[row];
    }else{
        string = self.months[row];
    }
    return string;
}

#pragma mark - lazy
- (UIButton *)coverButton{
    if (!_coverButton) {
        _coverButton = [[UIButton alloc] initWithFrame:self.bounds];
        [_coverButton setBackgroundColor:MRGBAColor(0, 0, 0, 0.3)];
        [_coverButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        
        if (self.birthdayStr.length) {
            _datePicker.date = [self.fmt dateFromString:self.birthdayStr];
        }else{
            NSDateComponents *cpn = [[NSDateComponents alloc] init];
            cpn.year = 1960;
            cpn.month = 1;
            cpn.day = 1;
            NSCalendar *gregorian = [NSCalendar currentCalendar];
            NSDate *date = [gregorian dateFromComponents:cpn];
            _datePicker.date = date;
        }
        
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.maximumDate = [NSDate date];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker mh_clearSpearatorLine];
        
        _datePicker.frame = CGRectMake(0, self.toolBar.nim_bottom, self.containerView.nim_width, 180*scale);;
    }
    return _datePicker;
}

- (UIPickerView *)agePicker{
    if (_agePicker == nil) {
        _agePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.toolBar.nim_bottom, self.containerView.nim_width, 180*scale)];
        
        self.years = [NSMutableArray array];
        NSDate *now = [NSDate date];
        NSString *dateStr = [self.fmt stringFromDate:now];
        NSInteger year = [[dateStr substringToIndex:4] integerValue];
        for (NSInteger i = 1917; i <= year; i++) {
            NSString *yearStr = [NSString stringWithFormat:@"%zd年",i];
            [self.years addObject:yearStr];
        }
        self.months = [NSMutableArray array];
        for (NSInteger i = 1; i <= 12; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%02zd月",i];
            [self.months addObject:monthStr];
        }
        
        _agePicker.dataSource = self;
        _agePicker.delegate = self;
        [_agePicker selectRow:self.age == -1 ? 73 : 100 - self.age inComponent:0 animated:NO];
    }
    return _agePicker;
}

- (UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(x, self.nim_height, self.nim_width-2*x, 237*scale)];
        _containerView.layer.cornerRadius = 8*scale;
        _containerView.layer.masksToBounds = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView addSubview:self.toolBar];
        if (self.type == MHVoBirthdayPickerViewTypeAge) {
            [_containerView addSubview:self.agePicker];
        }else{
            [_containerView addSubview:self.datePicker];
        }
    }
    return _containerView;
}

- (UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.containerView.nim_width, 56*scale)];
        _toolBar.barTintColor = [UIColor whiteColor];
        _toolBar.clipsToBounds = YES;
        [_toolBar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionBottom];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _toolBar.nim_height-0.5, _toolBar.nim_width, 0.5)];
        line.backgroundColor = MColorSeparator;
        [_toolBar addSubview:line];
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
        [confirm setTitle:@"确定" forState:UIControlStateNormal];
        confirm.titleLabel.font = [UIFont systemFontOfSize:16];
        [confirm sizeToFit];
        [confirm addTarget:self action:@selector(toolBarConfirm) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
        
        UIBarButtonItem *fiexibleSpaceLeft = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        fiexibleSpaceLeft.tintColor = [UIColor whiteColor];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancel sizeToFit];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
        [_toolBar setItems:@[cancelItem,fiexibleSpaceLeft ,confirmItem]];
    }
    return _toolBar;
}

- (NSDateFormatter *)fmt{
    if (!_fmt) {
        _fmt = [[NSDateFormatter alloc] init];
        _fmt.dateFormat = self.type ? @"YYYY/MM/dd" : @"YYYY-MM-dd" ;
    }
    return _fmt;
}
@end
