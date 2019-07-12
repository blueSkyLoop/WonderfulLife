//
//  MHBaseTableDelegateModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

//选中某一行的回调，indexPath 行位置 cellModel这个行所要显示的数据
typedef void(^tableViewDidSelectBlock)(NSIndexPath *indexPath,id cellModel);

@interface MHBaseTableDelegateModel : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *weakTableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

//是否使用ios8中的系统自动布局  要通过initWithDataArr 方法传值 YES 则采用系统自动计算高度，但没有缓存，每次都要重新计算高度  NO 则采用UITableView+FDTemplateLayoutCell第三方库来自动计算高度并缓存
@property (nonatomic,assign,readonly)BOOL useAutomaticDimension;

//必须是实现了MHCellConfigDelegate协议的cell名称
@property (nonatomic,strong,readonly)NSArray <NSString *> *cellClassNames;

//选中某一行的回调，indexPath 行位置 cellModel这个行所要显示的数据
@property (nonatomic,copy)tableViewDidSelectBlock mh_tableViewDidSelectBlock;

//获取该下标要显示的数据模型 ,不实现，则默认dataArr[indexPath.row]
@property (nonatomic,copy)id(^mh_tableViewRowDataBlock)(NSIndexPath *indexPath);

//加载每一个cell的时候，会在返回cell前回调，外部可以获取这个cell作处理,只能改变UI，不能改变cell对应的数据
@property (nonatomic,copy)void(^mh_tableViewRowCellBlock)(NSIndexPath *indexPath,UITableViewCell<MHCellConfigDelegate> *acell);

//获取cell 下标的cell类，cellClassNames里存放的类型，不实现默认取cellClassNames里的第一个
@property (nonatomic,copy)Class(^mh_tableViewRowCellClassIndexBlock)(NSIndexPath *indexPath);

//获取section 下标的cell个数，一般用在组中，默认为dataArr.count
@property (nonatomic,copy)NSInteger(^mh_tableViewRowsNumBlock)(NSInteger section);

//获取有多少个组，默认为1
@property (nonatomic,copy)NSInteger(^mh_tableViewSectionNumBlock)(void);

//NSArray 存放实现了MHCellConfigDelegate协议的有xib的类名  classCellNames 存放实现了MHCellConfigDelegate协议的类名
+ (UITableView *)createTableWithStyle:(UITableViewStyle)style rigistNibCellNames:(NSArray <NSString *> *)nibCellNames rigistClassCellNames:(NSArray <NSString *> *)classCellNames;

/*
 基类实现了@required修饰的代理和点击回调的代理 如果子类还有其它要求，请实现其它代理,或者可以再次实现 ，也可以通过实现相关Block来实现 useAutomaticDimension YES 则采用系统自动计算高度，但没有缓存，每次都要重新计算高度   NO 则采用UITableView+FDTemplateLayoutCell第三方库来自动计算高度并缓存（针对列表里面不会有操作导致cell高度实时变化的，如果有，则需要自己手动去掉缓存，比如点一下cell的某个按钮，然后某个label的内容增加，导致高度变化了，这种情况要手动删除缓存,这种情况比较少）
 */
- (id)initWithDataArr:(NSMutableArray *)dataArr tableView:(UITableView *)tableView cellClassNames:(NSArray <NSString *> *)cellClassNames useAutomaticDimension:(BOOL)useAutomaticDimension cellDidSelectedBlock:(tableViewDidSelectBlock)selectedBlock;

//要实现以上Block  最好在此方法实现,可以不调super ，因为基类里没有实现任何东西
- (void)mh_delegateConfig;

@end
