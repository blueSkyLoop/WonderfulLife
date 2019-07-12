//
//  HLWebViewController.m
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/25.
//  Copyright © 2016年 com.cn. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "HLWebViewController.h"
#import "MHNavigationControllerManager.h"

//#import "HLNavigationPopProtocol.h"

@interface HLWebViewController ()<WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate,MHNavigationControllerManagerProtocol>

///MARK - public property
@property (nonatomic)WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;
@property(strong,nonatomic)UIButton *closedButton;
///MARK - private property
@property (nonatomic)NSString* url;
@property (nonatomic, assign) NSUInteger loadCount;
@property (nonatomic, assign) HLWebViewType webType;
@end



@implementation HLWebViewController
@synthesize progressTintColor = _progressTintColor,
closedButtonTitle = _closedButtonTitle,
closedButtonColor = _closedButtonColor;

#pragma mark - public funcs

-(instancetype)initWithUrl:(NSString *)url {
 return [self initWithUrl:url webType:HLWebViewTypeNormal];
}

- (instancetype)initWithUrl:(NSString *)url webType:(HLWebViewType)type {
    if (self = [super init]) {
        self.url = url;
        self.webType = type ;
    }return self ;
}

-(void)reloadWebView {
    [self.webView reload];
}



#pragma mark - super funcs

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.view addSubview:self.progressView];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    if (!self.hiddenClosedButton) {
        [self.navigationController.navigationBar addSubview:self.closedButton];
    }
    //modify by Lance 2017.11.27  缓存策略改为不使用缓存 ，原因：如果之前请求过一次，则本地有缓存，如果html5内容变更，一定会命中本地缓存,则无法再次获取得到最新内容，所以不使用缓存
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.f]];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



#pragma mark  - kvo

- (void)observeValueForKeyPath:(NSString* )keyPath ofObject:(id)object change:(NSDictionary* )change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}



#pragma mark - update nav items

-(void)updateNavigationItems {
    if(self.webView.canGoBack) {
        self.closedButton.hidden = NO;
    } else {
        self.closedButton.hidden = YES;
    }
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)bb_ShouldBack{
    UINavigationController *nav = self.navigationController;
    if ([nav.viewControllers.lastObject class] == [HLWebViewController class]) {
        [self updateNavigationItems];
        
        if (self.webType == HLWebViewTypeH5CanBack) {
            [self closeEvent];
            return YES;
        }
        
        if (self.webView.canGoBack) {
            [self.webView goBack];
            return NO;
        }else {
            [self closeEvent];
            return YES;
        }
    }
    return YES;
}

#pragma mark - events handler

-(void)closeEvent {
    [self.closedButton removeFromSuperview];
    //    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.loadCount ++;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

//加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
    
}

// 内容返回时
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadCount --;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    self.loadCount --;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    [self updateNavigationItems];
}



#pragma mark - WKUIDelegate

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}



#pragma mark - setters and getters

-(void)setUrl:(NSString *)url {
    NSString * http = @"http://";
    NSRange httpRange = [url rangeOfString:http];
    
    NSString * https = @"https://";
    NSRange httpsRange = [url rangeOfString:https];
    
    if (httpRange.location == NSNotFound&&httpsRange.location == NSNotFound)
    {
        _url = [NSString stringWithFormat:@"http://%@",url];
    }
    else{
        _url = url;
    }
}

- (void)setTitle:(NSString *)title {
    if (title.length == 0) {
        super.title = @"网页";
    } else if (title.length>10) {
        super.title = [title stringByReplacingCharactersInRange:NSMakeRange(9, title.length-9) withString:@"..."];
    } else {
        super.title = title;
    }
}

- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

-(WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) configuration:config];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

-(UIButton *)closedButton {
    if (_closedButton == nil) {
        _closedButton = [[UIButton alloc]initWithFrame:CGRectMake(70, 0, 45, 44)];
        [_closedButton setTitle:self.closedButtonTitle forState:UIControlStateNormal];
        [_closedButton setTitleColor:self.closedButtonColor forState:UIControlStateNormal];
        _closedButton.titleLabel.contentMode = UIViewContentModeLeft;
        _closedButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_closedButton addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
        _closedButton.hidden = YES;
    } return _closedButton;
}

-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 1.5)];
        _progressView.progressTintColor = self.progressTintColor;
        _progressView.backgroundColor= [UIColor clearColor];
        _progressView.trackTintColor= [UIColor clearColor];
    } return _progressView;
}

///MARK -
- (UIColor *)progressTintColor {
    if (_progressTintColor == nil) {
        _progressTintColor = [UIColor grayColor];
    } return _progressTintColor;
}
- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    self.progressView.progressTintColor = progressTintColor;
}

- (NSString *)closedButtonTitle {
    if (_closedButtonTitle == nil) {
        _closedButtonTitle = @"关闭";
    } return _closedButtonTitle;
}
- (void)setClosedButtonTitle:(NSString *)closedButtonTitle {
    _closedButtonTitle = closedButtonTitle;
    [self.closedButton setTitle:closedButtonTitle forState:UIControlStateNormal];
}

- (UIColor *)closedButtonColor {
    if (_closedButtonColor == nil) {
        _closedButtonColor = [UIColor blueColor];
    } return _closedButtonColor;
}
- (void)setClosedButtonColor:(UIColor *)closedButtonColor {
    _closedButtonColor = closedButtonColor;
    [self.closedButton setTitleColor:closedButtonColor forState:UIControlStateNormal];
}
@end


