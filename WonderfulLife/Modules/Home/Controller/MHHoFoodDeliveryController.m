//
//  MHHoFoodDeliveryController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/22.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoFoodDeliveryController.h"
#import "MHMacros.h"
#import "MHHoFooDeliCommitController.h"

@interface MHHoFoodDeliveryController ()
@property (weak, nonatomic) IBOutlet UIView *firstContainerView;
@property (weak, nonatomic) IBOutlet UIView *secondContainerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MHHoFoodDeliveryController

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"食堂送餐";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.firstContainerView.layer.cornerRadius = 4;    
//    self.firstContainerView.layer.shadowOffset = CGSizeMake(0, 2);
//    self.firstContainerView.layer.shadowRadius = 5;
//    self.firstContainerView.layer.shadowColor = MColorDisableBtn.CGColor;
//    self.firstContainerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
//    self.firstContainerView.layer.shadowOpacity = 1;
//    
//    self.secondContainerView.layer.cornerRadius = 4;
//    self.secondContainerView.layer.masksToBounds = YES;
    
    
    NSDate *now = [NSDate date];

    NSDateFormatter *showFmt = [[NSDateFormatter alloc] init];
    showFmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [showFmt stringFromDate:now];
    
    NSString *lunStart = @"00-00";
    NSString *lunEnd = @"12-00";
    NSString *dinStart = @"12-01";
    NSString *dinEnd = @"17-00";
    
    if ([self judgeTimeByStartAndEnd:lunStart withExpireTime:lunEnd]) { //今天午餐
        self.timeLabel.text = [NSString stringWithFormat:@"%@ 午餐",dateStr];
    }else if ([self judgeTimeByStartAndEnd:dinStart withExpireTime:dinEnd]){ //今天晚餐
        self.timeLabel.text = [NSString stringWithFormat:@"%@ 晚餐",dateStr];
    }else{
        now = [now dateByAddingTimeInterval:24*60*60];
        dateStr = [showFmt stringFromDate:now];
        self.timeLabel.text = [NSString stringWithFormat:@"%@ 午餐",dateStr];
    }
}

- (BOOL)judgeTimeByStartAndEnd:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"HH-mm"];
    NSString * todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    today=[ dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //startTime格式为 02:22   expireTime格式为 12:44
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}


- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - 按钮点击

- (IBAction)delivery {
    [self.navigationController pushViewController:[MHHoFooDeliCommitController new] animated:YES];
}
#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







