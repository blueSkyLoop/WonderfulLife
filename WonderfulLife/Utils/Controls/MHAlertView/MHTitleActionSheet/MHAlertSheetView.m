//
//  LAlertSheetView.m
//  AlertDemo
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import "MHAlertSheetView.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "NSObject+isNull.h"
@implementation MHAlertConfig

- (id)initWithTitle:(NSString *)atitle image:(UIImage *)aimage{
    self = [super init];
    if(self){
        self.title = atitle;
        self.image = aimage;
    }
    return self;
}

@end

@interface MHAlertSheetView()
@property (nonatomic,strong)NSArray *buttons;
@property (nonatomic,copy)NSString *atitle;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)BOOL showing;
@property (nonatomic,copy)void(^compleBlock)(NSInteger index);
@end

@implementation MHAlertSheetView

- (instancetype)initWithTitle:(NSString *)title buttons:(NSArray <MHAlertConfig *>*)buttons comple:(void(^)(NSInteger index))comple{
    self = [super init];
    if(self){
        _buttons = buttons;
        _atitle = title;
        self.compleBlock = [comple copy];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    width = width - 24 * 2;
    
    UIView *tapView = [UIView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tapView addGestureRecognizer:tap];
    [self addSubview:tapView];
    
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
    
    [self addSubview:self.bgView];
    UIView *temView ;
    UILabel *atitleLabel ;
    
    if (![NSObject isNull:self.atitle]) { // 标题不为空
        atitleLabel = [UILabel new];
        atitleLabel.backgroundColor = [UIColor whiteColor];
        atitleLabel.font = [UIFont systemFontOfSize:12];
        atitleLabel.textColor = [UIColor colorWithRed:146/255.0 green:163/255.0 blue:187/255.0 alpha:1.0];
        atitleLabel.text = self.atitle;
        [self.bgView addSubview:atitleLabel];
        [atitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(self.bgView.mas_left).offset(24);
            make.top.equalTo(self.bgView.mas_top).offset(12);
            make.right.lessThanOrEqualTo(self.bgView.mas_right).offset(-24);
            make.centerX.equalTo(self.bgView.mas_centerX).priorityHigh();
        }];
        temView = atitleLabel ;
    }else {
        temView = tapView;
    }
    
    
    for(int i=0;i<self.buttons.count;i++){
        UIButton *btn = [self createButtonWith:self.buttons[i]];
        btn.tag = 1000+i;
        [self.bgView addSubview:btn];
        
        UIView *segmentView = [UIView new];
        segmentView.backgroundColor = MColorSeparator;
        [self.bgView addSubview:segmentView];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (![NSObject isNull:self.atitle]) { // 标题不为空
                    make.top.equalTo(temView.mas_bottom).offset(i?0:12);
            }else {
                make.top.equalTo(temView.mas_bottom).offset(0);
            }
            
            make.centerX.equalTo(self.bgView.mas_centerX).priorityHigh();
            make.height.equalTo(@60).priorityHigh();
            make.width.equalTo(@(width)).priorityHigh();
            if(i == self.buttons.count - 1){
                make.bottom.equalTo(self.bgView.mas_bottom);
            }
        }];
        
        [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_top);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        temView = btn;
    }
    
    UIButton *cancel = [UIButton new];
    cancel.titleLabel.font = [UIFont systemFontOfSize:18];
    cancel.layer.cornerRadius = 8;
    cancel.layer.masksToBounds = YES;
    cancel.tag = 2000;
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitleColor:MColorToRGB(0X99A9BF) forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(buttonClikAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tapView.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(width)).priorityHigh();
    }];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(12);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-32);
        make.height.equalTo(@60).priorityHigh();
        make.width.equalTo(@(width)).priorityHigh();
    }];
    
//    [self.bgView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//    [tapView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
}

- (void)buttonClikAction:(UIButton *)sender{
    if(sender.tag != 2000){
        if(self.compleBlock){
            self.compleBlock(sender.tag - 1000);
        }
    }
    [self hiddenAlert];
}

- (UIButton *)createButtonWith:(MHAlertConfig *)model{
    UIButton *button = [UIButton new];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    if(model.image){
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:model.title forState:UIControlStateNormal];
    [button setImage:model.image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClikAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self hiddenAlert];
}

- (void)show{
    if(self.showing) return;
    __block CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.frame = rect;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.showing = YES;
    [UIView animateWithDuration:0.3 animations:^{
        rect.origin.y = 0;
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.showing = NO;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    }];
}

- (void)hiddenAlert{
    if(self.showing) return;
    __block CGRect rect = self.frame;
    self.showing = YES;
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        rect.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.showing = NO;
        [self removeFromSuperview];
    }];
}

#pragma mark - lazy load

- (UIView *)bgView{
    if(!_bgView){
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}


@end
