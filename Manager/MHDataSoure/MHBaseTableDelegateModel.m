//
//  MHBaseTableDelegateModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseTableDelegateModel.h"

#import "UITableView+FDTemplateLayoutCell.h"

@interface MHBaseTableDelegateModel()

@property (nonatomic,strong,readwrite)NSArray <NSString *> *cellClassNames;

//是否使用ios8中的系统自动布局  默认为NO
@property (nonatomic,assign,readwrite)BOOL useAutomaticDimension;

@property (nonatomic,strong,readwrite)NSMutableDictionary *respondDict;

@end

@implementation MHBaseTableDelegateModel
//nibCellNames 存放实现了MHCellConfigDelegate协议的有xib的类名  classCellNames 存放实现了MHCellConfigDelegate协议的类名
+ (UITableView *)createTableWithStyle:(UITableViewStyle)style rigistNibCellNames:(NSArray <NSString *> *)nibCellNames rigistClassCellNames:(NSArray <NSString *> *)classCellNames{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    for(NSString *className in nibCellNames){
        [tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    }
    for(NSString *className in classCellNames){
        [tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
    return tableView;
}


#if DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif

- (id)initWithDataArr:(NSMutableArray *)dataArr tableView:(UITableView *)tableView cellClassNames:(NSArray <NSString *> *)cellClassNames useAutomaticDimension:(BOOL)useAutomaticDimension cellDidSelectedBlock:(tableViewDidSelectBlock)selectedBlock{
    self = [super init];
    if(self){
        tableView.dataSource = self;
        tableView.delegate = self;
        self.useAutomaticDimension = useAutomaticDimension;
        self.dataArr = dataArr;
        self.cellClassNames = [cellClassNames mutableCopy];
        self.mh_tableViewDidSelectBlock = [selectedBlock copy];
        self.weakTableView = tableView;
        [self mh_delegateConfig];

    }
    return self;
}



#pragma mark - tableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.mh_tableViewSectionNumBlock){
        return self.mh_tableViewSectionNumBlock();
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.mh_tableViewRowsNumBlock){
        return self.mh_tableViewRowsNumBlock(section);
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_useAutomaticDimension) return UITableViewAutomaticDimension;
    
    id cellModel = [self cellModelWithIndexPath:indexPath];
    Class aclass = [self cellClassWithIndexPath:indexPath];
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(aclass) cacheByIndexPath:indexPath configuration:^(UITableViewCell<MHCellConfigDelegate> *cell) {
        [cell mh_configCellWithInfor:cellModel];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class aclass = [self cellClassWithIndexPath:indexPath];
    UITableViewCell<MHCellConfigDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(aclass)];
    [cell mh_configCellWithInfor:[self cellModelWithIndexPath:indexPath]];
    if(self.mh_tableViewRowCellBlock){
        self.mh_tableViewRowCellBlock(indexPath,cell);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.mh_tableViewDidSelectBlock){
        self.mh_tableViewDidSelectBlock(indexPath,[self cellModelWithIndexPath:indexPath]);
    }
}

#pragma mark - method
- (id)cellModelWithIndexPath:(NSIndexPath *)indexPath{
    id cellModel;
    //外部可实现此block 自定义传数据进来
    if(self.mh_tableViewRowDataBlock){
        cellModel = self.mh_tableViewRowDataBlock(indexPath);
    }else{
        cellModel = self.dataArr[indexPath.row];
    }
    return cellModel;
}

- (Class)cellClassWithIndexPath:(NSIndexPath *)indexPath{
    Class cellClass;
    //外部可实现此block 自定义类型传进来
    if(self.mh_tableViewRowCellClassIndexBlock){
        Class aclass = self.mh_tableViewRowCellClassIndexBlock(indexPath);
        if([self.cellClassNames containsObject:NSStringFromClass(aclass)]){
            cellClass = aclass;
        }else{
            NSAssert(NO, @"此类未注册");
        }
    }else{
        cellClass = NSClassFromString([self.cellClassNames firstObject]);
        
    }
    NSAssert(cellClass, @"获取到的cell不能为空");
#if DEBUG
    if(![[self.respondDict valueForKey:NSStringFromClass(cellClass)] boolValue]){
        BOOL flag = [cellClass instancesRespondToSelector:@selector(mh_configCellWithInfor:)];
        [self.respondDict setValue:@(flag) forKey:NSStringFromClass(cellClass)];
        if(!flag){
            NSString *errorMessage = [NSString stringWithFormat:@"%@ %@",NSStringFromClass(cellClass),@"必须实现MHCellConfigDelegate协议"];
            NSAssert(NO, errorMessage);
        }
    }
#endif
    return cellClass;
}

- (void)mh_delegateConfig{
    
}

- (NSMutableDictionary *)respondDict{
    if(!_respondDict){
        _respondDict = [NSMutableDictionary dictionary];
    }
    return _respondDict;
}

@end
