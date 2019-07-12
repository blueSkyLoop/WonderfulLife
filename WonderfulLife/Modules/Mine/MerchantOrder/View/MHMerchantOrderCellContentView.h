//
//  MHMerchantOrderCellContentView.h
//  WonderfulLife
//
//  Created by zz on 24/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHMerchantOrderCellContentView;
@protocol MHMerchantOrderCellContentDelegate <NSObject>

- (void)cellContentViewShouldHideDeleteOnSwipe:(MHMerchantOrderCellContentView*)view;
- (void)cellContentViewDidSelectedView:(MHMerchantOrderCellContentView*)view;
- (void)cellContentViewDidDeleteButtonView:(MHMerchantOrderCellContentView*)view;

@end
@interface MHMerchantOrderCellContentView : UIView
@property (strong, nonatomic) UIImageView *goodsImageView;
@property (strong, nonatomic) UILabel *goodsOrderTitle;
@property (strong, nonatomic) UILabel *goodsOrderNumber;
@property (strong, nonatomic) UILabel *goodsOrderExpiryDate;
@property (assign, nonatomic) BOOL isShowDeleteButton;
@property (strong, nonatomic) UIView *buttonView; //删除按钮的View，暴露在头文件，便于superview根据状态改变颜色
@property (assign, nonatomic,getter=isCellStateRight) BOOL cellStateRight;

@property (strong, nonatomic) UITapGestureRecognizer *deleteTap;
@property (strong, nonatomic) UITapGestureRecognizer *contentViewTap;

//@property (strong, nonatomic)  UIButton *goodsOrderDeleteButton;
@property (weak, nonatomic) id<MHMerchantOrderCellContentDelegate> contentDelegate;
//hidden delete button view
- (void)hideDeleteButtonAnimated:(BOOL)animated;
@end
