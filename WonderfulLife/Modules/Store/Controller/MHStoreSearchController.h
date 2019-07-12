//
//  MHStoreSearchController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHStoreController;
@interface MHStoreSearchController : UIViewController <UISearchResultsUpdating>
@property (nonatomic,weak) MHStoreController *storeVC;
@property (nonatomic,weak) UISearchController *searchVC;
@end
