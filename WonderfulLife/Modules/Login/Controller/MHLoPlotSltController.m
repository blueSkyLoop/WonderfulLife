//
//  MHLoPlotSltController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHLoPlotSltController.h"
#import "MHLoginRequestHandler.h"
#import "MHVolunteerDataHandler.h"

#import "UIViewController+HLNavigation.h"
#import "UIViewController+HLStoryBoard.h"
#import "UIView+HLChainStyle.h"
#import "NSString+HLJudge.h"

#import "MHLoSelectPlotFootView.h"
#import "MHLoSelectCityCell.h"
#import "MHLoSelectPlotCell.h"
#import "MHCollectionHeaderView.h"
#import "MHVoAddressAddController.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import "MJRefresh.h"
#import "MHWeakStrongDefine.h"
#import "MHCommunityModel.h"
#import "MHCityModel.h"
#import "MHHUDManager.h"
#import "JFMapManager.h"
#import "MHMacros.h"
#import "MHVoDataFillController.h"
#import "MHVolCreateModel.h"
#import "MHLoPlotSltCollectionDataSource.h"
#import "MHLoPlotSltTableDataSource.h"

#import "JFAuthorizationStatusManager.h"
#import "MHRefreshGifHeader.h"

@interface MHLoPlotSltController ()<UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldToBottom;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL      isfirstLoad;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger searchPageId;

@property (nonatomic, strong) MHLoPlotSltCollectionDataSource *c_dataSource;
@property (nonatomic, strong) MHLoPlotSltTableDataSource      *t_dataSource;

@end

@implementation MHLoPlotSltController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    
    
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = MColorToRGB(0XD3DCE6).CGColor;
    self.textField.layer.cornerRadius = 4;
    self.textField.layer.masksToBounds = YES;
    [self.textField setValue:MColorToRGB(0XD3DCE6) forKeyPath:@"_placeholderLabel.textColor"];

    /// bind the dataSource in tableView or collectionView
    [self bindDataSource];
    
    UIImage *image = [UIImage imageNamed:@"lo_search"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.hl_width(image.size.width+12);
    imageView.contentMode = UIViewContentModeRight;
    self.textField.leftView = imageView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    MHWeakify(self)
    if (self.sltType == MHLoPlotSltTypeCity || self.sltType == MHLoPlotSltTypeCertifi) {
        ///MARK - hidden textField
        self.textField.hidden = YES;
        self.textFieldHeight.constant = 0;
        self.textFieldToBottom.constant = 0;
        
        [self.titleLabel setText:@"所在城市"];
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        [MHHUDManager show];
        __block BOOL flag = NO;
        
        if ([JFAuthorizationStatusManager authorizationStatusMediaTypeMapIsOpen]) {
            [[JFMapManager manager]singlePositioningCompletionBlock:^(CLLocation *location, NSString *city, NSError *error) {
                MHStrongify(self)
                if (flag) {
                    [MHHUDManager dismiss];
                } else {
                    flag = YES;
                }
                if (error||!city) {
                    self.c_dataSource.mapCity = [MHCityModel cityWithName:@"无法定位"];
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                } else {
                    self.c_dataSource.mapCity = [MHCityModel cityWithName:city];
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                }
            }];
        }else {
            //延时加载，处理在iOS8刷新collectionView 布局错乱issue
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeMap target:self];
                self.c_dataSource.mapCity = [MHCityModel cityWithName:@"无法定位"];
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            });
        }
        
        [MHLoginRequestHandler postHotCityListSuccess:^(NSArray *cities) {
            MHStrongify(self)
            [MHHUDManager dismiss];
            self.c_dataSource.dataSource = [cities copy];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            if (flag) {
                [MHHUDManager dismiss];
            } else {
                flag = YES;
            }
        } failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
    } else if (self.sltType == MHLoPlotSltTypePlot
               || self.sltType == MHLoPlotSltTypeChooseCommunity
               || self.sltType == MHLoPlotSltTypeWithCommunity || self.sltType == MHLoPlotSltTypeVol) {
        NSString *title =  self.sltType != MHLoPlotSltTypeChooseCommunity ? @"所在小区" : @"选择志愿服务站";
        [self.titleLabel setText:title];
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        mjheader.lastUpdatedTimeLabel.hidden = YES;
        mjheader.stateLabel.hidden = YES;
        self.tableView.mj_header = mjheader;
        [self.tableView.mj_header beginRefreshing];
    } else {}
    
    [self searchLogic];
}

