//
//  UIViewController+NaviBigTitle.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+NaviBigTitle.h"
#import <Masonry.h>
#import <objc/runtime.h>

#import "MHMacros.h"
#import "NSObject+isNull.h"
@interface UIViewController ()

/**
 *  backBlock
 */
@property (copy,nonatomic)  NaviBackBarItemBlock backBlock;


/**
 *  rightBarBlock
 */
@property (copy,nonatomic) NaviRightBarItemBlock rightBlock;
@end


@implementation UIViewController (NaviBigTitle)


#pragma mark - Setter

- (void)setBackBlock:(NaviBackBarItemBlock)backBlock{
    objc_setAssociatedObject(self, @selector(backBlock), backBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)setRightBlock:(NaviRightBarItemBlock)rightBlock{
    objc_setAssociatedObject(self, @selector(rightBlock), rightBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Getter

-(NaviBackBarItemBlock)backBlock{
    return objc_getAssociatedObject(self, @selector(backBlock));
}

- (NaviRightBarItemBlock)rightBlock{
    return objc_getAssociatedObject(self, @selector(rightBlock));
}


#pragma mark - SetUI
- (UIView *)mh_addNaviBigTitleViewWithTitle:(NSString *)title rightBarText:(NSString *)rightBarText BackBarItemBlock:(NaviBackBarItemBlock)backBarItemBlock RightBarItemBlock:(NaviRightBarItemBlock)rightBarItemBlock{
    
    
    CGFloat titleLabelHight = 48 ;
    
    UIView * naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MTopHight + titleLabelHight)];
    [self.view addSubview:naviView];
    
    UIButton *backBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(mh_backAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    self.backBlock = backBarItemBlock;
    
    
    if (![NSObject isNull:rightBarText]) {
        UIButton *rightBt  = [UIButton new];
        [naviView addSubview:rightBt];
        [rightBt setTitle:rightBarText forState:UIControlStateNormal];
        [rightBt setTitleColor:MColorTitle forState:UIControlStateNormal];
        [rightBt.titleLabel setFont:MFontTitle];
        [rightBt addTarget:self action:@selector(mh_rightAction) forControlEvents:UIControlEventTouchUpInside];
        rightBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(naviView).offset(30);
            make.width.equalTo(@36);
            make.height.equalTo(@24);
            make.right.equalTo(naviView).offset(-16);
        }];
                self.rightBlock = rightBarItemBlock;
    }
    
    UILabel *titleLB = [UILabel new];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.text = title;
    titleLB.textColor = MColorTitle ;
    titleLB.font = [UIFont systemFontOfSize:34.0];
    [naviView addSubview:titleLB];
    
    CGFloat magir = 24;
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:titleLabelHight]);
        make.top.equalTo(naviView).offset(64);
        make.centerX.equalTo(naviView);
        make.left.equalTo(naviView).offset(magir);
        make.right.equalTo(naviView).offset(-magir);
    }];
    
    return naviView;
}

#pragma mark - Event

- (void)mh_backAction{
    self.backBlock();
}



- (void)mh_rightAction{
    self.rightBlock();
    
}

@end
