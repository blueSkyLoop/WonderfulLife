//
//  MHHomeVolController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeVolController.h"
#import "HLWebViewController.h"

#import "MHHomeVolTopCell.h"
#import "MHHomeCommunityCell.h"
#import "MHRefreshGifHeader.h"

#import "MHHomeRequest.h"
#import "MHWeakStrongDefine.h"
#import "MHHUDManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+HLNavigation.h"
#import "MJRefresh.h"
#import "MHMacros.h"

#import "MHHomeArticle.h"
#import "MHUserInfoManager.h"

@interface MHHomeVolController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray<MHHomeArticle *> *dataList;
@property (copy,nonatomic) NSString *next_page;
@end

@implementation MHHomeVolController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"志愿者风采";
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
    [self hl_setNavigationItemLineColor:MColorSeparator];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHHomeVolTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHHomeVolTopCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHHomeCommunityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHHomeCommunityCell class])];
    
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    
    self.tableView.mj_header = mjheader;
    
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - request

- (void)loadNewData {
    MHWeakify(self)
    [MHHomeRequest loadVolListWithPage:nil communityId:self.community_id callBack:^(BOOL success, NSArray<MHHomeArticle *> *volunteerTopNews, NSString *errmsg,NSString *next_page) {
        MHStrongify(self)
        if (success) {
            self.dataList = [NSMutableArray arrayWithArray:volunteerTopNews];
            [self.tableView reloadData];
            if (next_page) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            } else {
                self.tableView.mj_footer = nil;
            }
            self.next_page = next_page;
        } else {
            [MHHUDManager showErrorText:errmsg];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreData {
    MHWeakify(self)
    [MHHomeRequest loadVolListWithPage:self.next_page communityId:self.community_id callBack:^(BOOL success, NSArray<MHHomeArticle *> *volunteerTopNews, NSString *errmsg,NSString *next_page) {
        MHStrongify(self)
        if (success) {
            [self.dataList addObjectsFromArray:volunteerTopNews];
            [self.tableView reloadData];
            self.next_page = next_page;
            if (next_page) {
                [self.tableView.mj_footer endRefreshing];
            } else {
               [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshing];
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}




#pragma mark - UITableViewDelegate & UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *url = self.dataList[indexPath.row].article_url;
    if (url.length) {
        [self.navigationController pushViewController:[[HLWebViewController alloc]initWithUrl:url] animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 282;
    } else {
        return 105;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MHHomeVolTopCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHHomeVolTopCell class])];
        MHHomeArticle *article = self.dataList[indexPath.row];
        [cell.mh_subjectLabel setText:article.subject];
        [cell.mh_timeLabel setText:article.post_time];
        if (article.img_url) [cell.mh_imageView sd_setImageWithURL:[NSURL URLWithString:article.img_url]];
        return cell;
    } else {
        MHHomeCommunityCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHHomeCommunityCell class])];
        MHHomeArticle *article = self.dataList[indexPath.row];
        [cell.mh_subject setText:article.subject];
        [cell.mh_timeLabel setText:article.post_time];
        if (article.img_url) [cell.mh_imageView sd_setImageWithURL:[NSURL URLWithString:article.img_url]];
        return cell;
    }
}

@end
