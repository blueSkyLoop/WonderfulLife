//
//  MHVolSlectedCityListController.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSlectedCityListController.h"

#import "MHMacros.h"
#import "UIViewController+HLNavigation.h"
#import "NSString+HLJudge.h"
#import "UIView+HLChainStyle.h"
#import "MHVolSlectedDataSource.h"

#import "MJRefresh.h"
#import "MHWeakStrongDefine.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "MHCityModel.h"
#import "MHHUDManager.h"
#import "MHRefreshGifHeader.h"
#import "MHCommunityModel.h"
#import "MHLoginRequestHandler.h"

#import "MHLoSelectPlotCell.h"
#import "MHLoSelectPlotFootView.h"

@interface MHVolSlectedCityListController ()
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger searchPageId;
@property (nonatomic, copy)   NSString * netUrl;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldToBottom;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL      isfirstLoad;
@property (nonatomic, strong) MHVolSlectedDataSource      *t_dataSource;
@end

@implementation MHVolSlectedCityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    
    
    /// bind the dataSource in tableView or collectionView
    [self bindDataSource];
    
    [self searchLogic];
}

- (void)initUI {
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    
    
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = MColorToRGB(0XD3DCE6).CGColor;
    self.textField.layer.cornerRadius = 4;
    self.textField.layer.masksToBounds = YES;
    [self.textField setValue:MColorToRGB(0XD3DCE6) forKeyPath:@"_placeholderLabel.textColor"];
    
    UIImage *image = [UIImage imageNamed:@"lo_search"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.hl_width(image.size.width+12);
    imageView.contentMode = UIViewContentModeRight;
    self.textField.leftView = imageView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    MHWeakify(self)
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    [self.tableView.mj_header beginRefreshing];
}


- (void)bindDataSource {
    self.tableView.delegate        = self.t_dataSource;
    self.tableView.dataSource      = self.t_dataSource;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHLoSelectPlotCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([MHLoSelectPlotCell class])];
    self.tableView.tableFooterView           = [[UIView alloc] initWithFrame:CGRectZero];
    RAC(self.t_dataSource, searchText)       = self.textField.rac_textSignal;
    
    MHWeakify(self)
    [self.t_dataSource.resultSubject subscribeNext:^(NSIndexPath *indexPath) {
        MHStrongify(self)
        
        NSArray *datas ;
        if ([self.textField.text hl_isEmpty])  datas = [self.t_dataSource.allPlots copy];
        else datas = [self.t_dataSource.searchPlots copy];
        
        MHCommunityModel * community = datas[indexPath.row];
        self.currentCity.city_name = [NSString stringWithFormat:@"%@市",self.currentCity.city_name];
        self.callBack(self.currentCity, community);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - request

- (void)loadNewData {
    _pageId = 1 ;
    MHWeakify(self)

        [MHLoginRequestHandler selectServerCommunityWithCityName:self.currentCity.city_name keyword:nil page:[NSNumber numberWithInteger:_pageId] success:^(NSArray *plots) {
            MHStrongify(self)
            [self.t_dataSource.allPlots removeAllObjects];
            self.t_dataSource.allPlots = [NSMutableArray arrayWithArray:plots];
            [self.tableView reloadData];

            [self.tableView.mj_header endRefreshing];
            [self plotsDataSourceRestTableViewFooter];

            if (plots.count<10) {
                self.tableView.mj_footer = nil;
            } else {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
        } failure:^(NSString *errmsg) {
            [self.tableView.mj_header endRefreshing];
            [MHHUDManager showErrorText:errmsg];
        }];
}

// 加载更多 全市小区数据
- (void)loadMoreData {
    NSNumber *page ;
    NSString *key ;
    NSMutableArray *datas ;
    if ([self.textField.text hl_isEmpty]) {
        _pageId ++ ;
        page =  [NSNumber numberWithInteger:_pageId];
        datas = self.t_dataSource.allPlots ;
        
    }else{
        _searchPageId ++ ;
        page = [NSNumber numberWithInteger:_searchPageId] ;
        key = self.textField.text ;
        datas = self.t_dataSource.searchPlots ;
    }
    
    MHWeakify(self)
    [MHLoginRequestHandler selectServerCommunityWithCityName:self.currentCity.city_name keyword:key page:page success:^(NSArray *plots) {
        MHStrongify(self)
        [datas addObjectsFromArray:plots];
        [self.tableView reloadData];
        if (plots.count<10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errmsg) {
        MHStrongify(self)
        [self.tableView.mj_footer endRefreshing];
        [MHHUDManager showErrorText:errmsg];
    }];
}


- (void)searchLogic {
    //    ///MARK - dismiss tap
    
    //  热门&所有   搜：所有
    //  只有热门   只搜 ：热门
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
        if ([self.textField.text hl_isEmpty]) {
            [self plotsDataSourceRestTableViewFooter];
            [self.tableView reloadData];
        }
    }];
    
    if(self.textField.hidden) return;
    
    [[[[self.textField.rac_textSignal
        distinctUntilChanged]
       throttle:0.5]
      filter:^BOOL(NSString * _Nullable value) {
          @strongify(self)
          self.t_dataSource.searchPlots  = nil;
          self.t_dataSource.searchCities = nil;
          [self.tableView reloadData];
          self.searchPageId = 1 ;
          if (self.isfirstLoad) {
              self.tableView.tableFooterView = [UIView new];
              if (self.t_dataSource.allPlots.count < 10)
                  self.tableView.mj_footer = nil;
              else
                  self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
          }
          self.isfirstLoad = YES;
          return  ![value hl_isEmpty];
      }]
     subscribeNext:^(NSString * _Nullable keyword) {
         @strongify(self)
             [MHLoginRequestHandler
              selectServerCommunityWithCityName:self.currentCity.city_name
              keyword:keyword page:nil
              success:^(NSArray *plots) {
                  self.t_dataSource.searchPlots = [NSMutableArray arrayWithArray:plots];
                  [self.tableView reloadData];
                  if (plots.count) {
                      self.tableView.tableFooterView = [UIView new];
                      
                  } else {
                      
                    self.tableView.tableFooterView = [MHLoSelectPlotFootView initDefaultFootView];
                  }
                  
                  [MHHUDManager dismiss];
              } failure:^(NSString *errmsg) {
                  [MHHUDManager dismiss];
                  [MHHUDManager showErrorText:errmsg];
              }];
     }];
}

- (void)plotsDataSourceRestTableViewFooter{
    if (self.t_dataSource.allPlots.count == 0 ) {
            self.tableView.tableFooterView = [MHLoSelectPlotFootView initDefaultFootView];
    }
}

- (MHVolSlectedDataSource *)t_dataSource {
    if (!_t_dataSource) {
        _t_dataSource = [MHVolSlectedDataSource new];
    }
    return _t_dataSource;
}

- (MHCityModel *)currentCity {
    if (!_currentCity) {
        _currentCity = [MHCityModel cityModelFromUserInfo];
    } return _currentCity;
}
@end
