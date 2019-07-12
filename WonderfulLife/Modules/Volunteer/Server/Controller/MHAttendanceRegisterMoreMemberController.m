//
//  ViewController.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "MHAttendanceRegisterMoreMemberController.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHNavigationControllerManager.h"
#import "MHVoAttendanceRegisterModel.h"
#import "MHVoRegisOhterMemberCell.h"
#import "ReactiveObjC.h"
#import "MHConst.h"
#import "UIImage+Color.h"

@interface MHAttendanceRegisterMoreMemberController ()
<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate,MHNavigationControllerManagerProtocol>
{
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UISearchBar *searchBar;//搜索框
@property (nonatomic,strong) UILabel *bottomLabel;
@property (nonatomic,strong) UIView *tableFooterView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic,assign) NSInteger count;

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
static NSString *const MHVoRegisOhterMemberCellID = @"MHVoRegisOhterMemberCellID";

@implementation MHAttendanceRegisterMoreMemberController{
    NSMutableArray *_searchResultArr;//搜索结果Arr
    BOOL isSearching;
}

- (BOOL)bb_ShouldBack{
    [[NSNotificationCenter defaultCenter] postNotificationName:MHVoRegisterAttendanceControllerReloadNotification object:nil];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择其他成员";
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //布局View
    [self setUpView];
    
    _searchResultArr=[NSMutableArray array];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)setModel:(MHVoAttendanceRegisterModel *)model{
    _model = model;
    
    self.dataArr=[NSMutableArray array];
    [self.dataArr addObjectsFromArray:_model.not_apply];
    _count = _model.selected_not_apply.count;
    
    _rowArr=[ContactDataHelper getFriendListDataBy:self.dataArr];
    _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
}

- (void)setCount:(NSInteger)count{
    _count = count;
    _bottomLabel.text = [NSString stringWithFormat:@"已选择成员 %zd 人",count];
    [_bottomLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarWhite];
}

#pragma mark - setUpView
- (void)setUpView{
    UIView *bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-64, kScreenWidth, 64)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.alpha = 0.88;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = MColorSeparator;
    [bottomView addSubview:line];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = [NSString stringWithFormat:@"已选择成员 %zd 人",_count];
    bottomLabel.font = [UIFont systemFontOfSize:16];
    bottomLabel.textColor = MColorTitle;
    [bottomLabel sizeToFit];
    bottomLabel.center = CGPointMake(MScreenW/2, 32);
    [bottomView addSubview:bottomLabel];
    _bottomLabel = bottomLabel;
    [self.view insertSubview:self.tableView belowSubview:bottomView];
    [self.view addSubview:self.searchBar];
    

}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(8, 64, kScreenWidth-24, 36)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarBackground"] forState:UIControlStateNormal];
        [_searchBar setPlaceholder:@"输入成员名称搜索"];
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setValue:MColorFootnote2 forKeyPath:@"_placeholderLabel.textColor"];
            searchField.textColor = MColorTitle;

        }
        [_searchBar sizeToFit];
        [_searchBar setDelegate:self];
        [_searchBar setKeyboardType:UIKeyboardTypeDefault];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _searchBar.nim_bottom+12.5, kScreenWidth, 0.5)];
        line.backgroundColor = MColorSeparator;
        [self.view addSubview:line];
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBar.nim_bottom+13, kScreenWidth, kScreenHeight-64-self.searchBar.nim_bottom) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
//        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 80;
        //cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setTableFooterView:v];
        [_tableView registerNib:[UINib nibWithNibName:@"MHVoRegisOhterMemberCell" bundle:nil] forCellReuseIdentifier:MHVoRegisOhterMemberCellID];
    }
    return _tableView;
}

- (UIView *)tableFooterView{
    if (_tableFooterView == nil) {
        _tableFooterView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        _tableFooterView.backgroundColor = MColorDidSelectCell;
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:17];
        _label.textColor = MColorFootnote2;
        _label.text = @"输入名字搜索成员";
        [_label sizeToFit];
        _label.nim_top = 32;
        _label.nim_centerX = MScreenW/2;
        [_tableFooterView addSubview:_label];
        
    }
    return _tableFooterView;
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //section
    if (isSearching) {
        if (_searchResultArr.count) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return _rowArr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //row
    if (isSearching) {
        return _searchResultArr.count;
    }else{
        return [_rowArr[section] count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    if (isSearching == NO) {
        id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        if (!label) {
            label = [[UILabel alloc] init];
            
            if (iOS8) {
                [label setFont:[UIFont systemFontOfSize:16]];
            }else{
                [label setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
            }
            [label setTextColor:MColorTitle];
            [label setBackgroundColor:[UIColor whiteColor]];
        }
        [label setText:[NSString stringWithFormat:@"   %@",_sectionArr[section+1]]];
        return label;
    }else{
        return nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (isSearching == NO) {
        return _sectionArr;
    }else{
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isSearching == NO) {
        return 32;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVoAttendanceRecordDetailCrewModel *crewModel;
    if (isSearching) {
        crewModel = _searchResultArr[indexPath.row];
    }else{
        crewModel = _rowArr[indexPath.section][indexPath.row];
    }
    MHVoRegisOhterMemberCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (crewModel.selected) {
        cell.selectedImageView.highlighted = NO;
        crewModel.selected = NO;
        self.count --;
        [_model.selected_not_apply removeObject:crewModel];
        return;
    }else{
        cell.selectedImageView.highlighted = YES;
        crewModel.selected = YES;
        self.count ++;
        [_model.selected_not_apply addObject:crewModel];
    }
    
}


#pragma mark - UITableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVoRegisOhterMemberCell *cell=[tableView dequeueReusableCellWithIdentifier:MHVoRegisOhterMemberCellID];
    if (isSearching){
        MHVoAttendanceRecordDetailCrewModel *crewModel = _searchResultArr[indexPath.row];
        cell.crewModel = crewModel;
    }else{
        MHVoAttendanceRecordDetailCrewModel *crewModel = _rowArr[indexPath.section][indexPath.row];
        cell.crewModel = crewModel;

    }
    
    return cell;
}

#pragma mark searchBar delegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    isSearching = YES;
    NSLog(@"%@--%@",searchBar.text,searchText);
    [self filterContentForSearchText:searchText
                               scope:[searchBar scopeButtonTitles][searchBar.selectedScopeButtonIndex]];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    isSearching = YES;
    if (_searchResultArr.count==0) {
        self.tableView.tableFooterView = self.tableFooterView;
    }else{
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length) {

    }else{
        isSearching = NO;
        self.tableView.tableFooterView = nil;
        [self.tableView reloadData];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    isSearching = NO;
    self.tableView.tableFooterView = nil;
    [self.tableView reloadData];
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        NSString *storeString = [(MHVoAttendanceRecordDetailCrewModel *)self.dataArr[i] volunteer_name];
        if ([storeString containsString:searchText]) {
            [tempResults addObject:self.dataArr[i]];

        }
        
    }
    [_searchResultArr removeAllObjects];
    [_searchResultArr addObjectsFromArray:tempResults];
    if (_searchResultArr.count) {
        self.tableView.tableFooterView = nil;
    }else{
        if (searchText.length) {
            _label.text = @"没有符合条件的搜索结果";
        }else{
            _label.text = @"输入名字搜索成员";
        }
        [_label sizeToFit];
        _label.nim_centerX = MScreenW/2;
        self.tableView.tableFooterView = self.tableFooterView;
    }
    [self.tableView reloadData];
}

@end
