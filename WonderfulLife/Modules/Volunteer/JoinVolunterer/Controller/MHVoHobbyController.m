//
//  MHVoHobbyController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoHobbyController.h"
#import "MHHobbyButton.h"
#import "MHMacros.h"
#import <Masonry.h>
#import "UIView+NIM.h"
#import "MHVolunteerSupportRequestHandler.h"
#import "MHWeakStrongDefine.h"
#import "MHThemeButton.h"
#import "MHVolunteerSupportController.h"
#import "MHVolCreateModel.h"
#import <YYModel.h>
#import "MHHUDManager.h"
#import "MHUserInfoManager.h"
#import "MHVolunteerDataHandler.h"
#import "MHVoHobbyModel.h"
#import "MHHobyAlertView.h"

@interface MHVoHobbyController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (nonatomic,weak) UIButton *lastTopButton;
@property (nonatomic,strong) MHHobbyButton *addButton;
@property (weak, nonatomic) IBOutlet MHThemeButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *choosedLabel;
@property (nonatomic,strong) UIAlertAction *confirm;
@property (nonatomic,weak) UITextField *textField;
@property (nonatomic,assign) NSInteger choosedCount;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;

@end

@implementation MHVoHobbyController{
    CGFloat buttonW;
    CGFloat buttonH;
    CGFloat buttonMargin;
    NSInteger kMaxLength;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (MScreenW == 320) {
        buttonW = 61.2;
        buttonH = 86.7;
        buttonMargin = 20.4;
        self.top.constant = 64;
    }else if (MScreenW == 375){
        buttonW = 72;
        buttonH = 102;
        buttonMargin = 24;
    }else if (MScreenW == 414){
        buttonW = 79.2;
        buttonH = 112.2;
        buttonMargin = 26.4;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    kMaxLength = 8;
    [self setupNavBar];
    [self setupButtons];
    
    if (self.type == MHVoHobbyControllerTypeModify) {
        NSNumber *volunteer_id = [MHUserInfoManager sharedManager].volunteer_id;
        
        [MHHUDManager show];
        
        [MHVolunteerDataHandler getVoSerTheSupportListOfMyCard:volunteer_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            [MHHUDManager dismiss];
            if (success) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[MHVoHobbyModel class] json:data];
                for (NSInteger i = 0; i < 22; i++) {
                    MHVoHobbyModel *model = array[i];
                    MHHobbyButton *hobbyButton = self.containerView.subviews[i];
                    hobbyButton.selected = model.is_own;
                    if (hobbyButton.selected) {
                        self.choosedCount++;
                    }
                }
                if (array.count>22) {
                    NSArray *customArr = [array subarrayWithRange:NSMakeRange(22, array.count-22)];
                    for (NSInteger i = 0; i < customArr.count; i++) {
                        MHVoHobbyModel *model = customArr[i];
                        MHHobbyButton *customButton = [[MHHobbyButton alloc] init];
                        customButton.custom = YES;
                        customButton.selected = YES;
                        [customButton setImage:[UIImage imageNamed:@"Vo_hobby_custom"] forState:UIControlStateNormal];
                        if (model.tag_name.length > 4) {
                            model.tag_name = [[model.tag_name substringToIndex:4] stringByAppendingString:@"..."];
                        }
                        [customButton setTitle:model.tag_name forState:UIControlStateNormal];
                        [customButton.deleteButton addTarget:self action:@selector(removeCustom:) forControlEvents:UIControlEventTouchUpInside];
                        
                        customButton.tag = model.tag_id;
                        NSInteger count = self.containerView.subviews.count;
                        [self.containerView insertSubview:customButton atIndex:count-1];
                        CGRect frame = self.addButton.frame;
                        customButton.frame = frame;
                        
                        if (count % 3 == 0){
                            self.lastTopButton = customButton;
                        }
                        self.addButton.nim_top = self.lastTopButton.nim_bottom + buttonMargin;
                        
                        count = count+1;
                        if (count%3 == 1) {
                            self.addButton.nim_centerX = MScreenW/5;
                        }else if (count%3 == 2){
                            self.addButton.nim_centerX = MScreenW/2;
                        }else if (count % 3 == 0){
                            self.addButton.nim_centerX = MScreenW*4/5;
                        }
                        
                        self.choosedCount++;
                    }
                    self.containerH.constant = self.addButton.nim_bottom;
                }
                
            }else{
                [MHHUDManager showErrorText:errmsg];
            }
        }];
    }
}

