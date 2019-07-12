//
//  MHVoDataFillController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoDataFillController.h"
#import "MHMacros.h"
#import "UIViewController+CameraSheet.h"
#import "MHLoSetPlotController.h"
#import "MHVoDataPhoneController.h"
#import "MHVoAddressAddController.h"
#import "MHThemeButton.h"
#import "MHNavigationControllerManager.h"
#import "MHVoHobbyController.h"
#import "MHVolCreateModel.h"
#import "MHUserInfoManager.h"
#import "UIView+NIM.h"
#import "JFAuthorizationStatusManager.h"
#import "UIImage+Color.h"
#import "MHConst.h"
#import <HLCategory/UIViewController+HLStoryBoard.h>
#import "UIViewController+MHBackToRoot.h"
#import "MHVolunteerDataHandler.h"
#import "MHHUDManager.h"

@interface MHVoDataFillController ()<UITextFieldDelegate,MHNavigationControllerManagerProtocol>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *lineHeightConstraints;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoW;
@property (weak, nonatomic) IBOutlet UITextField *sexField;
@property (weak, nonatomic) IBOutlet UITextField *identityField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet MHThemeButton *nextButton;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *arrowRights;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *identity;

@property (nonatomic,assign) BOOL hasImage;
@property (nonatomic,strong) UIImage *image;
@end

