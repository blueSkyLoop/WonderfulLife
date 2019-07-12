//
//  MHVoCultivateController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoCultivateController.h"
#import "MHVoCultivateCell.h"
#import "MHCultivateContentController.h"
#import "MHVolunteerDataHandler.h"
#import "MHVoCultivateModel.h"
#import <YYModel.h>
#import "MHHUDManager.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#define MHVoCultivateCellID @"MHVoCultivateCellID"

@interface MHVoCultivateController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,weak) UIView *headerView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataList;
@end

@implementation MHVoCultivateController{
    CGFloat scale;
    CGFloat all;
    CGFloat halfTopLabelHeight;
    CGFloat fontRange;
}

- (instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    scale = MScreenW/375;
    [self setupTopLabel];
    halfTopLabelHeight = self.topLabel.nim_height/2;
    all = 64 + halfTopLabelHeight - 44;
    fontRange = 34*scale - 17;
    
    [MHVolunteerDataHandler postVoCultivateCategoryListSuccess:^(NSDictionary *data) {
        self.dataList = [NSArray yy_modelArrayWithClass:[MHVoCultivateModel class] json:data];
        [self.tableView reloadData];
    } failure:^(NSString *errmsg) {
        [MHHUDManager showErrorText:errmsg];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - private
- (void)setupTopLabel{
    UILabel *TopLabel = [[UILabel alloc] init];
    TopLabel.font = [UIFont systemFontOfSize:34*scale];
    TopLabel.textColor = MRGBColor(50, 64, 87);
    TopLabel.text = @"志愿者培训";
    TopLabel.textAlignment = NSTextAlignmentCenter;
    [TopLabel sizeToFit];
    TopLabel.nim_centerX = self.view.nim_width/2;
    
    UIView *headerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, 0)];
    headerView.nim_height = TopLabel.nim_bottom+32*scale;
    [headerView addSubview:TopLabel];
    headerView.userInteractionEnabled = NO;
    [self.view addSubview:headerView];
    self.topLabel = TopLabel;
    self.headerView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVoCultivateCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoCultivateCellID];
    MHVoCultivateModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MHCultivateContentController *vc = [[MHCultivateContentController alloc] init];
    MHVoCultivateModel *model = self.dataList[indexPath.row];
    vc.parentModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.topLabel.nim_top = -(offsetY + self.headerView.nim_height);
    
    CGPoint center = [self.headerView convertPoint:self.topLabel.center toView:self.view];

    if (center.y<=44) {
        center.y = 44;
        CGPoint newCenter = [self.view convertPoint:center toView:self.headerView];
        self.topLabel.center = newCenter;
        self.topLabel.font = [UIFont systemFontOfSize:17];
    }else if (center.y-halfTopLabelHeight < 64 && center.y > 44){
        
        CGFloat offset = center.y - 44;
        self.topLabel.font = [UIFont systemFontOfSize:17 + fontRange * offset/all];
    }else{
        self.topLabel.font = [UIFont systemFontOfSize:34*scale];
    }
}

#pragma mark - lazy

- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, self.view.nim_height-64) style:UITableViewStylePlain];
        UIView *footerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.nim_width, 0.5)];
        footerLine.backgroundColor = MRGBColor(211, 220, 230);
        tableView.tableFooterView = footerLine;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = 80*scale;
        tableView.contentInset = UIEdgeInsetsMake(self.headerView.nim_height, 0, 0, 0);
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerClass:[MHVoCultivateCell class] forCellReuseIdentifier:MHVoCultivateCellID];
        [self.view addSubview:tableView];
        [self.view bringSubviewToFront:self.headerView];
        _tableView = tableView;
    }
    return _tableView;
}


@end


