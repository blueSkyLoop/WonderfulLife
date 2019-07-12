//
//  HLWebViewController.h
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/25.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HLWebViewController : UIViewController

typedef NS_ENUM(NSInteger, HLWebViewType){
    
    /** 普通模式*/
     HLWebViewTypeNormal = 0,
    
    /** H5 含有回返栏，原生返回按钮直接控制POP*/
    HLWebViewTypeH5CanBack = 1
};

/**
 *  get instance with url
 *
 *  @param url url
 *
 *  @return instance
 */
-(instancetype)initWithUrl:(NSString *)url;

- (instancetype)initWithUrl:(NSString *)url webType:(HLWebViewType)type;

/**
 *  reload webView
 */
-(void)reloadWebView;



#pragma mark - property

@property (nonatomic,strong,readonly) UIProgressView *progressView; // progressView line view
@property (strong,nonatomic) UIColor *progressTintColor; // progressView tintColor, default is grayColor

@property(strong,nonatomic,readonly)UIButton *closedButton; // button that close webView
@property(strong,nonatomic)UIColor *closedButtonColor; // close button title
@property(copy,nonatomic)NSString *closedButtonTitle; // close button title
@property(assign,nonatomic)BOOL hiddenClosedButton; // hidden close button always, default is NO

@end
