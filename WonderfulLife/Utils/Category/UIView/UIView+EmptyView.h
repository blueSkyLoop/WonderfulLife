//
//  UIView+EmptyView.h
//  JFCommunityCenter
//
//  Created by liyanzhao on 17/3/2.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JFEmptyViewButtonCallBack)(void);

@interface UIView (EmptyView)

@property (nonatomic, strong) UIView *emptyView;
#pragma mark - add

- (void )mh_addEmptyViewTitle:(NSString *)title;
- (void )mh_addEmptyViewImageName:(NSString *)imageName;
- (void )mh_addEmptyViewImageName:(NSString *)imageName title:(NSString *)title;

- (void)mh_setEmptyCenterYOffset:(CGFloat)offset;


///含按钮
- (void )mh_addEmptyViewImageName:(NSString *)imageName
                                          title:(NSString *)title
                                     centerMove:(CGPoint)centerMove
                                    buttonTitle:(NSString *)buttonTitle
                                       callBack:(JFEmptyViewButtonCallBack)callback;
- (void )mh_addEmptyViewImageName:(NSString *)imageName
                                          title:(NSString *)title
                                    buttonTitle:(NSString *)buttonTitle
                                       callBack:(JFEmptyViewButtonCallBack)callback;

#pragma mark - remove
- (void)mh_removeEmptyView;
@end
