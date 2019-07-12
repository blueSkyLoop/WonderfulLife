//
//  MHReportRepairTypeViewController.m
//  WonderfulLife
//
//  Created by zz on 17/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairTypeViewController.h"
#import "MHReportRepairNewViewController.h"
#import "MHReportRepairTypeCell.h"

#import "Masonry.h"
#import "MHReportRepairTypeViewModel.h"
#import "MHReportRepairTypeModel.h"
#import "MHReportRepairNewModel.h"

static NSString *const kMHReportRepairTypeCell = @"MHReportRepairTypeCell";
static CGFloat   const kMHReportRepairTypeCellRowHeight = 56.f;
static CGFloat   const kMHReportRepairTypeCellSectionHeaderHeight = 16.f;
static CGFloat   const kMHReportRepairTypeCellSectionNumber = 1;

@interface MHReportRepairTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MHReportRepairTypeViewModel *viewModel;
@end

@implementation MHReportRepairTypeViewController


#pragma mark - Life Cycle

- (void)dealloc {
    [self.selectedArray removeAllObjects];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = self.selectedArray.lastObject?self.selectedArray.lastObject:@"选择类型";
    [self setNaviBottomLineDefaultColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)bindViewModel {
    _viewModel = [MHReportRepairTypeViewModel new];
    
    @weakify(self)
    [[self.viewModel.repairTypeCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.viewModel.dataSource = x;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        [MHHUDManager showErrorText:error.userInfo[@"errmsg"]];
    }];
    
    [self.viewModel.repairTypeSubitemsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.viewModel.dataSource = x;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        [MHHUDManager showErrorText:error.userInfo[@"errmsg"]];
    }];
    
    if (!self.isRepeatEnter) {
        [self.viewModel.repairTypeCommand execute:nil];
    }else{
        [self.viewModel.repairTypeSubitemsCommand execute:self.repairment_category_id];
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kMHReportRepairTypeCellSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHReportRepairTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kMHReportRepairTypeCell];
    [cell bindViewModel:self.viewModel.dataSource[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kMHReportRepairTypeCellSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMHReportRepairTypeCellRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MHReportRepairTypeModel *model = self.viewModel.dataSource[indexPath.row];
    [self.selectedArray addObject:model.repairment_category_name];
    if ([model.has_next boolValue]) {
        [MHReportRepairNewModel share].is_indoor = [model.is_indoor boolValue];
        MHReportRepairTypeViewController *controller = [MHReportRepairTypeViewController new];
        controller.repairment_category_id = model.repairment_category_id;
        controller.selectedArray = self.selectedArray;
        controller.repeatEnter = YES;
        controller.listEnter = self.isListEnter;
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        
        if (self.isListEnter) {
            [self.navigationController pushViewController:[MHReportRepairNewViewController new] animated:YES];
        }else {
            [self.navigationController popToViewController:[self getTheAdditionController] animated:YES];
        }
        NSDictionary *dic = @{@"room":[self combineTypeDictionaryFromSelectedArray],
                              @"roomid":model.repairment_category_id,
                              @"parent_id":model.parent_id,};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kMHReportRepairSelectedType" object:dic];
    }
}

- (NSString*)combineTypeDictionaryFromSelectedArray {
    NSMutableArray *resultArray = [self.selectedArray mutableCopy];
    NSString *selectedType = resultArray.firstObject;
    [resultArray removeObject:selectedType];
    for (NSString *obj in resultArray) {
        selectedType = [selectedType stringByAppendingFormat:@"-%@",obj];
    }
    return selectedType;
}

- (UIViewController*)getTheAdditionController {
    NSArray *controllers = self.navigationController.viewControllers;
    int index = 0;
    for (int i = 0; i<controllers.count; i ++) {
        UIViewController *controller = controllers[i];
        if ([controller isKindOfClass:[MHReportRepairNewViewController class]]) {
            index = i;
            break;
        }
    }
    return self.navigationController.viewControllers[index];
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = MColorBackgroud;
        [_tableView registerNib:[UINib nibWithNibName:kMHReportRepairTypeCell bundle:nil] forCellReuseIdentifier:kMHReportRepairTypeCell];
    }
    return _tableView;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