- (void)bindDataSource {
    
    self.collectionView.delegate   = self.c_dataSource;
    self.collectionView.dataSource = self.c_dataSource;
    self.tableView.delegate        = self.t_dataSource;
    self.tableView.dataSource      = self.t_dataSource;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHLoSelectPlotCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([MHLoSelectPlotCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MHLoSelectCityCell class]) bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([MHLoSelectCityCell class])];
    [self.collectionView registerClass:[MHCollectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass([MHCollectionHeaderView class])];

    self.tableView.tableFooterView           = [[UIView alloc] initWithFrame:CGRectZero];
    self.collectionView.collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.alwaysBounceVertical = YES;
    
    RAC(self.t_dataSource, searchText)       = self.textField.rac_textSignal;
    self.t_dataSource.chooseCommunity        = self.sltType == MHLoPlotSltTypeChooseCommunity;
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //                              CollectionView Callbacks
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    @weakify(self);
    [self.c_dataSource.resultSubject subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        //MHLoPlotSltTypeCity 只有首页用到，【首页】和【注册】 搜索无结果要显示体验小区，加枚举MHLoPlotSltTypeWithCommunity
        if (self.sltType == MHLoPlotSltTypeCity||self.sltType == MHLoPlotSltTypeWithCommunity) {
            MHLoPlotSltController *vc = [MHLoPlotSltController hl_controllerWithIdentifier:@"MHLoPlotSltController" storyBoardName:@"MHLoSetPlotController"];
            vc.sltType = MHLoPlotSltTypeWithCommunity;
            if (indexPath.section == 0) {
                vc.currentCity = self.c_dataSource.mapCity;
            } else {
                vc.currentCity = self.c_dataSource.dataSource[indexPath.item];
            }
            vc.callBack = ^(MHCityModel *city, MHCommunityModel *community) {
                [self.navigationController popViewControllerAnimated:NO];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.callBack) self.callBack(city, community);
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if (indexPath.section == 0) {  self.callBack(self.c_dataSource.mapCity, nil);
            } else { self.callBack(self.c_dataSource.dataSource[indexPath.item], nil);  }
        }
    }];
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //                              TableView Callbacks
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    [self.t_dataSource.resultSubject subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        NSArray *datas ;
        if (indexPath.section == 0) {
            if ([self.textField.text hl_isEmpty])  datas = [self.t_dataSource.hotPlots copy];
            else datas = [self.t_dataSource.searchPlots copy];
        } else {  datas = [self.t_dataSource.allPlots copy] ; }
        MHCommunityModel * community = datas[indexPath.row];
        
        if (self.sltType == MHLoPlotSltTypeVol) { // 志愿者申请流程逻辑
            
            if (community.is_has_room) { //  有房间号
                self.currentCity.city_name = community.city_name;
                self.callBack(self.currentCity, community);
                [self.navigationController popViewControllerAnimated:YES];
            }else {    // 无房间号
                MHVoAddressAddController *vc = [[MHVoAddressAddController alloc] init];
                vc.communityName = community.community_name;
                vc.cityName = community.city_name;
                
                vc.confirmBlock = ^(NSString *room_info) {
                    for (MHVoDataFillController *dataFillVC in self_weak_.navigationController.childViewControllers) {
                        if ([dataFillVC isKindOfClass:[MHVoDataFillController class]]) {
                            dataFillVC.room_info = room_info;
                            [self_weak_.navigationController popToViewController:dataFillVC animated:YES];
                        }
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
 
        }else {
            self.currentCity.city_name = community.city_name;
            self.callBack(self.currentCity, community);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - request

- (void)loadNewData {
    _pageId = 0 ;
    MHWeakify(self)
    __block BOOL flag = NO;
    /// hot  热门城市
    [MHLoginRequestHandler postHotPlotListWithCityName:self.currentCity.city_name success:^(NSArray *plots) {
        MHStrongify(self)
        self.t_dataSource.hotPlots = [plots copy];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        if (flag) {
            [self.tableView.mj_header endRefreshing];
            [self plotsDataSourceRestTableViewFooter];
        } else {
            flag = YES;
        }
        // 只有选择城市的情况（MHLoPlotSltTypeChooseCommunity） 才在这里停止刷新
        if (self.sltType == MHLoPlotSltTypeChooseCommunity)[self.tableView.mj_header endRefreshing];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
    // 选择小区除外，就会拿所有小区的数据
    if (self.sltType != MHLoPlotSltTypeChooseCommunity) {
        /// all
        [MHLoginRequestHandler searchPlotListWithCityName:self.currentCity.city_name keyword:nil page_id:[NSNumber numberWithInteger:_pageId] success:^(NSArray *plots) {
            MHStrongify(self)
            [self.t_dataSource.allPlots removeAllObjects];
            self.t_dataSource.allPlots = [NSMutableArray arrayWithArray:plots];
            [self.tableView reloadData];
            if (flag) {
                [self.tableView.mj_header endRefreshing];
                [self plotsDataSourceRestTableViewFooter];
            } else {
                flag = YES;
            }
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
    [MHLoginRequestHandler searchPlotListWithCityName:self.currentCity.city_name keyword:key page_id:page success:^(NSArray *plots) {
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
            [self.collectionView reloadData];
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
          [self.collectionView reloadData];
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
         if (self.sltType == MHLoPlotSltTypeWithCommunity) {
             [MHLoginRequestHandler
              searchPlotListWithCityName:self.currentCity.city_name
              keyword:keyword page_id:nil
              success:^(NSArray *plots) {
                  self.t_dataSource.searchPlots = [NSMutableArray arrayWithArray:plots];
                  [self.tableView reloadData];
                  if (plots.count) {
                      self.tableView.tableFooterView = [UIView new];
                  } else {
                      self.tableView.mj_footer = nil;
                      self.tableView.tableFooterView = [MHLoSelectPlotFootView initFootViewWithExperienceCommunityButton:^{
                          MHCityModel *city = [MHCityModel cityWithName:@"武汉"];
                          MHCommunityModel *model = [[MHCommunityModel alloc]init];
                          model.community_id = @10086;
                          model.community_name = @"体验小区";
                          [self.navigationController popViewControllerAnimated:NO];
                          [self.navigationController popViewControllerAnimated:YES];
                          !self.callBack ?:self.callBack(city,model);
                      }];
                  }
                  [MHHUDManager dismiss];
              } failure:^(NSString *errmsg) {
                  [MHHUDManager dismiss];
                  [MHHUDManager showErrorText:errmsg];
              }];
         }
         else if (self.sltType == MHLoPlotSltTypePlot || self.sltType == MHLoPlotSltTypeVol) {
             [MHLoginRequestHandler
              searchPlotListWithCityName:self.currentCity.city_name
              keyword:keyword page_id:nil
              success:^(NSArray *plots) {
                  self.t_dataSource.searchPlots = [NSMutableArray arrayWithArray:plots];
                  [self.tableView reloadData];
                  if (plots.count) {
                      self.tableView.tableFooterView = [UIView new];
                  } else {
                      if (self.ctrType == MHLoPlotCtrTypeSome){
                          [self initTableFooterWithAddressAddView];
                      }
                      else
                      self.tableView.tableFooterView = [MHLoSelectPlotFootView initDefaultFootView];
                  }
                  [MHHUDManager dismiss];
              } failure:^(NSString *errmsg) {
                  [MHHUDManager dismiss];
                  [MHHUDManager showErrorText:errmsg];
              }];
         }else if (self.sltType == MHLoPlotSltTypeChooseCommunity){
             [MHLoginRequestHandler
              searchHotListWithCityName:self.currentCity.city_name
              keyword:keyword page_id:nil
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
         }
         
         else {}
     }];
}

- (void)initTableFooterWithAddressAddView{
    self.tableView.mj_footer = nil;
    @weakify(self);
    self.tableView.tableFooterView = [MHLoSelectPlotFootView initFootViewWithUserDefineButton:^{
        @strongify(self);
        MHVoAddressAddController * controller = [[MHVoAddressAddController alloc] init];
        controller.callBack = ^(MHCityModel *city, MHCommunityModel *community) {
            __block NSUInteger plotSltCount = 0;
            __block BOOL hasDataFillController = NO;
            
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *controller = NSStringFromClass([obj class]);
                if ([controller isEqualToString:@"MHVoDataFillController"]) {
                    hasDataFillController = YES;
                }
                if ([controller isEqualToString:@"MHLoPlotSltController"]) {
                    plotSltCount = idx;
                    *stop = YES;
                }
            }];
            if (hasDataFillController) {
                NSInteger index = plotSltCount-2;
                MHVoDataFillController *vc = self.navigationController.viewControllers[index];
                MHVolCreateModel *model = [MHVolCreateModel sharedInstance];
                model.address.city = city.city_name;
                model.address.community = community.community_name;
                model.address.room = community.community_address;
                vc.room_info = [NSString stringWithFormat:@"%@%@%@",city.city_name,community.community_name,community.community_address];
                [self.navigationController popToViewController:vc animated:YES];
            }else {
                NSDictionary *json = @{@"city":city.city_name,
                                       @"community":community.community_name,
                                       @"room":community.community_address};
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"kReloadVolSerMyCardControllerAddressNotification" object:json];
                
                [self.navigationController popToViewController:self.navigationController.viewControllers[plotSltCount-2] animated:YES];
            }
            
            self.callBack(city, community);
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

- (void)plotsDataSourceRestTableViewFooter{
    if (self.t_dataSource.hotPlots.count == 0 && self.t_dataSource.allPlots.count == 0 ) {
        if (self.sltType == MHLoPlotSltTypeCity||self.sltType == MHLoPlotSltTypeWithCommunity) {
            @weakify(self);
            self.tableView.tableFooterView = [MHLoSelectPlotFootView initFootViewWithNoDatasExperienceCommunityButton:^{
               @strongify(self);
                MHCityModel *city = [MHCityModel cityWithName:@"武汉"];
                MHCommunityModel *model = [[MHCommunityModel alloc]init];
                model.community_id = @10086;
                model.community_name = @"体验小区";
                [self.navigationController popViewControllerAnimated:NO];
                [self.navigationController popViewControllerAnimated:YES];
                !self.callBack ?:self.callBack(city,model);
            }];
        }else
        self.tableView.tableFooterView = [MHLoSelectPlotFootView initDefaultFootView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textField endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - Getter


- (MHCityModel *)currentCity {
    if (!_currentCity) {
        _currentCity = [MHCityModel cityModelFromUserInfo];
    } return _currentCity;
}

- (MHLoPlotSltCollectionDataSource *)c_dataSource {
    if (!_c_dataSource) {
        _c_dataSource = [MHLoPlotSltCollectionDataSource new];
    }
    return _c_dataSource;
}

- (MHLoPlotSltTableDataSource *)t_dataSource {
    if (!_t_dataSource) {
        _t_dataSource = [MHLoPlotSltTableDataSource new];
    }
    return _t_dataSource;
}

@end
