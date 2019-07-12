//
//  MHLoPlotSltController.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  所在城市 | 所在小区

/**
  MHLoPlotSltController 类优化部分代码
 
  新增类:
  * MHLoPlotSltTableDataSource
  * MHLoPlotSltCollectionDataSource
  * MHLoSelectPlotFootView

    ********************** Data Source *********************
    MHLoPlotSltTableDataSource和MHLoPlotSltCollectionDataSource参照【我的资料卡】-【需要帮助】类，
    将TableView和CollectionView代理方法从原来的代码剥离，独立处理界面的显示与事件回调。

    ********************** Footer View *********************
    MHLoSelectPlotFootView主要用来无搜索结果的界面显示，利用NSBundle的数组来简化界面的编写，目前主要有三种界面：
    * 小区暂未开通服务
    * 自定义住址
    * 体验小区

    ********************** ENUM Type *********************
    新增枚举MHLoPlotSltTypeWithCommunity，用来处理注册页面跳转，选择小区-搜索时，无结果显示体验小区，首页原来使用
    MHLoPlotSltTypeCity跳转，暂无其他地方用到枚举MHLoPlotSltTypeCity，故在代码修改成无搜索结果显示体验小区。至于
    添加新枚举MHLoPlotSltTypeWithCommunity是为了以后迭代维护要作为一个跳转的标准。原来定义不是很清晰。
 
  网络层暂无构思，因部分逻辑暂未清楚......
*/
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHLoPlotSltType) {
    MHLoPlotSltTypeChooseCommunity,     //选择小区
    MHLoPlotSltTypeCity,                //所在城市 (目前只有【首页】用到，带无搜索结果显示体验小区)
    MHLoPlotSltTypeCertifi,             //住户认证跳入
    MHLoPlotSltTypePlot,                //所在小区
    MHLoPlotSltTypeWithCommunity,       //带体验小区(目前只有【注册】用到，带无搜索结果显示体验小区)
    MHLoPlotSltTypeVol                   // 志愿者资料申请
};

typedef NS_ENUM(NSUInteger, MHLoPlotCtrType) { // 是否添加 “添加住址”的footerView ，用于搜索无结果时
    MHLoPlotCtrTypeNormal, // 不显示
    MHLoPlotCtrTypeSome,   // 显示    
};

@class MHCityModel,MHCommunityModel;

typedef void(^MHLoPlotCallBack)(MHCityModel *city,MHCommunityModel *community);

@interface MHLoPlotSltController : UIViewController
@property (assign,nonatomic) MHLoPlotSltType sltType;
@property (assign,nonatomic) MHLoPlotCtrType ctrType;
@property (strong,nonatomic) MHCityModel *currentCity;
@property (copy  ,nonatomic) MHLoPlotCallBack callBack;
@end
