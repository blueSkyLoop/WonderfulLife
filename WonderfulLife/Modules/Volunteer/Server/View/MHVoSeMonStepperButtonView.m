//
//  MHVoSeMonStepperButtonView.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeMonStepperButtonView.h"
#import "MHMacros.h"
#import "UIView+MHFrame.h"
@interface MHVoSeMonStepperButtonView ()
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *dataBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, assign) MHVoSeMonStepperButtonViewType type;

@property (nonatomic, strong, readwrite) NSString *date;

@property (nonatomic, assign) NSTimeInterval currentTimeInterval;
@property (nonatomic, assign) NSTimeInterval timeIntervalFlag;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger yearFlag;
@property (nonatomic, assign) NSInteger monthFlag;
@end
@implementation MHVoSeMonStepperButtonView

+ (instancetype)voSeMonStepperButtonViewWithType:(MHVoSeMonStepperButtonViewType)type {
    
    MHVoSeMonStepperButtonView *v = [[[NSBundle mainBundle] loadNibNamed:@"MHVoSeMonStepperButtonView" owner:nil options:nil] lastObject];
    v.type = type;
    return v;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 28;
    self.layer.borderColor = MColorSeparator.CGColor;
    self.layer.borderWidth = 1;
    
    self.frame = CGRectMake(24, 160, MScreenW - 48, 56);
  
}

- (void)setType:(MHVoSeMonStepperButtonViewType)type {
    _type = type;
    NSDate *date = [NSDate date];
    _currentTimeInterval = date.timeIntervalSince1970;
    _timeIntervalFlag = _currentTimeInterval;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    _year = [dateComponent year];
    _month =  [dateComponent month];
    _day = [dateComponent day];
    
    _yearFlag = [dateComponent year];
    _monthFlag =  [dateComponent month];
    
    _date = [NSString stringWithFormat:@"%ld-%02ld-%02ld", _year, _month, _day];
    
    if (_type == MHVoSeMonStepperButtonViewDay) {
        [_leftBtn setTitle:@"上一日" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"下一日" forState:UIControlStateNormal];
        
        NSString *date = [NSString stringWithFormat:@"%02ld月%02ld日", _month, _day];
        [self.dataBtn setTitle:date forState:UIControlStateNormal];
    } else {
        [_leftBtn setTitle:@"上一月" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"下一月" forState:UIControlStateNormal];
        NSString *date = [NSString stringWithFormat:@"%02ld月", _month];
        [self.dataBtn setTitle:date forState:UIControlStateNormal];
    }
}

- (IBAction)lastAction:(UIButton *)sender {
   
    if (_type == MHVoSeMonStepperButtonViewDay) {
        
        self.timeIntervalFlag -= 24*60*60;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalFlag];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        
        _yearFlag = [dateComponent year];
        _monthFlag =  [dateComponent month];
        _day = [dateComponent day];
        
        NSString *dateStr = [NSString stringWithFormat:@"%02ld月%02ld日", _monthFlag, _day];
        [self.dataBtn setTitle:dateStr forState:UIControlStateNormal];

    } else {
        if (_monthFlag == 1) {
            _yearFlag -= 1;
            _monthFlag = 12;
        } else {
            _monthFlag -= 1;
        }
        NSString *dateStr = [NSString stringWithFormat:@"%02ld月", _monthFlag];
        [self.dataBtn setTitle:dateStr forState:UIControlStateNormal];
        
        !self.clickLastBlock ?: self.clickLastBlock(_yearFlag, _monthFlag);
    }
    
    _date = [NSString stringWithFormat:@"%ld-%02ld-%02ld", _yearFlag, _monthFlag, _day];
}

- (IBAction)nextAction:(UIButton *)sender {
    if (_type == MHVoSeMonStepperButtonViewDay) {
        
        //判断显示时间是否大于或等于当前时间
        if (self.timeIntervalFlag >= self.currentTimeInterval) return;
        
        self.timeIntervalFlag += 24*60*60;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalFlag];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        
        _yearFlag = [dateComponent year];
        _monthFlag =  [dateComponent month];
        _day = [dateComponent day];
        
        NSString *dateStr = [NSString stringWithFormat:@"%02ld月%02ld日", _monthFlag, _day];
        [self.dataBtn setTitle:dateStr forState:UIControlStateNormal];
        
    } else {
         //判断显示时间是否大于或等于当前时间
        if ((_yearFlag >= _year) && (_monthFlag >= _month)) return;
     
        if (_monthFlag == 12) {
             _yearFlag += 1;
            _monthFlag = 1;
        } else {
            _monthFlag += 1;
        }
        NSString *dateStr = [NSString stringWithFormat:@"%02ld月", _monthFlag];
        [self.dataBtn setTitle:dateStr forState:UIControlStateNormal];
        
        !self.clickNextBlock ?: self.clickNextBlock(_yearFlag, _monthFlag);
    }
    
    _date = [NSString stringWithFormat:@"%ld-%02ld-%02ld", _yearFlag, _monthFlag, _day];
}



@end
