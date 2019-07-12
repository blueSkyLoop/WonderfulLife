//
//  MHhoNotificationDetailViewController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHhoNotificationDetailViewController.h"
#import "MHHoMsgNotifiModel.h"

@interface MHhoNotificationDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end

@implementation MHhoNotificationDetailViewController

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = _model.ext_data.title;
    self.timeLabel.text = _model.create_datetime;
    self.detailLabel.text = _model.subject;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