@implementation MHVoDataFillController{
    CGFloat topOffset;
    CGFloat lineHeight;
    MHVolCreateModel *_model;
    CGFloat scale;
}

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mhIconView = self.photoImageView;
    scale = MScreenW/375;
    for (NSLayoutConstraint *constraint in self.arrowRights) {
        constraint.constant = constraint.constant*scale;
    }
    [self setupConstraints];
    [self setupContainerLayer];

    self.phoneField.text = [MHUserInfoManager sharedManager].phone_number;
    self.phone = [MHUserInfoManager sharedManager].phone_number;
    self.sexField.text = [MHUserInfoManager sharedManager].sex;
    
    //延迟一会，主要是避免机器速度太快，还没赋值完就已经执行完了viewDidLoad 这时候获取的值就是默认值而非传过来的值
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.fromIndex == 1){
            [self resetBackNaviItem];
        }
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarTranslucent];
    nav.navigationBar.shadowImage = [UIImage mh_imageWithColor:[UIColor clearColor]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)resetBackNaviItem{
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(nav_back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
- (void)nav_back{
    [self.navigationController backToHome];
}

#pragma mark - navDelegate
- (BOOL)bb_ShouldBack{
    if(self.fromIndex == 1){
        return NO;
    }
    [MHVolCreateModel sharedInstance].address.city = nil;
    [MHVolCreateModel sharedInstance].address.community = nil;
    [MHVolCreateModel sharedInstance].address.room = nil;
    [MHUserInfoManager sharedManager].volUserInfo.address.localWrite = NO;
    
    if (self.hasImage) {
        [self exitApplyAlert];
        return NO;
    }
    for (UITextField *textField in self.textFields) {
        if ( (textField!=self.phoneField && textField.text.length) || (textField==self.phoneField&&![textField.text isEqualToString:[MHUserInfoManager sharedManager].phone_number]) ) {
            [self exitApplyAlert];
            return NO;
        }
    }
    
    //beelin 2017.08.08 需求让我写了一个发通知
    if (self.loginFlag) {
         [[NSNotificationCenter defaultCenter] postNotificationName:kComeinAPPNotification object:nil];
    }
    return YES;
}

#pragma mark - 按钮点击
- (IBAction)next {
    [self.view endEditing:YES];
    _model = [MHVolCreateModel sharedInstance];
    _model.real_name = self.nameField.text;
    _model.sex = [self.sexField.text isEqualToString:@"男"] ? @1 :@2;
    _model.phone = self.phone;
    _model.image = self.image;
    _model.identity_card = self.identityField.text;
    [self push];
}

- (IBAction)choosePhoto{
    [self.view endEditing:YES];
    
    UIAlertController *alert = [self mh_showCameraSheet];
    
    UILabel *yellowLabel = [[UILabel alloc] init];
    yellowLabel.font = [UIFont systemFontOfSize:17*MScreenW/375];
    yellowLabel.textColor = MRGBColor(255, 216, 0);
    yellowLabel.text = @"非本人照片或卡通头像将无法通过申请";
    [yellowLabel sizeToFit];
    yellowLabel.nim_height = 24*MScreenW/375;
    yellowLabel.nim_bottom = -24*MScreenW/375;
    yellowLabel.nim_centerX = alert.view.nim_width/2 - 10*MScreenW/375;
    [alert.view addSubview:yellowLabel];
    
    UILabel *middleLabel = [[UILabel alloc] init];
    middleLabel.font = MFont(22*MScreenW/375);
    middleLabel.textColor = [UIColor whiteColor];
    middleLabel.text = @"请提供您本人的免冠正面照片";
    [middleLabel sizeToFit];
    middleLabel.nim_height = 40*MScreenW/375;
    middleLabel.nim_centerX = alert.view.nim_width/2 - 10*MScreenW/375;
    middleLabel.nim_bottom = yellowLabel.nim_top;
    [alert.view addSubview:middleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vo_photo_tips"]];
    imageView.nim_size = CGSizeMake(100*MScreenW/375, 100*MScreenW/375);
    imageView.nim_centerX = alert.view.nim_width/2 - 10*MScreenW/375;
    imageView.nim_bottom = middleLabel.nim_top - 24*MScreenW/375;
    [alert.view addSubview:imageView];
}

- (IBAction)sexChoose {
    
    [self.view endEditing:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexField.text = @"男";
        [self enableNext];
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexField.text = @"女";
        [self enableNext];
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

- (void)push{
    [self.navigationController pushViewController:[MHVoHobbyController new] animated:YES];
    
}

- (IBAction)addressButtonDidClick {
    
    BOOL isLocalWrite = [MHUserInfoManager sharedManager].volUserInfo.address.isLocalWrite;
    
    if (isLocalWrite) {
        MHVoAddressAddController *vc = [[MHVoAddressAddController alloc] init];
        vc.type = MHVoAddressAddTypeFillDatas;
        vc.confirmBlock = ^(NSString *room_info) {
            self.addressField.text = room_info;
            [self enableNext];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSNumber *community_id = [MHUserInfoManager sharedManager].community_id;
        [MHHUDManager show];
        [MHVolunteerDataHandler postVolunteerApplyCheckHasRoom:community_id Success:^(NSDictionary *data) {
            if ([data[@"is_has_room"] integerValue] == 1) {
                MHLoSetPlotController *vc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:@"MHLoSetPlotController"];
                vc.setType = MHLoSetPlotTypeAddress;
                
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                MHVoAddressAddController *vc = [[MHVoAddressAddController alloc] init];
                vc.type = MHVoAddressAddTypeFillDatasNoRoom;
                vc.confirmBlock = ^(NSString *room_info) {
                    self.addressField.text = room_info;
                    [self enableNext];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
            [MHHUDManager dismiss];
        } Failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
        
    }
}

- (IBAction)phoneOrNameButtonDidClick:(UIButton *)sender{
    MHVoDataPhoneController *vc = [[MHVoDataPhoneController alloc] init];
    vc.type = sender.tag;
    
    if (sender.tag == 0) {
        vc.string = self.name;
    }else if (sender.tag == 1){
        vc.string = self.phone;
    }else if (sender.tag == 4){
        vc.string = self.identity;
    }
    __weak typeof (self)ws = self;
    [vc setConfirmBlock:^(NSString *string){
        if (sender.tag == 1) {
            ws.phoneField.text = string;
            ws.phone = string;
        }else if (sender.tag == 0){
            ws.nameField.text = string.length > 4 ? [[string substringToIndex:4] stringByAppendingString:@"..."] : string;
            ws.name = string;
        }else if (sender.tag == 4){
            ws.identityField.text = string;
            ws.identity = string;
        }
        [ws enableNext];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 相机代理
- (void)dosomethingWithImage:(UIImage *)image {
    self.photoImageView.image = image;
    self.hasImage = YES;
    self.image = image;
    [self enableNext];
}


#pragma mark - private
- (void)setRoom_info:(NSString *)room_info{
    _room_info = room_info;
    self.addressField.text = room_info;
    [self enableNext];
}

- (void)exitApplyAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出志愿者申请？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(self.fromIndex == 1){//从积分支付过来的
            [self nav_back];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        //beelin 2017.08.08 需求让我写了一个发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kComeinAPPNotification object:nil];
    }];
    if (iOS8_2_OR_LATER) {
        [action1 setValue:MColorTitle forKey:@"titleTextColor"];
        [action2 setValue:MColorTitle forKey:@"titleTextColor"];
    }
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)enableNext{
    BOOL hasText = YES;
    for (UITextField *textField in self.textFields) {
        if (textField.text.length == 0) {
            hasText = NO;
            break;
        }
    }
    self.nextButton.enabled = self.hasImage &&hasText;
}

- (void)setupConstraints{
    for (UITextField *textField in self.textFields) {
        textField.borderStyle = UITextBorderStyleNone;
    }
    self.top.constant = 64;
    if (MScreenW == 320) {
        topOffset = -70;
        lineHeight = 0.5;
    }else if (MScreenW == 375){
        topOffset = 0;
        lineHeight = 0.5;
    }else{
        topOffset = 0;
        lineHeight = 1;
    }
    for (NSLayoutConstraint *constraint in self.lineHeightConstraints) {
        constraint.constant = lineHeight;
    }
    
}

- (void)setupContainerLayer{
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.borderColor = MRGBColor(211, 220, 231).CGColor;
    self.containerView.layer.borderWidth = 1;
    
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowRadius = 5;
    self.containerView.layer.shadowColor = MRGBColor(239,242,247).CGColor;
    self.containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.containerView.layer.shadowOpacity = 1;
    
    self.photoImageView.layer.cornerRadius = self.photoW.constant/2;
    self.photoImageView.layer.masksToBounds = YES;
    
}

@end





