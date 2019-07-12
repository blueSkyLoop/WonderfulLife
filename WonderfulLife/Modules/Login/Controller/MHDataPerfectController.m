//
//  MHDataPerfectController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHDataPerfectController.h"
#import "JFAuthorizationStatusManager.h"
#import "MHMacros.h"
#import "MHThemeButton.h"
#import "MHLoginRequestHandler.h"
#import "MHVolunteerIntroduceController.h"
#import "MHHUDManager.h"
#import "UIViewController+CameraSheet.h"
#import "MHAliyunManager.h"
#import "MHVoBirthdayPickerView.h"
#import "MHJPushRequestHandle.h"

@interface MHDataPerfectController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MHThemeButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadIconButton;
@property (weak, nonatomic) IBOutlet UIButton *reviseButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IconButtonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,copy) NSString *birthdayStr;

@property (nonatomic,assign) BOOL hasImage;
@property (nonatomic,strong) UIImage *image;

@end

@implementation MHDataPerfectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContainerLayer];
    self.commitButton.enabled = NO;
    self.nameField.borderStyle = UITextBorderStyleNone;
    self.ageField.borderStyle = UITextBorderStyleNone;
    self.age = -1;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    [self setupNavBar];
    
    if (MScreenW == 320) {
        self.top.constant = 64;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }else if (MScreenW == 375){
        
    }else{
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - 按钮点击
- (void)skip{
    [self.view endEditing:YES];
    
    [MHLoginRequestHandler postVolunteerCountSuccess:^(NSInteger head_count) {
        MHVolunteerIntroduceController *vc = [MHVolunteerIntroduceController new];
        vc.count = head_count;
        [MHJPushRequestHandle JPushReg:nil];
        [MHHUDManager dismiss];
        [self.navigationController pushViewController:vc  animated:YES];
        
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

- (IBAction)chooseIcon {
    [self.view endEditing:YES];
    
    [self mh_showCameraSheet];
}

- (IBAction)commit {
    if (self.hasImage) {
        [MHHUDManager show];
        [[MHAliyunManager sharedManager] uploadImageToAliyunWithImage:self.image success:^(MHOOSImageModel *imageModel) {
            [MHLoginRequestHandler dataPerfectWithName:self.nameField.text Sex:self.sexLabel.text Birthday:self.birthdayStr Image:imageModel success:^{
                [MHHUDManager dismiss];
                [self skip];
                
            } failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }];
            
        } failed:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
        
    }else{
        [MHHUDManager show];
        [MHLoginRequestHandler dataPerfectWithName:self.nameField.text Sex:self.sexLabel.text Birthday:self.birthdayStr  Image:nil success:^{
            [MHHUDManager dismiss];
            [self skip];
        } failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
    }
}

- (IBAction)chooseSex {
    [self.view endEditing:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexLabel.text = @"男";
        self.sexLabel.textColor =  [UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1/1.0];
        self.commitButton.enabled = YES;
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexLabel.text = @"女";
        self.sexLabel.textColor =  [UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1/1.0];
        self.commitButton.enabled = YES;
    }];
    [alert addAction:action2];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action3];
    
    if (iOS8_2_OR_LATER) {
        [action1 setValue:MColorTitle forKey:@"titleTextColor"];
        [action2 setValue:MColorTitle forKey:@"titleTextColor"];
        [action3 setValue:MColorContent forKey:@"titleTextColor"];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)chooseAge {
    [self.view endEditing:YES];
    MHVoBirthdayPickerView *birthdayPickerView = [[MHVoBirthdayPickerView alloc] init];
    birthdayPickerView.type = MHVoBirthdayPickerViewTypeAge;
    birthdayPickerView.age = self.age;
    [birthdayPickerView setConfirmAgeBlock:^(NSString *birthdayStr,NSInteger age){
        self.ageField.text = [NSString stringWithFormat:@"%zd岁",age];
        self.age = age;
        self.birthdayStr = birthdayStr;
        self.commitButton.enabled = YES;
    }];
    birthdayPickerView.frame = self.view.bounds;
    [self.view addSubview:birthdayPickerView];
    [birthdayPickerView show];
    
}

#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary*info=[notification userInfo];
    CGFloat during = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:during animations:^{
        self.top.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary*info=[notification userInfo];
    CGFloat during = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:during animations:^{
        self.top.constant = 64;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 相机代理
- (void)dosomethingWithImage:(UIImage *)image{
    [self.uploadIconButton setBackgroundImage:image forState:UIControlStateNormal];
    self.image = image;
    self.commitButton.enabled = YES;
    self.hasImage = YES;
    self.reviseButton.hidden = NO;
}

#pragma mark - private
- (void)setupNavBar{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIButton *skipButton = [[UIButton alloc] init];
    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [skipButton sizeToFit];
    [skipButton addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
}

- (void)setupContainerLayer{
    self.uploadIconButton.layer.cornerRadius = self.IconButtonW.constant/2;
    self.uploadIconButton.layer.masksToBounds = YES;
    
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderColor = [UIColor colorWithRed:211/255.0 green:220/255.0 blue:231/255.0 alpha:1/1.0].CGColor;
    self.containerView.layer.borderWidth = 1;
    
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowRadius = 5;
    self.containerView.layer.shadowColor = [UIColor colorWithRed:211/255.0 green:220/255.0 blue:231/255.0 alpha:1/1.0].CGColor;
    self.containerView.layer.shadowOpacity = 1;
    self.containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

#pragma mark - lazy

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length) {
        self.commitButton.enabled = YES;
    }
}
@end