#pragma mark - private
- (void)setupNavBar{
    UIButton *skipButton = [[UIButton alloc] init];
    
    if (self.type == MHVoHobbyControllerTypeModify) {
        [skipButton setTitleColor:MColorConfirmBtn forState:UIControlStateNormal];
        [skipButton setTitle:@"确定" forState:UIControlStateNormal];

        [skipButton addTarget:self action:@selector(ChooseConfirm) forControlEvents:UIControlEventTouchUpInside];

        self.bottomBaseView.hidden = YES;
    }else{
        [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [skipButton setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    }
    
    skipButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [skipButton sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
}

- (void)setChoosedCount:(NSInteger)choosedCount{
    _choosedCount = choosedCount;
    self.choosedLabel.text = [NSString stringWithFormat:@"可多选，已选择%zd个",choosedCount];
    self.nextButton.enabled = choosedCount;
}

- (void)setupButtons{
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"唱歌",@"跳舞",@"乐器",@"诗歌",@"快板",@"写作",@"书画",@"乒乓球",@"篮球",@"足球",@"羽毛球",@"跑步",@"太极",@"钓鱼",@"棋牌",@"心理学",@"国学",@"法律",@"电脑",@"工程",@"理发",@"医疗护理", nil];
    
    for (NSInteger i = 1; i <= 22; i++) {
        MHHobbyButton *button = [[MHHobbyButton alloc] init];
        NSString *img = [NSString stringWithFormat:@"Vo_hobby_%02zd",i];
        [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Vo_hobby_selected_%02zd",i] ] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titleArr[i-1] forState:0];
        button.tag = i;
        [self.containerView addSubview:button];
        button.nim_size = CGSizeMake(buttonW, buttonH);
        if (i>3) {
            button.nim_top = self.lastTopButton.nim_bottom + buttonMargin;
        }
        if (i%3 == 1) {//换行
            button.nim_centerX = MScreenW/5;
        }else if (i%3 == 2){
            button.nim_centerX = MScreenW/2;
        }else if (i % 3 == 0){
            button.nim_centerX = MScreenW*4/5;
            self.lastTopButton = button;
        }
    }
    
    self.addButton.nim_top = self.lastTopButton.nim_bottom + buttonMargin;
    _addButton.nim_size = CGSizeMake(buttonW, buttonH);
    NSInteger count = self.containerView.subviews.count;
    if (count%3 == 1) {
        self.addButton.nim_centerX = MScreenW/5;
    }else if (count%3 == 2){
        self.addButton.nim_centerX = MScreenW/2;
    }else if (count % 3 == 0){
        self.addButton.nim_centerX = MScreenW*4/5;
    }
    self.containerH.constant = _addButton.nim_bottom;
}

#pragma mark - 按钮点击
- (void)buttonDidSelected:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.choosedCount++;
    }else{
        self.choosedCount--;
    }
}

- (void)skip{
    MHVolunteerSupportController *vc = [MHVolunteerSupportController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)ChooseConfirm{
    [MHHUDManager show];
    NSMutableArray *list = [NSMutableArray array];
    for (MHHobbyButton *button in self.containerView.subviews) {
        if (button.isSelected) {
            [list addObject:@(button.tag)];
        }
    }

    [MHVolunteerDataHandler postVoSerModifyTheHobbyListOfMyCard:[MHUserInfoManager sharedManager].volunteer_id HobbyArray:[list yy_modelToJSONString] request:^(NSDictionary *data) {
        [MHHUDManager dismiss];
        !self.refreshBlock ? : self.refreshBlock();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

- (void)sureAddAction{
    for (MHHobbyButton *customButton in self.containerView.subviews) {
        if ([customButton.currentTitle isEqualToString:self.textField.text]) {
            if (customButton.custom) {
                [MHHUDManager showErrorText:@"您已添加过该标签"];
            }else{
                if (customButton.isSelected == NO) {
                    customButton.selected = YES;
                    self.choosedCount++;
                }
            }
            CGRect rect = [self.containerView convertRect:customButton.frame toView:self.scrollView];
            rect.origin.y -= 64;
            [self.scrollView scrollRectToVisible:rect animated:YES];
            return ;
        }
    }
    
    [MHVolunteerSupportRequestHandler uploadCustomHobby:self.textField.text Success:^(long tag_id,NSString *tag_name) {
        MHHobbyButton *customButton = [[MHHobbyButton alloc] init];
        customButton.custom = YES;
        customButton.selected = YES;
        [customButton setImage:[UIImage imageNamed:@"Vo_hobby_custom"] forState:UIControlStateNormal];
        if (tag_name.length > 4) {
            tag_name = [[tag_name substringToIndex:4] stringByAppendingString:@"..."];
        }
        [customButton setTitle:tag_name forState:UIControlStateNormal];
        [customButton.deleteButton addTarget:self action:@selector(removeCustom:) forControlEvents:UIControlEventTouchUpInside];
        
        customButton.tag = tag_id;
        NSInteger count = self.containerView.subviews.count;
        [self.containerView insertSubview:customButton atIndex:count-1];
        CGRect frame = self.addButton.frame;
        customButton.frame = frame;
        
        if (count % 3 == 0){
            self.lastTopButton = customButton;
        }
        self.addButton.nim_top = self.lastTopButton.nim_bottom + buttonMargin;
        
        count = count+1;
        if (count%3 == 1) {
            self.addButton.nim_centerX = MScreenW/5;
        }else if (count%3 == 2){
            self.addButton.nim_centerX = MScreenW/2;
        }else if (count % 3 == 0){
            self.addButton.nim_centerX = MScreenW*4/5;
        }
        
        self.containerH.constant = self.addButton.nim_bottom;
        
        self.choosedCount++;
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}


- (void)addHobby:(UIButton *)button{
    
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
        
    });
    
    __block MHHobyAlertView *alertView = [MHHobyAlertView  loadViewFromXib];
    alertView.buttonClikBlock = ^(NSInteger index){
        alertView = nil;
        if(index == 1){
            [self sureAddAction];
        }
    };
    self.textField = alertView.hobyTextF;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:alertView.hobyTextF];
    [alertView show];
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加兴趣爱好" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    
//    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:@"添加兴趣爱好"];
//    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:NSMakeRange(0, 6)];
//    [titleText addAttribute:NSForegroundColorAttributeName value:MRGBColor(50, 64, 87) range:NSMakeRange(0, 6)];
//    [alert setValue:titleText forKey:@"attributedTitle"];
//    
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"最多输入8个字符";
//        textField.font = [UIFont systemFontOfSize:17];
//        textField.textColor = MRGBColor(50, 64, 87);
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:textField];
//        self.textField = textField;
//    }];
//    
//    MHWeakify(self);
//    self.confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        for (MHHobbyButton *customButton in weak_self.containerView.subviews) {
//            if ([customButton.currentTitle isEqualToString:weak_self.textField.text]) {
//                if (customButton.custom) {
//                    [MHHUDManager showErrorText:@"您已添加过该标签"];
//                }else{
//                    if (customButton.isSelected == NO) {
//                        customButton.selected = YES;
//                        self.choosedCount++;
//                    }
//                }
//                CGRect rect = [weak_self.containerView convertRect:customButton.frame toView:weak_self.scrollView];
//                rect.origin.y -= 64;
//                [weak_self.scrollView scrollRectToVisible:rect animated:YES];
//                return ;
//            }
//        }
//        
//        [MHVolunteerSupportRequestHandler uploadCustomHobby:weak_self.textField.text Success:^(long tag_id,NSString *tag_name) {
//            MHHobbyButton *customButton = [[MHHobbyButton alloc] init];
//            customButton.custom = YES;
//            customButton.selected = YES;
//            [customButton setImage:[UIImage imageNamed:@"Vo_hobby_custom"] forState:UIControlStateNormal];
//            if (tag_name.length > 4) {
//                tag_name = [[tag_name substringToIndex:4] stringByAppendingString:@"..."];
//            }
//            [customButton setTitle:tag_name forState:UIControlStateNormal];
//            [customButton.deleteButton addTarget:weak_self action:@selector(removeCustom:) forControlEvents:UIControlEventTouchUpInside];
//            
//            customButton.tag = tag_id;
//            NSInteger count = weak_self.containerView.subviews.count;
//            [weak_self.containerView insertSubview:customButton atIndex:count-1];
//            CGRect frame = weak_self.addButton.frame;
//            customButton.frame = frame;
//
//            if (count % 3 == 0){
//                weak_self.lastTopButton = customButton;
//            }
//            weak_self.addButton.nim_top = weak_self.lastTopButton.nim_bottom + buttonMargin;
//
//            count = count+1;
//            if (count%3 == 1) {
//                weak_self.addButton.nim_centerX = MScreenW/5;
//            }else if (count%3 == 2){
//                weak_self.addButton.nim_centerX = MScreenW/2;
//            }else if (count % 3 == 0){
//                weak_self.addButton.nim_centerX = MScreenW*4/5;
//            }
//
//            weak_self.containerH.constant = weak_self.addButton.nim_bottom;
//            
//            self.choosedCount++;
//        } failure:^(NSString *errmsg) {
//            [MHHUDManager dismiss];
//            [MHHUDManager showErrorText:errmsg];
//        }];
//    }];
//    
//    _confirm.enabled = NO;
//    [_confirm setValue:MRGBColor(192, 204, 218) forKey:@"titleTextColor"];
//    [alert addAction:_confirm];
//    
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [cancel setValue:MRGBColor(50, 64, 87) forKey:@"titleTextColor"];
//    [alert addAction:cancel];
//    
//    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)removeCustom:(UIButton *)button{
    MHHobbyButton *customButton = (MHHobbyButton *)button.superview;
    NSInteger index = [self.containerView.subviews indexOfObject:customButton];
    
    __block NSMutableArray *nextButtons = [NSMutableArray array];
    __block NSMutableArray *nextFrames = [NSMutableArray array];
    for (NSInteger i = index+1; i < self.containerView.subviews.count; i++) {
        MHHobbyButton *nextButton = self.containerView.subviews[i];
        [nextButtons addObject:nextButton];
        
    }
    for (NSInteger i = index; i < self.containerView.subviews.count-1; i++) {
        MHHobbyButton *button = self.containerView.subviews[i];
        [nextFrames addObject:[NSValue valueWithCGRect:button.frame]];
    }
    
    [customButton removeFromSuperview];
    
    NSInteger count = self.containerView.subviews.count;
    if (count%3 == 0) {//最后是加号
        self.lastTopButton = self.containerView.subviews[count-4];
    }else{
        NSInteger lastTopIndex = count - count%3 -1;
        self.lastTopButton = self.containerView.subviews[lastTopIndex];
    }
    [UIView animateWithDuration:0.3 animations:^{
        for (NSInteger i = 0; i < nextButtons.count; i++) {
            MHHobbyButton *nextButton = nextButtons[i];
            nextButton.frame = [nextFrames[i] CGRectValue];
        }
    } completion:^(BOOL finished) {
        nextButtons = nil;
        nextFrames = nil;
        self.containerH.constant = self.addButton.nim_bottom;
    }];
    
    self.choosedCount --;
}

- (IBAction)next {
    NSMutableArray *list = [NSMutableArray array];
    for (MHHobbyButton *button in self.containerView.subviews) {
        if (button.isSelected) {
            [list addObject:@(button.tag)];
        }
    }
    [MHVolCreateModel sharedInstance].tag_list = [list yy_modelToJSONString]; 
    MHVolunteerSupportController *vc = [MHVolunteerSupportController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - textFieldDelegate
-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    self.confirm.enabled = textField.text.length;
    if (iOS8_2_OR_LATER) {
        if (self.confirm.enabled) {
            [_confirm setValue:MRGBColor(32, 160, 255) forKey:@"titleTextColor"];
        }else{
            [_confirm setValue:MRGBColor(192, 204, 218) forKey:@"titleTextColor"];
        }
    }
    
    NSString *toBeString = textField.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position && toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

- (IBAction)atLeastOne {
    [MHHUDManager showText:@"请选择至少一项"];
}

#pragma mark - lazy
- (MHHobbyButton *)addButton{
    if (_addButton == nil) {
        _addButton = [[MHHobbyButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"Vo_hobby_add"] forState:UIControlStateNormal];
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addHobby:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:_addButton];
        
    }
    return _addButton;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
    NSLog(@"%s",__func__);
}

@end





