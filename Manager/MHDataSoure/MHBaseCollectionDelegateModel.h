//
//  MHBaseCollectionDelegateModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

//选中某一行的回调，indexPath 行位置 cellModel这个行所要显示的数据
typedef void(^collectionViewDidSelectBlock)(NSIndexPath *indexPath,id cellModel);

@interface MHBaseCollectionDelegateModel : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak)UICollectionView *weakCollectionView;

@property (nonatomic,strong)NSMutableArray *dataArr;

//必须是实现了MHCellConfigDelegate协议的cell名称
@property (nonatomic,strong,readonly)NSArray <NSString *> *cellClassNames;

//选中某一行的回调，indexPath 行位置 cellModel这个行所要显示的数据
@property (nonatomic,copy)collectionViewDidSelectBlock mh_collectionViewDidSelectBlock;

//获取该下标要显示的数据模型 ,不实现，则默认dataArr[indexPath.row]
@property (nonatomic,copy)id(^mh_collectionViewRowDataBlock)(NSIndexPath *indexPath);

//加载每一个cell的时候，会在返回cell前回调，外部可以获取这个cell作处理,只能改变UI，不能改变cell对应的数据
@property (nonatomic,copy)void(^mh_collectionViewRowCellBlock)(NSIndexPath *indexPath,UICollectionViewCell<MHCellConfigDelegate> *acell);

//获取cell 下标的cell类，cellClassNames里存放的类型，不实现默认取cellClassNames里的第一个
@property (nonatomic,copy)Class(^mh_collectionViewRowCellClassIndexBlock)(NSIndexPath *indexPath);

//获取section 下标的cell个数，一般用在组中，默认为dataArr.count
@property (nonatomic,copy)NSInteger(^mh_collectionViewRowsNumBlock)(NSInteger section);

//获取有多少个组，默认为1
@property (nonatomic,copy)NSInteger(^mh_collectionViewSectionNumBlock)(void);

//NSArray 存放实现了MHCellConfigDelegate协议的有xib的类名  classCellNames 存放实现了MHCellConfigDelegate协议的类名
+ (UICollectionView *)createCollectionViewWithLayout:(UICollectionViewLayout *)layout rigistNibCellNames:(NSArray <NSString *> *)nibCellNames rigistClassCellNames:(NSArray <NSString *> *)classCellNames;

/*
 基类实现了@required修饰的代理和点击回调的代理 如果子类还有其它要求，请实现其它代理,或者可以再次实现 ，也可以通过实现相关Block来实现
 */
- (id)initWithDataArr:(NSMutableArray *)dataArr collectionView:(UICollectionView *)collectionView cellClassNames:(NSArray <NSString *> *)cellClassNames cellDidSelectedBlock:(collectionViewDidSelectBlock)selectedBlock;

//要实现以上Block  最好在此方法实现,可以不调super ，因为基类里没有实现任何东西
- (void)mh_delegateConfig;

@end
