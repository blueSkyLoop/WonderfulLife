//
//  MHMineMerFinFilterController.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerFinFilterController.h"

#import "MHYMCalendarController.h"

#import "MHThemeButton.h"
#import "MHMacros.h"
#import "UIViewController+MHConfigControls.h"
#import "NSObject+isNull.h"
#import <Masonry.h>
#import "MHWeakStrongDefine.h"
#import "NSString+ChangeDate.h"
#import "MHHUDManager.h"
@interface MHMineMerFinFilterController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
//@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet MHThemeButton *actionBtn;

@property (nonatomic, copy)   NSString * date_begin;

@property (nonatomic, copy)   NSString * date_end;

@end

@implementation MHMineMerFinFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}


#pragma mark - SetUI
- (void)setUI {
    UIBarButtonItem*rightBar = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    rightBar.tintColor = MColorTitle ;
    self.navigationItem.rightBarButtonItem =rightBar ;
    
    [self mh_createTalbeView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.tableFooterView = self.footerView ;
    self.tableView.tableHeaderView = self.headerView ;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view) ;
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-88);
    }];
    [self clear];
}

- (void)resetBtnStatus {
        [self.tableView reloadData];
    if (![NSObject isNull:self.date_begin] && ![NSObject isNull:self.date_end]) {
        [self.actionBtn setEnabled:YES];
    }else {
        [self.actionBtn setEnabled:NO];
    }
}


#pragma mark - Event
- (void)clear {
    self.date_begin = nil;
    self.date_end = nil;
    [self resetBtnStatus];
}


- (IBAction)done:(id)sender {
    if (self.filterBlock) {
        if ([NSString mh_daysAwayFromString:self.date_begin dateSecondString:self.date_end format:@"yyyy-MM-dd"]) {
            self.filterBlock(self.date_begin, self.date_end);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [MHHUDManager showText:@"结束时间不能比开始时间早"];
        }
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MHMineMerFinFilterControllerCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"开始时间";
        cell.detailTextLabel.text = [NSObject isNull:self.date_begin] ? @"请选择" : self.date_begin;
    }else {
        cell.textLabel.text = @"结束时间";
        cell.detailTextLabel.text = [NSObject isNull:self.date_end] ? @"请选择" : self.date_end;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001 ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MHYMCalendarController *vc = [MHYMCalendarController new];
    NSString *requestFormat = @"yyyy-MM-dd";
    vc.outputDateFormat = requestFormat;
    if (indexPath.row == 0) {
        vc.inputDate = self.date_begin;
        vc.calendarTitle = @"开始时间";
    }else if (indexPath.row == 1) {
        vc.inputDate = self.date_end;
        vc.calendarTitle = @"结束时间";
    }
    MHWeakify(self)
    vc.block = ^(NSString *dateStr) {
        MHStrongify(self)
        if (indexPath.row == 0) {
            self.date_begin = dateStr ;
            
        }else{
            self.date_end = dateStr ;
        }
        [self resetBtnStatus];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}




@end
