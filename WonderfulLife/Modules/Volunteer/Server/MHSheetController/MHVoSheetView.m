//
//  MHAlertView.m
//  Sakura
//
//  Created by zz on 28/11/2017.
//  Copyright © 2017 ikrulala. All rights reserved.
//

#import "MHVoSheetView.h"
#import "UIView+MHAlertView.h"
#import "UIView+MHAutoLayout.h"
#import <Masonry/Masonry.h>
#import "MHMacros.h"

@interface MHVoAlertAction ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) MHAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(NSInteger index);
@end

@implementation MHVoAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(MHAlertActionStyle)style handler:(void (^)(NSInteger index))handler
{
    return [[self alloc]initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(MHAlertActionStyle)style handler:(void (^)(NSInteger index))handler
{
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
        _enabled = YES;
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    MHVoAlertAction *action = [[self class]allocWithZone:zone];
    action.title = self.title;
    action.style = self.style;
    return action;
}

@end

@interface MHVoSheetView ()

// text content View
@property (nonatomic, weak) UIView *textContentView;

@property (nonatomic, weak) UILabel *messageLabel;

// button content View
@property (nonatomic, weak) UIScrollView *buttonContentView;
@property (nonatomic, weak) UIView *sheetBaseContentView;
@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, weak) NSLayoutConstraint *buttonTopConstraint;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *actions;

@end

#define kAlertViewWidth 280
#define kContentViewEdge 15
#define kContentViewSpace 15

#define kTextLabelSpace  6

#define kButtonTagOffset 1000
#define kButtonSpace     0.5
#define KButtonHeight    59.5


@implementation MHVoSheetView

#pragma mark - init
#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configureProperty];
        
        [self addContentViews];
        
        [self addTextLabels];
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [self init]) {
        _messageLabel.text = message;
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    return [[self alloc]initWithTitle:title message:message];
}

#pragma mark - configure

- (void)configureProperty
{
    _clickedAutoHide = YES;
    self.backgroundColor = [UIColor clearColor];
    _alertViewWidth = kAlertViewWidth;
    _contentViewSpace = kContentViewSpace;
    
    _textLabelSpace = kTextLabelSpace;
    _textLabelContentViewEdge = kContentViewEdge;
    
    _buttonHeight = KButtonHeight;
    _buttonSpace = kButtonSpace;
    _buttonContentViewEdge = kContentViewEdge;
    _buttonContentViewTop = kContentViewSpace;
    _buttonCornerRadius = 4.0;
    _buttonFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
    _buttonDefaultBgColor = [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1];
    _buttonCancelBgColor = [UIColor colorWithRed:127/255.0 green:140/255.0 blue:141/255.0 alpha:1];
    _buttonDestructiveBgColor = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
    
    _buttons = [NSMutableArray array];
    _actions = [NSMutableArray array];
}


#pragma mark - add contentview

- (void)addContentViews
{
    UIView *sheetBaseContentView = [[UIView alloc]init];
    sheetBaseContentView.layer.cornerRadius = 8;
    sheetBaseContentView.clipsToBounds = YES;
    sheetBaseContentView.userInteractionEnabled = YES;
    sheetBaseContentView.backgroundColor = [UIColor colorWithRed:211/255.0 green:220/255.0 blue:230/255.0 alpha:1.0];
    [self addSubview:sheetBaseContentView];
    _sheetBaseContentView = sheetBaseContentView;
    
    UIView *textContentView = [[UIView alloc]init];
    textContentView.backgroundColor = [UIColor whiteColor];
    [sheetBaseContentView addSubview:textContentView];
    _textContentView = textContentView;
    
    UIScrollView *buttonContentView = [[UIScrollView alloc]init];
    buttonContentView.bounces = NO;
    buttonContentView.backgroundColor = [UIColor clearColor];
    buttonContentView.userInteractionEnabled = YES;
    [sheetBaseContentView addSubview:buttonContentView];
    _buttonContentView = buttonContentView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 30, MScreenW - 48, 60);
    cancelButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 8;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = _buttonFont;
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(actionCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    _cancelButton = cancelButton;
    
}

- (void)addTextLabels{
    
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    messageLabel.textColor = [UIColor colorWithRed:153/255.0 green:169/255.0 blue:191/255.0 alpha:1.0];
    [_textContentView addSubview:messageLabel];
    _messageLabel = messageLabel;
}

- (void)didMoveToSuperview{
    if (self.superview) {
        [self layoutContentViews];
        [self layoutTextLabels];
    }
}

- (void)addAction:(MHVoAlertAction *)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:action.title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.font = _buttonFont;
    button.backgroundColor = [UIColor whiteColor];
    button.enabled = action.enabled;
    button.tag = kButtonTagOffset + _buttons.count;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (action.style == MHAlertActionStyleSelected) {
        [button setImage:[UIImage imageNamed:@"vo_home_sheet_selected"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 36);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    }
    
    [_buttonContentView addSubview:button];
    [_buttons addObject:button];
    [_actions addObject:action];
    
    if (_buttons.count == 1) {
        [self layoutContentViews];
        [self layoutTextLabels];
    }
    
    [self layoutButtons];
}

#pragma mark - layout contenview

- (void)layoutContentViews{
   
    NSInteger limit_count = MIN(_buttons.count, 6);
    CGFloat baseContentViewHeight = limit_count * KButtonHeight + (limit_count - 1) * kButtonSpace + 40;
    self.frame = CGRectMake(0, MScreenH - baseContentViewHeight - 108, MScreenW, baseContentViewHeight + 108);

    _buttonContentView.contentSize = CGSizeMake(MScreenW - 48, baseContentViewHeight - 40);
    
    [_sheetBaseContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(-108);
        make.height.mas_equalTo(baseContentViewHeight);
    }];
    
    [_buttonContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [_textContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(39.5);
    }];
    
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-32);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(60);
    }];
}

- (void)layoutTextLabels
{
    [_messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.centerX.mas_equalTo(self.textContentView);
    }];
}

- (void)layoutButtons
{
    UIButton *button = _buttons.lastObject;
    if (_buttons.count == 1) {
        _buttonTopConstraint.constant = -_buttonContentViewTop;
        [_buttonContentView addConstraintToView:button edgeInset:UIEdgeInsetsZero];
        [button addConstraintWidth:MScreenW - 48 height:_buttonHeight];
    }else{

        UIButton *lastSecondBtn = _buttons[_buttons.count - 2];
        [_buttonContentView removeConstraintWithView:lastSecondBtn attribute:NSLayoutAttributeBottom];
        [_buttonContentView addConstraintWithTopView:lastSecondBtn toBottomView:button constant:_buttonSpace];
        [_buttonContentView addConstraintWithView:button topView:nil leftView:_buttonContentView bottomView:_buttonContentView rightView:_buttonContentView edgeInset:UIEdgeInsetsZero];
        [_buttonContentView addConstraintEqualWithView:button widthToView:lastSecondBtn heightToView:lastSecondBtn];
    }
}


#pragma mark - action

- (void)actionButtonClicked:(UIButton *)button
{
    MHVoAlertAction *action = _actions[button.tag - kButtonTagOffset];
    
    if (_clickedAutoHide) {
        [self hideView];
    }
    
    if (action.handler) {
        action.handler(button.tag - kButtonTagOffset);
    }
}

- (void)actionCancelClicked:(UIButton *)button {
    if (_clickedAutoHide) {
        [self hideView];
    }
}

@end
